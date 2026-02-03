from beanie import Document
from fastapi_users.db import BeanieBaseUser
from pydantic import Field
from typing import Optional
from uuid import UUID, uuid4
from app.core.enums import Collections

class User(BeanieBaseUser, Document):
    # BeanieBaseUser is not Generic in typical generic sense for ID parametrization in all versions
    # We define the ID explicitly
    id: UUID = Field(default_factory=uuid4)
    
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    
    class Settings:
        name = Collections.USERS
        email_collation = {"locale": "en", "strength": 2}
