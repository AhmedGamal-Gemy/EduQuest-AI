"""
Database initialization and health check utilities.

This module handles connections to MongoDB and Redis,
and provides health check functions for production monitoring.
"""

import redis.asyncio as redis
from beanie import init_beanie
from fastapi_limiter import FastAPILimiter
from pymongo import AsyncMongoClient

from app.core.config import settings
from app.db.models import Course, User
from edu_quester.shared.logger import logger

# Store connections for health checks
_mongo_client: AsyncMongoClient | None = None
_redis_connection: redis.Redis | None = None


async def init_db():
    """Initialize MongoDB connection and Beanie ODM."""
    global _mongo_client
    try:
        logger.bind(author="database").debug(f"Connecting to MongoDB at {settings.MONGODB_URL}")
        _mongo_client = AsyncMongoClient(settings.MONGODB_URL, uuidRepresentation="standard")

        # Verify connection
        await _mongo_client.admin.command('ping')
        logger.bind(author="database").info(f"Connected to MongoDB at {settings.MONGODB_URL}")

        await init_beanie(
            database=_mongo_client[settings.DATABASE_NAME],
            document_models=[
                User,
                Course,
            ],
        )
        logger.bind(author="database").info("Beanie initialized with PyMongo Async Client")
    except Exception as e:
        logger.bind(author="database").error(f"MongoDB Connection Error: {e}")
        raise


async def init_redis():
    """Initialize Redis connection for rate limiting."""
    global _redis_connection
    try:
        _redis_connection = redis.from_url(
            settings.REDIS_URL,
            encoding="utf-8",
            decode_responses=True
        )
        await FastAPILimiter.init(_redis_connection)
        logger.bind(author="database").info(f"Connected to Redis at {settings.REDIS_URL}")
    except Exception as e:
        logger.bind(author="database").error(f"Redis Connection Error: {e}")
        raise


async def check_mongo_health() -> dict:
    """Check MongoDB connectivity for health endpoint."""
    try:
        if _mongo_client is None:
            return {"status": "error", "message": "Not initialized"}
        await _mongo_client.admin.command('ping')
        return {"status": "ok"}
    except Exception as e:
        return {"status": "error", "message": str(e)}


async def check_redis_health() -> dict:
    """Check Redis connectivity for health endpoint."""
    try:
        if _redis_connection is None:
            return {"status": "error", "message": "Not initialized"}
        await _redis_connection.ping()
        return {"status": "ok"}
    except Exception as e:
        return {"status": "error", "message": str(e)}


async def close_db():
    """Close MongoDB connection on application shutdown.

    Should be called in the application lifespan shutdown phase.
    """
    global _mongo_client
    if _mongo_client is not None:
        _mongo_client.close()
        _mongo_client = None
        logger.bind(author="database").info("MongoDB connection closed")


async def close_redis():
    """Close Redis connection on application shutdown.

    Should be called in the application lifespan shutdown phase.
    """
    global _redis_connection
    if _redis_connection is not None:
        await _redis_connection.close()
        _redis_connection = None
        logger.bind(author="database").info("Redis connection closed")

