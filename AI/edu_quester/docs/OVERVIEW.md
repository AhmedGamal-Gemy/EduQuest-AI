# Project Overview

**EduQuest AI Backend** (`edu-quest-backend`) is a FastAPI-based application designed to serve as the backend for an educational AI platform. It integrates with Google ADK agents and utilizes modern Python asynchronous features to ensure high performance and scalability.

## Technology Stack

### Core Frameworks
- **Language**: Python 3.11+
- **Web Framework**: [FastAPI](https://fastapi.tiangolo.com/) (Async)
- **Server**: [Uvicorn](https://www.uvicorn.org/) (ASGI)
- **Package Management**: [uv](https://github.com/astral-sh/uv) (fast Python package installer & resolver)

### Database & Storage
- **Primary Database**: [MongoDB](https://www.mongodb.com/) (v7.0)
- **ODM (Object Document Mapper)**: [Beanie](https://beanie-odm.dev/) (Async ODM for MongoDB, built on Pydantic)
- **DB Driver**: `pymongo` (AsyncMongoClient) - *Reverted from Motor for improved local stability.*
- **Caching & Rate Limiting**: [Redis](https://redis.io/) (v7.2)
- **Redis Client**: `redis-py` (Async)

### Key Libraries
- **Authentication**: `fastapi-users[beanie]` (User management, OAuth2, JWT)
- **Validation**: `pydantic` (Data 2.0+), `email-validator`
- **Configuration**: `pydantic-settings` (.env file management)
- **Logging**: `loguru` (Structured logging), `structlog`
- **Rate Limiting**: `fastapi-limiter` (Redis-backed)
- **Agent Integration**: `google-adk`
- **Testing**: `pytest`, `pytest-asyncio`

## Key Entities
- **User**: Built-in authentication model with roles (`instructor`, `student`).
- **Course**: Educational content container managed by instructors.
- **Student**: Users enrolled in courses.
- **Agent**: (Coming Soon) AI Tutors powered by Google ADK.

## Project Structure
```
/app
  /api          # API Route handlers (v1, etc.)
  /core
    config.py   # App configuration (Settings class)
    enums.py    # Enumerations
    exceptions.py # Custom exception handlers
  /db
    database.py # Database initialization (Mongo & Redis)
    models.py   # Beanie/Pydantic models (User, etc.)
  main.py       # Application entry point & lifespan events
/edu_quester    # Core business logic / Agent modules
Dockerfile      # application container definition
docker-compose.yml # Infrastructure orchestration
Makefile        # Shortcuts for common commands
pyproject.toml  # Dependency and tool configuration
```
