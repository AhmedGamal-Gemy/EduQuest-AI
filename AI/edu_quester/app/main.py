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

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/health")
async def health_check():
    return {"status": "ok", "service": settings.PROJECT_NAME}

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
    
    # Set default server to localhost:8000 as requested
    openapi_schema["servers"] = [
        {"url": "http://localhost:8000", "description": "Local development server"}
    ]
    
    # Apply security globally or ensure it's available for selection
    # For now, we just ensure it's in components so Postman sees it
    
    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi

from fastapi.openapi.utils import get_openapi
