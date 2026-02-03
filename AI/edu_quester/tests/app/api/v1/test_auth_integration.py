import pytest
import uuid
from app.core.config import settings
from app.main import app # Import app directly to inspect routes

@pytest.mark.asyncio(loop_scope="module")
async def test_register_and_login(client):
    # 1. Register
    email = f"integration_{uuid.uuid4()}@example.com"
    password = "strong_password123"
    
    # Try the presumed correct URL
    url = f"{settings.API_V1_STR}/auth/register"
    response = await client.post(url, json={
        "email": email,
        "password": password,
        "first_name": "Integration",
        "last_name": "Tester"
    })
    
    if response.status_code == 404:
        # Debugging 404
        print(f"\n[DEBUG] Failed to hit {url} (404)")
        print("[DEBUG] Available Routes in App:")
        for route in app.routes:
            if hasattr(route, "path"):
                print(f" - {route.path}")
            # Also check mounted routers
            if hasattr(route, "routes"):
                for sub_route in route.routes:
                     if hasattr(sub_route, "path"):
                        full_path = f"{route.path}{sub_route.path}"
                        print(f" - {full_path}")
    
    assert response.status_code == 201, f"Registration failed: {response.text}"
    
    data = response.json()
    assert data["email"] == email
    
    # 2. Login
    login_data = {
        "username": email,
        "password": password
    }
    
    login_url = f"{settings.API_V1_STR}/auth/jwt/login"
    response = await client.post(login_url, data=login_data)
    assert response.status_code == 200
    tokens = response.json()
    assert "access_token" in tokens
    assert tokens["token_type"] == "bearer"

@pytest.mark.asyncio
async def test_health_check(client):
    response = await client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"
