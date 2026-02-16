# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.1] - 2026-02-08
### Added
- **Security**:
  - Password validation: minimum length, requires digit and uppercase letter
  - `AdminUserUpdate` schema for superuser-only role changes
  - Admin endpoint `PATCH /students/{id}/admin` for role modifications
  - Rate limiting on course creation (10 requests/minute)
  - Chat message input validation (max 10,000 characters)
- **Infrastructure**:
  - `close_db()` and `close_redis()` shutdown functions
  - Proper database connection cleanup in application lifespan

### Changed
- **Security**:
  - Removed `role` field from `UserUpdate` to prevent privilege escalation
  - Fixed route ordering in `students.py` (`/me` routes now before `/{id}`)
- **Code Quality**:
  - Fixed all 26 Ruff lint errors (W293, B904, F401)
  - Standardized exception chaining with `raise ... from err`
  - Removed unused `fastapi_users` import
  - OpenAPI server URL now uses `settings.PORT`
  - Standardized error detail codes (e.g., `USER_NOT_FOUND`)
- **Infrastructure**:
  - Removed unused `motor` dependency
  - Standardized ports to 8001 in Makefile and Dockerfile
  - Removed debug print statements from test fixtures

## [0.4.0] - 2026-02-07
### Added
- **Security**:
  - Production SECRET_KEY validation - app fails to start if default key used in prod/staging
  - Request ID middleware for distributed tracing (`X-Request-ID` header)
- **Features**:
  - `CourseService`: Service layer for course business logic with dependency injection
  - `Pagination`: Course listing now supports `limit` and `offset` query parameters
  - `Unenroll`: New endpoint `DELETE /courses/{id}/enroll` for student unenrollment
  - `Published Check`: Students can only enroll in published courses
  - `Health Checks`: Enhanced `/health` endpoint with MongoDB and Redis connectivity status
- **Infrastructure**:
  - Production-ready multi-stage Dockerfile with non-root user
  - Docker health check configuration
- **Configuration**:
  - `MIN_PASSWORD_LENGTH` setting for password policy
  - `DEFAULT_PAGE_LIMIT` and `MAX_PAGE_LIMIT` pagination settings

### Changed
- **Code Quality**:
  - Fixed import order in `main.py` (moved `get_openapi` to module level)
  - Fixed inline imports in `auth.py` (moved to module level)
  - Replaced debug print statements with proper logging in `database.py`
  - Extracted business logic from `courses.py` into `CourseService`

## [0.3.0] - 2026-02-06
### Added
- **Features**:
  - `Courses CRUD`: Full lifecycle management for courses including title uniqueness and instructor-only permissions.
  - `Students CRUD`: Integrated `fastapi-users` management router for students.
  - `Enrollment`: New endpoint for students to join courses.
  - `Models`: Added `Course` document model with Beanie `Link` support for relationships.
- **Refactoring & Fixes**:
  - `Stability`: Fixed circular/missing imports in API routing.
  - `Edge Cases`: Added duplicate course title prevention and enrollment guards.

## [0.2.0] - 2026-02-06
### Added
- **Features**:
  - `UserRole`: Added `INSTRUCTOR` and `STUDENT` roles to the system.
  - `Schemas`: Exposed `role` in `UserRead`, `UserCreate`, and `UserUpdate` schemas.
  - `Authentication`: Implemented custom JWT payload including email, role, and name fields.
  - `Configuration`: Moved default application port to `8001` to resolve host-level system conflicts.
- **Refactoring & Fixes**:
  - `Tests`: Organized tests into `unit` and `integration` directories (All 9 tests passing).
  - `Database`: Reverted to `pymongo` (AsyncMongoClient) as the primary driver for Beanie and stability. (Reverted Motor migration based on user preference).
  - `Authentication`: Disabled MongoDB authentication for local development.
  - `Bug Fix`: Handled duplicate user registration gracefully (returns 400 instead of 500).

## [0.1.0] - 2026-02-06
### Added
- **Documentation**:
  - `docs/OVERVIEW.md`: General project overview and tech stack.
  - `docs/SETUP.md`: Comprehensive setup and installation guide.
  - `docs/DATABASE.md`: Database schema, models, and infrastructure details.
- **Configuration**:
  - `.env.example`: Template for environment variables.
  - `.env`: Local development configuration (initialized).
