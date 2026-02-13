"""Unit tests for authentication schemas and configuration."""

from app.core.config import settings
from app.schemas.user import UserCreate


def test_user_create_schema_validation():
    """Test that UserCreate schema validates correctly with proper password."""
    user_data = {
        "email": "test@example.com",
        "password": "StrongPass1",  # Updated to meet validation: 8+ chars, digit, uppercase
        "first_name": "Test",
        "last_name": "User"
    }
    model = UserCreate(**user_data)
    assert model.email == "test@example.com"
    assert model.first_name == "Test"


def test_settings_loaded():
    """Test that settings are loaded from environment."""
    assert settings.MONGODB_URL is not None
    assert settings.SECRET_KEY is not None
