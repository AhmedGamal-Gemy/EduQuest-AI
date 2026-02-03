from pymongo import AsyncMongoClient
from beanie import init_beanie
from fastapi_limiter import FastAPILimiter
import redis.asyncio as redis
from app.core.config import settings
from app.db.models import User
from edu_quester.shared.logger import logger

async def init_db():
    try:
        # Use standard PyMongo Async Client
        client = AsyncMongoClient(settings.MONGODB_URL)
        
        # Verify connection (ping is standard way to check in pymongo)
        await client.admin.command('ping')
        logger.bind(author="database").info(f"Connected to MongoDB at {settings.MONGODB_URL}")
        
        await init_beanie(
            database=client[settings.DATABASE_NAME],
            document_models=[
                User,
            ],
        )
        logger.bind(author="database").info("Beanie initialized with PyMongo Async")
    except Exception as e:
        logger.bind(author="database").error(f"MongoDB Connection Error: {e}")
        raise e

async def init_redis():
    try:
        redis_connection = redis.from_url(
            settings.REDIS_URL, 
            encoding="utf-8", 
            decode_responses=True
        )
        await FastAPILimiter.init(redis_connection)
        logger.bind(author="database").info(f"Connected to Redis at {settings.REDIS_URL}")
    except Exception as e:
        logger.bind(author="database").error(f"Redis Connection Error: {e}")
        raise e
