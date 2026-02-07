from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status
from app.core.users import fastapi_users, current_active_user, get_user_manager, UserManager
from app.schemas.user import UserRead, UserUpdate
from app.db.models import User
from app.core.enums import UserRole

router = APIRouter()

@router.get("/{id}", response_model=UserRead, name="users:user")
async def get_user_detail(
    id: UUID,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """
    Get user details.
    Allowed: Self, Instructor (for students), or Superuser.
    """
    user = await user_manager.get(id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
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
        detail="Insufficient permissions"
    )

@router.patch("/{id}", response_model=UserRead, name="users:patch_user")
async def update_user(
    id: UUID,
    user_update: UserUpdate,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """
    Update user.
    Allowed: Self or Superuser.
    """
    # Access Rules:
    if current_user.id != id and not current_user.is_superuser:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Insufficient permissions"
        )
    
    user = await user_manager.get(id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
    return await user_manager.update(user_update, user, safe=True)

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT, name="users:delete_user")
async def delete_user(
    id: UUID,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    """
    Delete user.
    Allowed: Self or Superuser.
    """
    # Access Rules:
    if current_user.id != id and not current_user.is_superuser:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Insufficient permissions"
        )
        
    user = await user_manager.get(id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
    await user_manager.delete(user)
    return None

# Mount the remaining standard routes (me, etc)
# Note: we don't use get_users_router here because it would conflict on /{id}
user_router = fastapi_users.get_users_router(UserRead, UserUpdate)
# We only want the /me routes from the standard router since we overrode /{id}
# But fastapi-users doesn't easily expose just /me. 
# Alternatively, we could mount the standard router at a different prefix,
# but the user expects it at /students.
# So we manually re-implement /me or filter the router.
# Simplest: Re-implement /me and /me/patch to match the prefix.

@router.get("/me", response_model=UserRead, name="users:current_user")
async def get_me(current_user: User = Depends(current_active_user)):
    return current_user

@router.patch("/me", response_model=UserRead, name="users:patch_current_user")
async def update_me(
    user_update: UserUpdate,
    user_manager: UserManager = Depends(get_user_manager),
    current_user: User = Depends(current_active_user),
):
    return await user_manager.update(user_update, current_user, safe=True)
