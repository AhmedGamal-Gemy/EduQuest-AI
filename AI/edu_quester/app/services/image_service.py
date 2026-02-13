import os
import shutil
from pathlib import Path
from uuid import uuid4

from fastapi import UploadFile

# Base directory for static files
# Assuming the app is run from the project root (AI/edu_quester)
STATIC_DIR = Path("static")
IMAGES_DIR = STATIC_DIR / "images"

# Ensure directories exist
IMAGES_DIR.mkdir(parents=True, exist_ok=True)


async def save_upload_file(file: UploadFile) -> str:
    """Save an uploaded file to the static/images directory and return its URL path."""
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
    Generate a placeholder image URL for a course.

    In a real implementation, this would call an AI service (e.g., Grok, DALL-E).
    For now, we return a placeholder service URL.
    """
    # Using placehold.co for dynamic placeholders based on title
    # Truncate title for URL safety/length
    display_title = title[:30].replace(" ", "+")
    return f"https://placehold.co/600x400?text={display_title}"
