from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.security import OAuth2PasswordRequestForm
from fastapi_limiter.depends import RateLimiter
from fastapi_users import exceptions as fastapi_users_exceptions

from app.core.enums import AuthRoutes
from app.core.users import UserManager, auth_backend, fastapi_users, get_user_manager
from app.schemas.user import (
    BearerResponse,
    UserCreate,
    UserRead,
)

router = APIRouter()

# Custom Login Endpoint to return ONLY JWT token
@router.post(
    f"{AuthRoutes.JWT}/login",
    response_model=BearerResponse,
    name="auth:jwt.login",
    dependencies=[Depends(RateLimiter(times=5, seconds=60))]
)
async def login(
    request: Request,
    credentials: OAuth2PasswordRequestForm = Depends(),
    user_manager: UserManager = Depends(get_user_manager),
):
    # 1. Check if user exists
    try:
        user = await user_manager.get_by_email(credentials.username)
    except fastapi_users_exceptions.UserNotExists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    # 2. Verify password
    verified, updated_password_hash = user_manager.password_helper.verify_and_update(
        credentials.password, user.hashed_password
    )

    if not verified:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid password",
        )

    # 3. Check if active
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User is inactive",
        )

    # 4. Update password hash if needed
    if updated_password_hash is not None:
        await user_manager.user_db.update(user, {"hashed_password": updated_password_hash})

    strategy = auth_backend.get_strategy()
    token = await strategy.write_token(user)

    # 5. Return only token
    return {"access_token": token, "token_type": "bearer"}

# Include remaining auth routes (like Logout)
# We don't use the standard login route anymore
auth_router = fastapi_users.get_auth_router(auth_backend)
for route in auth_router.routes:
    if route.path == "/logout":
        router.add_route(
            f"{AuthRoutes.JWT}{route.path}",
            route.endpoint,
            methods=route.methods,
            name=route.name
        )

# Custom registration endpoint to return JWT on success
@router.post(
    "/register",
    response_model=BearerResponse,
    status_code=201,
    dependencies=[Depends(RateLimiter(times=10, seconds=60))]
)
async def register(
    request: Request,
    user_create: UserCreate,
    user_manager: UserManager = Depends(get_user_manager),
):
    # 1. Create user
    try:
        user = await user_manager.create(user_create, safe=True, request=request)
    except fastapi_users_exceptions.UserAlreadyExists as err:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="REGISTER_USER_ALREADY_EXISTS",
        ) from err

    # 2. Generate token immediately
    strategy = auth_backend.get_strategy()
    token = await strategy.write_token(user)

    # 3. Return only token
    return {"access_token": token, "token_type": "bearer"}

router.include_router(
    fastapi_users.get_reset_password_router(),
    prefix=AuthRoutes.RESET_PASSWORD,
)

router.include_router(
    fastapi_users.get_verify_router(UserRead),
    prefix=AuthRoutes.VERIFY,
)
