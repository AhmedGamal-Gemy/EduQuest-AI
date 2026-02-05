from fastapi import APIRouter
from app.api.v1.endpoints import auth, chat
from app.core.enums import Tags

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=[Tags.AUTH])
api_router.include_router(chat.router, prefix="/chat", tags=[Tags.CHAT])
