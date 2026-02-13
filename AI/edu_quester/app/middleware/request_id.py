"""
Request ID middleware for request tracing and log correlation.

Adds a unique request ID to each incoming request, which can be used
for debugging and log correlation across distributed systems.
"""

import uuid

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response

from edu_quester.shared.logger import logger

REQUEST_ID_HEADER = "X-Request-ID"


class RequestIDMiddleware(BaseHTTPMiddleware):
    """Middleware that assigns a unique ID to each request.

    The request ID is:
    1. Read from incoming X-Request-ID header if present
    2. Generated as a new UUID if not present
    3. Added to response headers
    4. Available in request.state.request_id for use in logging
    """

    async def dispatch(self, request: Request, call_next) -> Response:
        # Get or generate request ID
        request_id = request.headers.get(REQUEST_ID_HEADER)
        if not request_id:
            request_id = str(uuid.uuid4())

        # Store in request state for access in route handlers
        request.state.request_id = request_id

        # Log the request with request ID
        logger.bind(
            author="api",
            request_id=request_id
        ).info(f"{request.method} {request.url.path}")

        # Process request
        response = await call_next(request)

        # Add request ID to response headers
        response.headers[REQUEST_ID_HEADER] = request_id

        return response
