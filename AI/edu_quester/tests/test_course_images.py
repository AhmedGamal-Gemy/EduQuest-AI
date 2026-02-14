import pytest
from httpx import AsyncClient, Response
from fastapi import status
from unittest.mock import patch, AsyncMock, MagicMock

# Helper to create an instructor and get token
async def get_instructor_token(client: AsyncClient, email: str) -> str:
    pwd = "Password123!"
    # Try to register
    await client.post("/api/v1/auth/register", json={
        "email": email,
        "password": pwd,
        "role": "instructor",
        "first_name": "Instructor",
        "last_name": "Test"
    })

    # Login
    resp = await client.post("/api/v1/auth/jwt/login", data={
        "username": email,
        "password": pwd
    })
    assert resp.status_code == 200, f"Login failed for {email}: {resp.text}"
    return resp.json()["access_token"]

@pytest.mark.asyncio
async def test_create_course_image_upload(client: AsyncClient):
    token = await get_instructor_token(client, "inst_img_upload@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    files = {'image': ('test_image.png', b'fake_image_content', 'image/png')}
    data = {
        "title": "Course with Image Upload",
        "level": "beginner",
        "is_published": "true"
    }

    # Use data= for form fields, files= for file upload
    response = await client.post("/api/v1/courses/", data=data, files=files, headers=headers)
    assert response.status_code == status.HTTP_201_CREATED
    course = response.json()
    assert course["image_url"] is not None
    assert course["image_url"].startswith("/static/images/")
    assert ".png" in course["image_url"]

@pytest.mark.asyncio
async def test_create_course_image_url(client: AsyncClient):
    token = await get_instructor_token(client, "inst_img_url@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    # Manually constructed Form data
    data = {
        "title": "Course with URL",
        "level": "beginner",
        "image_url": "http://example.com/test.jpg"
    }

    # Send as form data (no files)
    response = await client.post("/api/v1/courses/", data=data, headers=headers)
    assert response.status_code == status.HTTP_201_CREATED
    course = response.json()
    assert course["image_url"] == "http://example.com/test.jpg"

@pytest.mark.asyncio
async def test_create_course_auto_image_grok_mock(client: AsyncClient):
    """Test AI image generation with a mocked Grok API response AND mocked image download."""
    token = await get_instructor_token(client, "inst_img_grok@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    data = {
        "title": "Grok Generated Course",
        "level": "beginner"
    }

    # Mock settings to enable Grok
    with patch("app.core.config.settings.GROK_API_KEY", "fake_key"):
        # Mock httpx used INSIDE image_service only, not globally to avoid breaking test client
        with patch("app.services.image_service.httpx.AsyncClient") as MockClient:
            mock_client_instance = MockClient.return_value.__aenter__.return_value

            # Mock Grok response (URL)
            mock_client_instance.post.return_value = Response(
                200,
                json={"data": [{"url": "https://grok-api.mock/generated_image.png"}]}
            )

            # Mock Image download response
            mock_client_instance.get.return_value = Response(
                200,
                content=b"fake_image_bytes",
                headers={"content-type": "image/png"}
            )

            # Mock file writing to avoid creating files in test environment
            with patch("builtins.open", new_callable=MagicMock):
                response = await client.post("/api/v1/courses/", data=data, headers=headers)

        assert response.status_code == status.HTTP_201_CREATED
        course = response.json()

        # Should be a local path now, NOT the external URL
        assert course["image_url"].startswith("/static/images/")
        assert course["image_url"].endswith(".png")

        # Verify correct API call structure
        mock_client_instance.post.assert_called_once()
        args, kwargs = mock_client_instance.post.call_args
        assert args[0] == "https://api.x.ai/v1/images/generations"
        assert kwargs["json"]["model"] == "grok-imagine-image"

        # Verify download call
        mock_client_instance.get.assert_called_once_with("https://grok-api.mock/generated_image.png", timeout=30.0)

@pytest.mark.asyncio
async def test_create_course_auto_image_fallback(client: AsyncClient):
    """Test fallback when Grok API fails or key is missing."""
    token = await get_instructor_token(client, "inst_img_fallback@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    data = {
        "title": "Fallback Course",
        "level": "beginner"
    }

    # Ensure no API key is set
    with patch("app.core.config.settings.GROK_API_KEY", None):
        response = await client.post("/api/v1/courses/", data=data, headers=headers)

        assert response.status_code == status.HTTP_201_CREATED
        course = response.json()
        assert "placehold.co" in course["image_url"]
