import uuid
from typing import Optional
from app.core.enums import UserRole
from fastapi_users import schemas

class UserRead(schemas.BaseUser[uuid.UUID]):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    role: UserRole

class UserCreate(schemas.BaseUserCreate):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    role: UserRole = UserRole.STUDENT

class UserUpdate(schemas.BaseUserUpdate):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    role: Optional[UserRole] = None

class UserRegisterResponse(UserRead):
    access_token: str
    token_type: str = "bearer"

class BearerResponseWithUserId(UserRead):
    access_token: str
    token_type: str
