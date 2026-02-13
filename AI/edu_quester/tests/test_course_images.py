import pytest
from httpx import AsyncClient
from fastapi import status

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
    assert "test_image.png" in course["image_url"] or "_" in course["image_url"]

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
async def test_create_course_auto_image(client: AsyncClient):
    token = await get_instructor_token(client, "inst_img_auto@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    data = {
        "title": "Course Auto Image",
        "level": "beginner"
    }

    response = await client.post("/api/v1/courses/", data=data, headers=headers)
    assert response.status_code == status.HTTP_201_CREATED
    course = response.json()
    assert course["image_url"] is not None
    assert "placehold.co" in course["image_url"]
