"""
Course service with business logic for course management.

This service encapsulates all course-related business logic,
including CRUD operations, enrollment, and validation rules.
"""

from uuid import UUID

from fastapi import HTTPException, status
from pymongo.errors import DuplicateKeyError

from app.core.config import settings
from app.core.enums import UserRole
from app.db.models import Course, User
from app.schemas.course import CourseCreate, CourseUpdate


class CourseService:
    """Service class for course management.

    Handles business logic for creating, reading, updating, and deleting courses,
    as well as student enrollment/unenrollment.
    """

    async def create_course(self, data: CourseCreate, instructor: User) -> Course:
        """Create a new course.

        Args:
            data: Course creation data
            instructor: The user creating the course (must be an instructor)

        Raises:
            HTTPException: If user is not an instructor or course title already exists
        """
        if instructor.role != UserRole.INSTRUCTOR:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only instructors can create courses"
            )

        course = Course(**data.model_dump(), instructor=instructor)

        try:
            await course.insert()
        except DuplicateKeyError as err:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="COURSE_ALREADY_EXISTS"
            ) from err

        await course.fetch_all_links()
        return course

    async def list_courses(
        self,
        limit: int = settings.DEFAULT_PAGE_LIMIT,
        offset: int = 0,
        published_only: bool = False
    ) -> tuple[list[Course], int]:
        """
        List courses with pagination.

        Args:
            limit: Maximum number of courses to return
            offset: Number of courses to skip
            published_only: If True, only return published courses

        Returns:
            Tuple of (list of courses, total count)
        """
        # Clamp limit to max
        limit = min(limit, settings.MAX_PAGE_LIMIT)

        query = Course.find_all(fetch_links=True)
        if published_only:
            query = Course.find(Course.is_published, fetch_links=True)

        total = await query.count()
        courses = await query.skip(offset).limit(limit).to_list()

        return courses, total

    async def get_course(self, course_id: UUID) -> Course:
        """
        Get a course by ID.

        Raises:
            HTTPException: If course not found
        """
        course = await Course.get(course_id, fetch_links=True)
        if not course:
            raise HTTPException(status_code=404, detail="Course not found")
        return course

    async def update_course(
        self,
        course_id: UUID,
        data: CourseUpdate,
        current_user: User
    ) -> Course:
        """
        Update a course.

        Only the instructor who created the course can update it.

        Raises:
            HTTPException: If course not found or user is not the instructor
        """
        course = await self.get_course(course_id)

        if course.instructor.id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not the instructor of this course"
            )

        update_data = data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(course, field, value)

        await course.save()
        return course

    async def delete_course(self, course_id: UUID, current_user: User) -> None:
        """
        Delete a course.

        Only the instructor who created the course can delete it.

        Raises:
            HTTPException: If course not found or user is not the instructor
        """
        course = await self.get_course(course_id)

        if course.instructor.id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not the instructor of this course"
            )

        await course.delete()

    async def enroll_student(self, course_id: UUID, student: User) -> Course:
        """
        Enroll a student in a course.

        Raises:
            HTTPException: If user is not a student, course not found,
                          course is not published, or student already enrolled
        """
        if student.role != UserRole.STUDENT:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Only students can enroll in courses"
            )

        course = await self.get_course(course_id)

        # Check if course is published
        if not course.is_published:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot enroll in an unpublished course"
            )

        # Check if already enrolled
        if any(s.id == student.id for s in course.students):
            raise HTTPException(status_code=400, detail="Already enrolled")

        course.students.append(student)
        await course.save()

        return course

    async def unenroll_student(self, course_id: UUID, student: User) -> Course:
        """
        Unenroll a student from a course.

        Raises:
            HTTPException: If user is not a student, course not found,
                          or student is not enrolled
        """
        if student.role != UserRole.STUDENT:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Only students can unenroll from courses"
            )

        course = await self.get_course(course_id)

        # Find student in enrollment list
        enrolled_index = None
        for i, s in enumerate(course.students):
            if s.id == student.id:
                enrolled_index = i
                break

        if enrolled_index is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Not enrolled in this course"
            )

        course.students.pop(enrolled_index)
        await course.save()

        return course


# Singleton instance for dependency injection
course_service = CourseService()


def get_course_service() -> CourseService:
    """Dependency injection getter for CourseService."""
    return course_service
