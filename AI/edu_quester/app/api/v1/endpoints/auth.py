from fastapi import APIRouter, Request, Depends
from fastapi_limiter.depends import RateLimiter
from app.core.users import auth_backend, fastapi_users, get_user_manager, UserManager
from app.schemas.user import UserRead, UserCreate, UserRegisterResponse
from app.core.enums import Tags, AuthRoutes

router = APIRouter()

# Rate limit: 5 logins per minute
router.include_router(
    fastapi_users.get_auth_router(auth_backend), 
    prefix=AuthRoutes.JWT, 
    # tags=[Tags.AUTH],  # Removed here, handled at api_router level
    dependencies=[Depends(RateLimiter(times=5, seconds=60))]
)

# Custom registration endpoint to return JWT on success
@router.post(
    "/register", 
    response_model=UserRegisterResponse, 
    status_code=201,
    dependencies=[Depends(RateLimiter(times=3, seconds=60))]
)
async def register(
    request: Request,
    user_create: UserCreate,
    user_manager: UserManager = Depends(get_user_manager),
):
    # 1. Create user
    user = await user_manager.create(user_create, safe=True, request=request)
    
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
