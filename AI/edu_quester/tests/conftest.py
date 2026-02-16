"""
Test fixtures for integration and unit tests.
"""

import pytest
from asgi_lifespan import LifespanManager
from httpx import ASGITransport, AsyncClient

from app.main import app


@pytest.fixture(scope="module")
async def client():
    """
    Async test client fixture with application lifespan management.
    
    Uses LifespanManager to trigger startup (DB/Redis init) logic.
    Redis is flushed before each test module to clear rate limits.
    """
    async with LifespanManager(app) as manager:
        import redis.asyncio as redis

        from app.core.config import settings

        # Flush Redis to clear rate limits for clean test state
        r = redis.from_url(settings.REDIS_URL, encoding="utf-8", decode_responses=True)
        await r.flushdb()
        await r.aclose()

        transport = ASGITransport(app=manager.app)
        async with AsyncClient(transport=transport, base_url="http://test") as ac:
            yield ac

