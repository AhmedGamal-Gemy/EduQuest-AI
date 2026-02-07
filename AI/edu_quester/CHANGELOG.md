# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
