import uuid

from fastapi_users import schemas
from pydantic import BaseModel, field_validator

from app.core.config import settings
from app.core.enums import UserRole


class UserRead(schemas.BaseUser[uuid.UUID]):
    """Schema for reading user data."""
    first_name: str | None = None
    last_name: str | None = None
    role: UserRole


class UserCreate(schemas.BaseUserCreate):
    """Schema for user registration.

    Password must meet the following requirements:
    - Minimum length defined by MIN_PASSWORD_LENGTH setting
    - At least one digit
    - At least one uppercase letter
    """
    first_name: str | None = None
    last_name: str | None = None
    role: UserRole = UserRole.STUDENT

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: str) -> str:
        """Validate password meets security requirements."""
        if len(v) < settings.MIN_PASSWORD_LENGTH:
            raise ValueError(
                f"Password must be at least {settings.MIN_PASSWORD_LENGTH} characters"
            )
        if not any(c.isdigit() for c in v):
            raise ValueError("Password must contain at least one digit")
        if not any(c.isupper() for c in v):
            raise ValueError("Password must contain at least one uppercase letter")
        return v


class UserUpdate(schemas.BaseUserUpdate):
    """Schema for updating user data.

    Note: Role changes are not allowed through this schema.
    Use AdminUserUpdate for superuser-initiated role changes.
    """
    first_name: str | None = None
    last_name: str | None = None
    # Role removed - prevents privilege escalation via self-update


class AdminUserUpdate(UserUpdate):
    """Schema for admin/superuser updates.

    Only superusers should be allowed to use this schema,
    as it permits role changes.
    """
    role: UserRole | None = None


class BearerResponse(BaseModel):
    """Response schema for login/register including ONLY the JWT token."""
    access_token: str
    token_type: str = "bearer"
