from fastapi import APIRouter, Request, Depends
from fastapi.security import OAuth2PasswordRequestForm
from fastapi_limiter.depends import RateLimiter
from app.core.users import auth_backend, fastapi_users, get_user_manager, UserManager
from app.schemas.user import UserRead, UserCreate, UserRegisterResponse, BearerResponseWithUserId
from app.core.enums import Tags, AuthRoutes

router = APIRouter()

# Custom Login Endpoint to return User ID
@router.post(
    f"{AuthRoutes.JWT}/login",
    response_model=BearerResponseWithUserId,
    name=f"auth:jwt.login",
    dependencies=[Depends(RateLimiter(times=5, seconds=60))]
)
async def login(
    request: Request,
    credentials: OAuth2PasswordRequestForm = Depends(),
    user_manager: UserManager = Depends(get_user_manager),
):
    from fastapi import HTTPException, status
    
    user = await user_manager.authenticate(credentials)

    if user is None or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="LOGIN_BAD_CREDENTIALS",
        )
    
    strategy = auth_backend.get_strategy()
    token = await strategy.write_token(user)
    
    # 3. Return user data + token
    return {**UserRead.model_validate(user).model_dump(), "access_token": token, "token_type": "bearer"}

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
    response_model=UserRegisterResponse, 
    status_code=201,
    dependencies=[Depends(RateLimiter(times=10, seconds=60))]
)
async def register(
    request: Request,
    user_create: UserCreate,
    user_manager: UserManager = Depends(get_user_manager),
):
    from fastapi import HTTPException, status
    from fastapi_users import exceptions

    # 1. Create user
    try:
        user = await user_manager.create(user_create, safe=True, request=request)
    except exceptions.UserAlreadyExists:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="REGISTER_USER_ALREADY_EXISTS",
        )
    
    # 2. Generate token immediately
    strategy = auth_backend.get_strategy()
    token = await strategy.write_token(user)
    
    # 3. Return user data + token
    return {**UserRead.model_validate(user).model_dump(), "access_token": token, "token_type": "bearer"}

router.include_router(
    fastapi_users.get_reset_password_router(), 
    prefix=AuthRoutes.RESET_PASSWORD, 
)

router.include_router(
    fastapi_users.get_verify_router(UserRead), 
    prefix=AuthRoutes.VERIFY, 
)
