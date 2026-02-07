# Setup & Running Instructions

## Prerequisites
- **Python 3.11+**
- **Docker & Docker Compose**
- **uv** (Recommended for fast dependency management, or standard pip)

## Installation

### 1. Install Dependencies
We recommend using `uv` for faster installation, but standard pip works as well.

Using `make` (wraps uv):
```bash
make install
```

Or using `uv` directly:
```bash
uv sync
```

### 2. Environment Configuration
Copy the example environment file and update it with your settings:
```bash
cp .env.example .env
```
Ensure `MONGODB_URL` and `REDIS_URL` match your docker configuration.

## Running the Application

### Start Infrastructure
Start MongoDB, Redis, and Mongo Express using Docker Compose:
```bash
make up
# OR
docker-compose up -d
```
- **Mongo Express** (Admin UI) will be available at [http://localhost:8081](http://localhost:8081) (Login: `admin`/`pass`)

### Start FastAPI Server
Run the application in development mode (hot-reloading enabled):
```bash
make run
# OR
uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8001
```

## Creating Documentation

### 1. Static HTML API Docs
Generate static Redocly documentation:
```bash
make docs
```
This will generate `api_docs.html`.

### 2. Export OpenAPI & Postman Collection
Export the API definition and a ready-to-import Postman collection:
```bash
uv run python scripts/export_openapi.py
```
This generates:
- `openapi.json`
- `postman_collection.json`

## Useful Commands
- `make install`: Sync dependencies.
- `make up`: Start Docker containers.
- `make down`: Stop Docker containers.
- `make run`: Run development server.
- `make test`: Run combined Pytest suite (verified: all 11 tests passing).
- `make lint`: Run Ruff linter and formatter.
