"""
Student/User management endpoints.

Provides user profile access, updates, and deletion with role-based access control.
"""

from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi_users import exceptions

from app.core.enums import UserRole
from app.core.users import (
    UserManager,
    current_active_user,
    get_user_manager,
)
from app.db.models import User
from app.schemas.user import AdminUserUpdate, UserRead, UserUpdate

router = APIRouter()


# --------------------------------------------------------------------------- #
# /me routes - MUST be defined BEFORE /{id} routes to avoid path conflicts
# --------------------------------------------------------------------------- #

@router.get("/me", response_model=UserRead, name="users:current_user")
async def get_me(current_user: User = Depends(current_active_user)):
    """Get the currently authenticated user's profile."""
    return current_user


@router.patch("/me", response_model=UserRead, name="users:patch_current_user")
async def update_me(
    user_update: UserUpdate,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """Update the currently authenticated user's profile.

    Note: Role changes are not allowed through this endpoint.
    """
    return await user_manager.update(user_update, current_user, safe=True)


# --------------------------------------------------------------------------- #
# /{id} routes - Defined AFTER /me routes
# --------------------------------------------------------------------------- #

@router.get("/{id}", response_model=UserRead, name="users:user")
async def get_user_detail(
    id: UUID,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """Get user details by ID.

    Access Rules:
    - Self: Can view own profile
    - Instructor: Can view student profiles
    - Superuser: Can view any profile
    """
    try:
        user = await user_manager.get(id)
    except exceptions.UserNotExists as err:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="USER_NOT_FOUND"
        ) from err

    # Access Rules:
    # 1. Self access
    if current_user.id == id:
        return user

    # 2. Superuser access
    if current_user.is_superuser:
        return user

    # 3. Instructor access (can see students)
    if current_user.role == UserRole.INSTRUCTOR and user.role == UserRole.STUDENT:
        return user

    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="INSUFFICIENT_PERMISSIONS"
    )


@router.patch("/{id}", response_model=UserRead, name="users:patch_user")
async def update_user(
    id: UUID,
    user_update: UserUpdate,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """Update a user's profile.

    Access Rules:
    - Self: Can update own profile (excluding role)
    - Superuser: Can update any profile (excluding role via this endpoint)

    Note: To change a user's role, superusers must use the admin endpoint.
    """
    # Access Rules:
    if current_user.id != id and not current_user.is_superuser:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="INSUFFICIENT_PERMISSIONS"
        )

    try:
        user = await user_manager.get(id)
    except exceptions.UserNotExists as err:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="USER_NOT_FOUND"
        ) from err

    return await user_manager.update(user_update, user, safe=True)


@router.patch(
    "/{id}/admin",
    response_model=UserRead,
    name="users:admin_patch_user"
)
async def admin_update_user(
    id: UUID,
    user_update: AdminUserUpdate,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """Admin endpoint to update a user's profile including role.

    Access Rules:
    - Superuser only: Can update any field including role
    """
    if not current_user.is_superuser:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="SUPERUSER_REQUIRED"
        )

    try:
        user = await user_manager.get(id)
    except exceptions.UserNotExists as err:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="USER_NOT_FOUND"
        ) from err

    return await user_manager.update(user_update, user, safe=True)


@router.delete(
    "/{id}",
    status_code=status.HTTP_204_NO_CONTENT,
    name="users:delete_user"
)
async def delete_user(
    id: UUID,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """Delete a user account.

    Access Rules:
    - Self: Can delete own account
    - Superuser: Can delete any account
    """
    # Access Rules:
    if current_user.id != id and not current_user.is_superuser:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="INSUFFICIENT_PERMISSIONS"
        )

    try:
        user = await user_manager.get(id)
    except exceptions.UserNotExists as err:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="USER_NOT_FOUND"
        ) from err

    await user_manager.delete(user)
    return None
