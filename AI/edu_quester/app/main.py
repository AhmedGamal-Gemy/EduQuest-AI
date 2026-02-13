import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.api.v1.api import api_router
from app.core.config import settings
from app.core.exceptions import http_exception_handler, validation_exception_handler
from app.db.database import (
    check_mongo_health,
    check_redis_health,
    close_db,
    close_redis,
    init_db,
    init_redis,
)
from app.middleware.request_id import RequestIDMiddleware
from edu_quester.shared.logger import InterceptHandler, logger

# Setup Loguru to intercept standard logging
logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager for startup and shutdown events."""
    # Startup
    logger.bind(author="system").info("Application startup...")
    await init_db()
    await init_redis()
    yield
    # Shutdown - properly close database connections
    logger.bind(author="system").info("Application shutdown...")
    await close_redis()
    await close_db()

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_version="3.0.2",
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan,
    exception_handlers={
        StarletteHTTPException: http_exception_handler,
        RequestValidationError: validation_exception_handler,
    }
)

# CORS Configuration
if settings.ENVIRONMENT in ["local", "development", "dev"]:
    # 🚨 DEVELOPMENT: Allow ANY origin
    logger.bind(author="system").warning("CORS: Allowing ALL origins (Development Mode)")
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
elif settings.BACKEND_CORS_ORIGINS:
    # 🔒 PRODUCTION: Allow only specific origins from config
    logger.bind(author="system").info(f"CORS: Allowing specific origins: {settings.BACKEND_CORS_ORIGINS}")
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

# Add Request ID middleware for tracing
app.add_middleware(RequestIDMiddleware)

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/health")
async def health_check():
    """Health check endpoint for monitoring and load balancers.

    Returns status of the service and its dependencies (MongoDB, Redis).
    """
    mongo_status = await check_mongo_health()
    redis_status = await check_redis_health()

    # Determine overall health
    all_healthy = mongo_status["status"] == "ok" and redis_status["status"] == "ok"

    return {
        "status": "ok" if all_healthy else "degraded",
        "service": settings.PROJECT_NAME,
        "dependencies": {
            "mongodb": mongo_status,
            "redis": redis_status
        }
    }

# Custom OpenAPI to include Bearer Auth explicitly
def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema

    openapi_schema = get_openapi(
        title=app.title,
        version=app.version,
        openapi_version=app.openapi_version,
        description=app.description,
        routes=app.routes,
    )

    # Add Bearer Auth security scheme
    openapi_schema["components"]["securitySchemes"]["HTTPBearer"] = {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT",
    }

    # Set default server using configured port
    openapi_schema["servers"] = [
        {"url": f"http://localhost:{settings.PORT}", "description": "Local development server"}
    ]

    # Apply security globally or ensure it's available for selection
    # For now, we just ensure it's in components so Postman sees it

    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi
