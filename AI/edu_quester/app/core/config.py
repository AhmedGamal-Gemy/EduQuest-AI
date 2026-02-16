
from pydantic import AnyHttpUrl, field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    All settings can be overridden via .env file or environment variables.
    Critical security settings are validated for production deployments.
    """

    PROJECT_NAME: str = "EduQuest AI"
    API_V1_STR: str = "/api/v1"
    PORT: int = 8001

    # Environment: local, dev, staging, prod
    ENVIRONMENT: str = "dev"


    # CORS
    BACKEND_CORS_ORIGINS: list[str | AnyHttpUrl] = []

    @field_validator("BACKEND_CORS_ORIGINS", mode="before")
    @classmethod
    def assemble_cors_origins(cls, v: str | list[str]) -> list[str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # Secrets (Required in Prod)
    SECRET_KEY: str = "SECRET_KEY_CHANGEME"

    # Password Policy
    MIN_PASSWORD_LENGTH: int = 8

    # Database
    MONGODB_URL: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "eduquest"

    # Redis
    REDIS_URL: str = "redis://:securepassword@localhost:6379"

    # AI - Image Generation
    GROK_API_KEY: str | None = None

    # JWT
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 days
    ALGORITHM: str = "HS256"

    # Pagination
    DEFAULT_PAGE_LIMIT: int = 20
    MAX_PAGE_LIMIT: int = 100

    @model_validator(mode="after")
    def validate_production_settings(self) -> "Settings":
        """Validate critical settings for production environments."""
        if self.ENVIRONMENT in ("prod", "production", "staging"):
            if self.SECRET_KEY == "SECRET_KEY_CHANGEME":
                raise ValueError(
                    "SECRET_KEY must be changed from default value in production! "
                    "Generate a secure key using: openssl rand -hex 32"
                )
        return self

    model_config = SettingsConfigDict(case_sensitive=True, env_file=".env")


settings = Settings()
