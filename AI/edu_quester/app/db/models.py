from beanie import Document, Link
from fastapi_users.db import BeanieBaseUser
from pydantic import Field, HttpUrl
from typing import Optional, List
from uuid import UUID, uuid4
from datetime import datetime, timezone
from app.core.enums import Collections, UserRole, CourseLevel

class User(BeanieBaseUser, Document):
    # BeanieBaseUser is not Generic in typical generic sense for ID parametrization in all versions
    # We define the ID explicitly
    id: UUID = Field(default_factory=uuid4)
    
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    role: UserRole = Field(default=UserRole.STUDENT)
    
    class Settings:
        name = Collections.USERS
        email_collation = {"locale": "en", "strength": 2}

class Course(Document):
    id: UUID = Field(default_factory=uuid4)
    title: str = Field(..., unique=True)
    description: Optional[str] = None
    github_repo_url: Optional[HttpUrl] = None
    level: CourseLevel = Field(default=CourseLevel.BEGINNER)
    instructor: Link[User]
    students: List[Link[User]] = []
    is_published: bool = False
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    updated_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    
    class Settings:
        name = Collections.COURSES
        indexes = [
            "title"
        ]
