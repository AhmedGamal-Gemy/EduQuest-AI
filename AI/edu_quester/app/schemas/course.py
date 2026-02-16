import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field, HttpUrl

from app.core.enums import CourseLevel


class CourseBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    description: str | None = Field(None, max_length=1000)
    image_url: str | None = None
    github_repo_url: HttpUrl | None = None
    level: CourseLevel = CourseLevel.BEGINNER
    is_published: bool = False


class CourseCreate(CourseBase):
    pass


class CourseUpdate(BaseModel):
    title: str | None = Field(None, min_length=1, max_length=100)
    description: str | None = Field(None, max_length=1000)
    github_repo_url: HttpUrl | None = None
    level: CourseLevel | None = None
    is_published: bool | None = None


class CourseRead(CourseBase):
    id: uuid.UUID
    instructor_id: uuid.UUID
    student_ids: list[uuid.UUID] = []
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class PaginatedCourseResponse(BaseModel):
    """Paginated response for course listings."""
    items: list[CourseRead]
    total: int
    limit: int
    offset: int
