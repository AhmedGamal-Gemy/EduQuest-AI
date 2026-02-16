"""
Service layer for business logic.

This package contains service classes that encapsulate business logic,
separating it from API endpoint handlers for better maintainability and testing.
"""

from app.services.course_service import CourseService

__all__ = ["CourseService"]
