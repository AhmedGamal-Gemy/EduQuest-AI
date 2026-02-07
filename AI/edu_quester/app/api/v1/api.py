from fastapi import APIRouter
from app.api.v1.endpoints import auth, chat, courses, students
from app.core.enums import Tags

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=[Tags.AUTH])
api_router.include_router(chat.router, prefix="/chat", tags=[Tags.CHAT])
api_router.include_router(courses.router, prefix="/courses", tags=[Tags.COURSES])
api_router.include_router(students.router, prefix="/students", tags=[Tags.USERS])
