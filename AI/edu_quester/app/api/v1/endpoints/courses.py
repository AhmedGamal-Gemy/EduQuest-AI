"""
Course management endpoints.

Provides CRUD operations for courses and student enrollment management.
"""

from uuid import UUID

from fastapi import APIRouter, Depends, File, Form, Query, UploadFile, status
from fastapi_limiter.depends import RateLimiter

from app.core.config import settings
from app.core.enums import CourseLevel
from app.core.users import current_active_user
from app.db.models import User
from app.schemas.course import (
    CourseCreate,
    CourseRead,
    CourseUpdate,
    PaginatedCourseResponse,
)
from app.services.course_service import CourseService, get_course_service
from app.services.image_service import generate_course_image, save_upload_file

router = APIRouter()


def _course_to_response(course) -> dict:
    """Convert Course model to response dict with flattened IDs."""
    return {
        **course.model_dump(),
        "instructor_id": course.instructor.id,
        "student_ids": [s.id for s in course.students]
    }


@router.post(
    "/",
    response_model=CourseRead,
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(RateLimiter(times=10, seconds=60))]
)
async def create_course(
    title: str = Form(..., min_length=1, max_length=100),
    description: str | None = Form(None, max_length=1000),
    github_repo_url: str | None = Form(None),
    level: CourseLevel = Form(CourseLevel.BEGINNER),
    is_published: bool = Form(False),
    image_url: str | None = Form(None),
    image: UploadFile | None = File(None),
    current_user: User = Depends(current_active_user),
    service: CourseService = Depends(get_course_service)
):
    """
    Create a new course. Only instructors can create courses.

    Accepts multipart/form-data to support image uploads.
    """
    # Handle potential empty strings from form data for optional fields
    if github_repo_url == "":
        github_repo_url = None
    if description == "":
        description = None
    if image_url == "":
        image_url = None

    final_image_url = image_url

    if image:
        final_image_url = await save_upload_file(image)
    elif not final_image_url:
        final_image_url = await generate_course_image(title, description)

    course_in = CourseCreate(
        title=title,
        description=description,
        github_repo_url=github_repo_url,
        level=level,
        is_published=is_published,
        image_url=final_image_url
    )

    course = await service.create_course(course_in, current_user)
    return _course_to_response(course)


@router.get("/", response_model=PaginatedCourseResponse)
async def list_courses(
    limit: int = Query(default=settings.DEFAULT_PAGE_LIMIT, ge=1, le=settings.MAX_PAGE_LIMIT),
    offset: int = Query(default=0, ge=0),
    service: CourseService = Depends(get_course_service)
):
    """List all courses with pagination.

    Query Parameters:
    - **limit**: Maximum number of courses to return (default: 20, max: 100)
    - **offset**: Number of courses to skip for pagination
    """
    courses, total = await service.list_courses(limit=limit, offset=offset)

    return {
        "items": [_course_to_response(c) for c in courses],
        "total": total,
        "limit": limit,
        "offset": offset
    }


@router.get("/{course_id}", response_model=CourseRead)
async def get_course(
    course_id: UUID,
    service: CourseService = Depends(get_course_service)
):
    """
    Get course by ID.
    """
    course = await service.get_course(course_id)
    return _course_to_response(course)


@router.patch("/{course_id}", response_model=CourseRead)
async def update_course(
    course_id: UUID,
    course_in: CourseUpdate,
    current_user: User = Depends(current_active_user),
    service: CourseService = Depends(get_course_service)
):
    """
    Update course. Only the instructor who created it can update it.
    """
    course = await service.update_course(course_id, course_in, current_user)
    return _course_to_response(course)


@router.delete("/{course_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_course(
    course_id: UUID,
    current_user: User = Depends(current_active_user),
    service: CourseService = Depends(get_course_service)
):
    """
    Delete course. Only the instructor who created it can delete it.
    """
    await service.delete_course(course_id, current_user)
    return None


@router.post("/{course_id}/enroll", response_model=CourseRead)
async def enroll_in_course(
    course_id: UUID,
    current_user: User = Depends(current_active_user),
    service: CourseService = Depends(get_course_service)
):
    """Enroll the current user (if student) in a course.

    Note: The course must be published to allow enrollment.
    """
    course = await service.enroll_student(course_id, current_user)
    return _course_to_response(course)


@router.delete("/{course_id}/enroll", response_model=CourseRead)
async def unenroll_from_course(
    course_id: UUID,
    current_user: User = Depends(current_active_user),
    service: CourseService = Depends(get_course_service)
):
    """
    Unenroll the current user from a course.
    """
    course = await service.unenroll_student(course_id, current_user)
    return _course_to_response(course)
