import pytest
from app.schemas.user import UserCreate
from app.db.models import User
from app.core.config import settings

def test_user_create_schema_validation():
    user_data = {
        "email": "test@example.com",
        "password": "strongpassword",
        "first_name": "Test",
        "last_name": "User"
    }
    model = UserCreate(**user_data)
    assert model.email == "test@example.com"
    assert model.first_name == "Test"

def test_settings_loaded():
    assert settings.MONGODB_URL is not None
    assert settings.SECRET_KEY is not None
