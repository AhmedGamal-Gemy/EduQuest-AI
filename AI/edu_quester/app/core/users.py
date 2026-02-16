import uuid

from fastapi import Depends, Request
from fastapi_users import BaseUserManager, FastAPIUsers, UUIDIDMixin
from fastapi_users.authentication import (
    AuthenticationBackend,
    BearerTransport,
    JWTStrategy,
)
from fastapi_users.db import BeanieUserDatabase
from fastapi_users.jwt import generate_jwt

from app.core.config import settings
from app.db.models import User
from edu_quester.shared.logger import logger


async def get_user_db():
    yield BeanieUserDatabase(User, uuid.UUID)

class UserManager(UUIDIDMixin, BaseUserManager[User, uuid.UUID]):
    reset_password_token_secret = settings.SECRET_KEY
    verification_token_secret = settings.SECRET_KEY

    async def on_after_register(self, user: User, request: Request | None = None):
        logger.bind(author="auth").info(f"User registered: {user.id}")

    async def on_after_forgot_password(
        self, user: User, token: str, request: Request | None = None
    ):
        logger.bind(author="auth").info(f"User {user.id} forgot password. Token generated.")

    async def on_after_request_verify(
        self, user: User, token: str, request: Request | None = None
    ):
        logger.bind(author="auth").info(f"User {user.id} requested verification.")

async def get_user_manager(user_db: BeanieUserDatabase = Depends(get_user_db)):
    yield UserManager(user_db)

bearer_transport = BearerTransport(tokenUrl="api/v1/auth/jwt/login")

class CustomJWTStrategy(JWTStrategy):
    async def write_token(self, user: User) -> str:
        data = {
            "sub": str(user.id),
            "email": user.email,
            "role": user.role,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "aud": self.token_audience,
        }
        return generate_jwt(data, self.encode_key, self.lifetime_seconds, self.algorithm)

def get_jwt_strategy() -> JWTStrategy:
    return CustomJWTStrategy(
        secret=settings.SECRET_KEY,
        lifetime_seconds=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60,
        algorithm=settings.ALGORITHM
    )

auth_backend = AuthenticationBackend(
    name="jwt",
    transport=bearer_transport,
    get_strategy=get_jwt_strategy,
)

fastapi_users = FastAPIUsers[User, uuid.UUID](get_user_manager, [auth_backend])

current_active_user = fastapi_users.current_user(active=True)
