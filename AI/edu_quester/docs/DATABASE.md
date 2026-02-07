# Database & Infrastructure

## MongoDB
The application uses MongoDB v7.0 as its primary data store.

### ODM: Beanie
We use [Beanie](https://beanie-odm.dev/) as the ODM (Object Document Mapper). Beanie sits on top of **PyMongo** (AsyncMongoClient) and Pydantic, providing a robust way to model documents.

### Connection
Database connection is initialized in `app/db/database.py`. The application waits for a successful MongoDB ping on startup before proceeding.

### Models
Models are defined in `app/db/models.py`.
- **User**: Extends `BeanieBaseUser` from `fastapi-users`.
  - Fields: `id` (UUID), `email`, `hashed_password`, `is_active`, `is_superuser`, `is_verified`, `first_name`, `last_name`, `role`.
  - Collection: `users`
- **Course**: Main entity for content management.
  - Fields: `title` (Unique), `description`, `github_repo_url`, `level` (Enum), `instructor` (Link to User), `students` (List[Link to User]), `is_published`.
  - Collection: `courses`

## Redis
Redis v7.2 is used for:
1. **Rate Limiting**: via `fastapi-limiter`.
2. **Caching**: General purpose caching.
3. **Session/Token Storage**: (If configured for stateful sessions).

### Configuration
Redis connection is established in `app/db/database.py`.

## Docker Services

### mongodb
- **Port**: 27017
- **Volume**: `mongodb_data` (Persistent)
- **Default Auth**: Disabled (for local development/test)
- **Root User**: (Optional) `root` / `example` (Disabled in `docker-compose.yml`)

### redis
- **Port**: 6379
- **Volume**: `redis_data` (Persistent)
- **Password**: `securepassword`

### mongo-express
- **Web UI**: [http://localhost:8081](http://localhost:8081)
- **Port**: 8081
- **Auth**: `admin` / `pass`
