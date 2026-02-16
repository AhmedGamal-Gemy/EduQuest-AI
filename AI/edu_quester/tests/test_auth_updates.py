import pytest
from httpx import AsyncClient
from fastapi import status
from uuid import uuid4

@pytest.mark.asyncio
async def test_register_response_format(client: AsyncClient):
    """Test that registration returns only token and type."""
    # Use unique email to avoid conflict
    email = f"test_register_{uuid4()}@example.com"
    payload = {
        "email": email,
        "password": "Password123!",
        "role": "student"
    }
    response = await client.post("/api/v1/auth/register", json=payload)

    assert response.status_code == status.HTTP_201_CREATED
    data = response.json()
    assert "access_token" in data
    assert "token_type" in data
    # Ensure user details are NOT present
    assert "id" not in data
    assert "email" not in data

@pytest.mark.asyncio
async def test_login_errors(client: AsyncClient):
    """Test specific error messages for login."""
    # 1. User not found -> 404
    response = await client.post("/api/v1/auth/jwt/login", data={
        "username": "nonexistent_login@example.com",
        "password": "Password123!"
    })
    assert response.status_code == status.HTTP_404_NOT_FOUND
    assert response.json()["detail"] == "User not found"

    # 2. Register user for password test
    email = f"user_login_test_{uuid4()}@example.com"
    pwd = "Password123!"
    await client.post("/api/v1/auth/register", json={
        "email": email,
        "password": pwd,
        "role": "student"
    })

    # 3. Invalid password -> 400 with specific message
    response = await client.post("/api/v1/auth/jwt/login", data={
        "username": email,
        "password": "WrongPassword!"
    })
    assert response.status_code == status.HTTP_400_BAD_REQUEST
    assert response.json()["detail"] == "Invalid password"

@pytest.mark.asyncio
async def test_login_response_format(client: AsyncClient):
    """Test that login returns only token and type."""
    email = f"user_login_fmt_{uuid4()}@example.com"
    pwd = "Password123!"
    await client.post("/api/v1/auth/register", json={
        "email": email,
        "password": pwd,
        "role": "student"
    })

    response = await client.post("/api/v1/auth/jwt/login", data={
        "username": email,
        "password": pwd
    })
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "token_type" in data
    assert "id" not in data
