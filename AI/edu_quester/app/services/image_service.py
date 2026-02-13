import os
import shutil
from pathlib import Path
from uuid import uuid4

import httpx
from fastapi import HTTPException, UploadFile, status

from app.core.config import settings
from edu_quester.shared.logger import logger

# Base directory for static files
# Assuming the app is run from the project root (AI/edu_quester)
STATIC_DIR = Path("static")
IMAGES_DIR = STATIC_DIR / "images"

# Ensure directories exist
IMAGES_DIR.mkdir(parents=True, exist_ok=True)

# Allowed image MIME types for validation
ALLOWED_IMAGE_TYPES = {"image/jpeg", "image/png", "image/gif", "image/webp"}

async def save_upload_file(file: UploadFile) -> str:
    """Save an uploaded file to the static/images directory and return its URL path.

    Validates that the file is an image based on content type.
    """
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid file type. Allowed: {', '.join(ALLOWED_IMAGE_TYPES)}"
        )

    # Generate a unique filename to prevent collisions and clean up filename
    # Sanitize filename simply
    safe_filename = "".join(c for c in file.filename if c.isalnum() or c in "._-")
    filename = f"{uuid4()}_{safe_filename}"
    file_path = IMAGES_DIR / filename

    # Write file to disk
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    finally:
        file.file.close()

    return f"/static/images/{filename}"


async def generate_course_image(title: str, description: str | None = None) -> str:
    """
    Generate an image URL for a course using Grok API (xAI) if available,
    otherwise fallback to placeholder.
    """
    if settings.GROK_API_KEY:
        try:
            logger.bind(author="ai").info(f"Generating image for course: {title}")

            async with httpx.AsyncClient() as client:
                # Official xAI endpoint and model
                # Model: grok-imagine-image
                # Endpoint: https://api.x.ai/v1/images/generations

                response = await client.post(
                    "https://api.x.ai/v1/images/generations",
                    headers={
                        "Authorization": f"Bearer {settings.GROK_API_KEY}",
                        "Content-Type": "application/json"
                    },
                    json={
                        "model": "grok-imagine-image",
                        "prompt": f"Educational course cover image for: {title}. {description or ''}",
                        "size": "1024x1024",
                        "response_format": "url"  # Requesting URL directly
                    },
                    timeout=30.0
                )

                if response.status_code == 200:
                    data = response.json()
                    # Standard OpenAI-like response structure: { "data": [ { "url": "..." } ] }
                    if "data" in data and len(data["data"]) > 0:
                        image_url = data["data"][0].get("url")
                        if image_url:
                            return image_url

                logger.bind(author="ai").warning(f"Grok API failed: {response.status_code} - {response.text}")

        except Exception as e:
            logger.bind(author="ai").error(f"Error generating image with Grok: {e}")

    # Fallback
    logger.bind(author="ai").info("Using fallback placeholder image")
    display_title = title[:30].replace(" ", "+")
    return f"https://placehold.co/600x400?text={display_title}"
