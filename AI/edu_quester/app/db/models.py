from datetime import UTC, datetime
from uuid import UUID, uuid4

from beanie import Document, Link
from fastapi_users.db import BeanieBaseUser
from pydantic import Field, HttpUrl

from app.core.enums import Collections, CourseLevel, UserRole


class User(BeanieBaseUser, Document):
    # BeanieBaseUser is not Generic in typical generic sense for ID parametrization in all versions
    # We define the ID explicitly
    id: UUID = Field(default_factory=uuid4)

    first_name: str | None = None
    last_name: str | None = None
    role: UserRole = Field(default=UserRole.STUDENT)

    class Settings:
        name = Collections.USERS
        email_collation = {"locale": "en", "strength": 2}

class Course(Document):
    id: UUID = Field(default_factory=uuid4)
    title: str = Field(..., unique=True)
    description: str | None = None
    github_repo_url: HttpUrl | None = None
    level: CourseLevel = Field(default=CourseLevel.BEGINNER)
    instructor: Link[User]
    students: list[Link[User]] = []
    is_published: bool = False
    created_at: datetime = Field(default_factory=lambda: datetime.now(UTC))
    updated_at: datetime = Field(default_factory=lambda: datetime.now(UTC))

    class Settings:
        name = Collections.COURSES
        indexes = [
            "title"
        ]
