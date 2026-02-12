from typing import List
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from beanie import PydanticObjectId
from app.db.models import Course, User
from app.schemas.course import CourseCreate, CourseRead, CourseUpdate
from app.core.users import current_active_user
from app.core.enums import UserRole
from app.services.ai_image_service import generate_course_image
from app.utils.file_utils import save_upload_file

router = APIRouter()

@router.post("/upload-image", response_model=dict)
async def upload_course_image(
    file: UploadFile = File(...),
    current_user: User = Depends(current_active_user)
):
    """
    Upload an image for a course. Returns the image URL.
    Only instructors can upload images.
    """
    if current_user.role != UserRole.INSTRUCTOR:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only instructors can upload images"
        )

    file_url = save_upload_file(file)
    return {"image_url": file_url}

@router.post("/", response_model=CourseRead, status_code=status.HTTP_201_CREATED)
async def create_course(
    course_in: CourseCreate,
    current_user: User = Depends(current_active_user)
):
    """
    Create a new course. Only instructors can create courses.
    If image_url is not provided, one will be generated based on the title.
    """
    if current_user.role != UserRole.INSTRUCTOR:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only instructors can create courses"
        )
    
    # Generate image if not provided
    if not course_in.image_url:
        course_in.image_url = generate_course_image(course_in.title, course_in.description or "")

    course = Course(
        **course_in.model_dump(),
        instructor=current_user
    )
    from pymongo.errors import DuplicateKeyError
    try:
        await course.insert()
    except DuplicateKeyError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="COURSE_ALREADY_EXISTS"
        )
    
    # Reload to ensure all fields (like ID) are populated
    await course.fetch_all_links()
    
    return {
        **course.model_dump(),
        "instructor_id": course.instructor.id,
        "student_ids": [s.id for s in course.students]
    }

@router.get("/", response_model=List[CourseRead])
async def list_courses():
    """
    List all published courses.
    """
    # For now, show all. In production, might filter by is_published
    courses = await Course.find_all(fetch_links=True).to_list()
    
    result = []
    for course in courses:
        result.append({
            **course.model_dump(),
            "instructor_id": course.instructor.id,
            "student_ids": [s.id for s in course.students]
        })
    return result

@router.get("/{course_id}", response_model=CourseRead)
async def get_course(course_id: UUID):
    """
    Get course by ID.
    """
    course = await Course.get(course_id, fetch_links=True)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    return {
        **course.model_dump(),
        "instructor_id": course.instructor.id,
        "student_ids": [s.id for s in course.students]
    }

@router.patch("/{course_id}", response_model=CourseRead)
async def update_course(
    course_id: UUID,
    course_in: CourseUpdate,
    current_user: User = Depends(current_active_user)
):
    """
    Update course. Only the instructor who created it can update it.
    """
    course = await Course.get(course_id, fetch_links=True)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    if course.instructor.id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="You are not the instructor of this course"
        )
    
    update_data = course_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(course, field, value)
    
    await course.save()
    
    return {
        **course.model_dump(),
        "instructor_id": course.instructor.id,
        "student_ids": [s.id for s in course.students]
    }

@router.delete("/{course_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_course(
    course_id: UUID,
    current_user: User = Depends(current_active_user)
):
    """
    Delete course. Only the instructor who created it can delete it.
    """
    course = await Course.get(course_id, fetch_links=True)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    if course.instructor.id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="You are not the instructor of this course"
        )
    
    await course.delete()
    return None

@router.post("/{course_id}/enroll", response_model=CourseRead)
async def enroll_in_course(
    course_id: UUID,
    current_user: User = Depends(current_active_user)
):
    """
    Enroll the current user (if student) in a course.
    """
    if current_user.role != UserRole.STUDENT:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only students can enroll in courses"
        )
    
    course = await Course.get(course_id, fetch_links=True)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    # Check if already enrolled
    if any(s.id == current_user.id for s in course.students):
        raise HTTPException(status_code=400, detail="Already enrolled")
    
    course.students.append(current_user)
    await course.save()
    
    return {
        **course.model_dump(),
        "instructor_id": course.instructor.id,
        "student_ids": [s.id for s in course.students]
    }
