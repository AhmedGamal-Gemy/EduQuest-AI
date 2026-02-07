import uuid
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, ConfigDict, Field, HttpUrl
from app.core.enums import CourseLevel

class CourseBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=1000)
    github_repo_url: Optional[HttpUrl] = None
    level: CourseLevel = CourseLevel.BEGINNER
    is_published: bool = False

class CourseCreate(CourseBase):
    pass

class CourseUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=1000)
    github_repo_url: Optional[HttpUrl] = None
    level: Optional[CourseLevel] = None
    is_published: Optional[bool] = None

class CourseRead(CourseBase):
    id: uuid.UUID
    instructor_id: uuid.UUID
    student_ids: List[uuid.UUID] = []
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
