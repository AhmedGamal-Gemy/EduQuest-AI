# --------------------------------------------------------------------------- #
# EduQuest AI Backend - Production Dockerfile
# --------------------------------------------------------------------------- #
# Multi-stage build for optimized production image
# Uses uv for fast dependency installation
# --------------------------------------------------------------------------- #

# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

# Install uv for fast package management
RUN pip install --no-cache-dir uv

# Copy dependency files first (for layer caching)
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

# --------------------------------------------------------------------------- #
# Stage 2: Production Runtime
# --------------------------------------------------------------------------- #
FROM python:3.11-slim AS runtime

WORKDIR /app

# Create non-root user for security
RUN groupadd --gid 1000 appgroup && \
    useradd --uid 1000 --gid appgroup --shell /bin/bash --create-home appuser

# Copy virtual environment and application from builder
COPY --from=builder /app /app

# Set ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8001/health')" || exit 1

# Expose port
EXPOSE 8001

# Run the application with Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
