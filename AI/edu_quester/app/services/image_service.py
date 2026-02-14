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

# Allowed image MIME types and extensions for validation
ALLOWED_IMAGE_TYPES = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/gif": ".gif",
    "image/webp": ".webp"
}

async def save_upload_file(file: UploadFile) -> str:
    """Save an uploaded file to the static/images directory and return its URL path.

    Validates that the file is an image based on content type and forces a safe extension.
    """
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid file type. Allowed: {', '.join(ALLOWED_IMAGE_TYPES.keys())}"
        )

    # Determine safe extension from content type
    ext = ALLOWED_IMAGE_TYPES[file.content_type]

    # Generate a unique filename to prevent collisions
    filename = f"{uuid4()}{ext}"
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

    If Grok API returns an image URL, this function downloads the image
    locally to the static/images folder and returns the local path.
    """
    if settings.GROK_API_KEY:
        try:
            logger.bind(author="ai").info(f"Generating image for course: {title}")

            async with httpx.AsyncClient() as client:
                # 1. Generate Image URL
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
                        external_url = data["data"][0].get("url")

                        if external_url:
                            # 2. Download the image
                            logger.bind(author="ai").info(f"Downloading generated image from: {external_url}")
                            img_response = await client.get(external_url, timeout=30.0)

                            if img_response.status_code == 200:
                                # Determine extension from content-type or default to .png
                                content_type = img_response.headers.get("content-type", "image/png")
                                ext = ".png"
                                if "jpeg" in content_type: ext = ".jpg"
                                elif "gif" in content_type: ext = ".gif"
                                elif "webp" in content_type: ext = ".webp"

                                # 3. Save locally
                                filename = f"{uuid4()}_generated{ext}"
                                file_path = IMAGES_DIR / filename

                                with open(file_path, "wb") as f:
                                    f.write(img_response.content)

                                # 4. Return local path
                                return f"/static/images/{filename}"

                logger.bind(author="ai").warning(f"Grok API failed or image download failed: {response.status_code}")

        except Exception as e:
            logger.bind(author="ai").error(f"Error generating/saving image with Grok: {e}")

    # Fallback
    logger.bind(author="ai").info("Using fallback placeholder image")
    display_title = title[:30].replace(" ", "+")
    return f"https://placehold.co/600x400?text={display_title}"
