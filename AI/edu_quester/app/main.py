from contextlib import asynccontextmanager
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1.api import api_router
from app.db.database import init_db, init_redis
from edu_quester.shared.logger import logger, InterceptHandler, loguru_logger
from app.core.exceptions import http_exception_handler, validation_exception_handler
from starlette.exceptions import HTTPException as StarletteHTTPException
from fastapi.exceptions import RequestValidationError
import logging

# Setup Loguru to intercept standard logging
logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.bind(author="system").info("Application startup...")
    await init_db()
    await init_redis()
    yield
    # Shutdown
    logger.bind(author="system").info("Application shutdown...")

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan,
    exception_handlers={
        StarletteHTTPException: http_exception_handler,
        RequestValidationError: validation_exception_handler,
    }
)

# CORS
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/health")
async def health_check():
    return {"status": "ok", "service": settings.PROJECT_NAME}
