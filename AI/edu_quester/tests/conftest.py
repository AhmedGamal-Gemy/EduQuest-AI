import pytest
import asyncio
from httpx import AsyncClient, ASGITransport
from asgi_lifespan import LifespanManager
from app.main import app



@pytest.fixture(scope="module")
async def client():
    print(f"\n[DEBUG] Starting LifespanManager... Scope: module")
    # Use LifespanManager to trigger startup (DB/Redis init) logic
    async with LifespanManager(app) as manager:
        print(f"[DEBUG] LifespanManager started. App: {manager.app}")
        transport = ASGITransport(app=manager.app)
        async with AsyncClient(transport=transport, base_url="http://test") as ac:
            print(f"[DEBUG] AsyncClient created. Yielding...")
            yield ac
            print(f"[DEBUG] AsyncClient closed.")
    print(f"[DEBUG] LifespanManager closed.")
