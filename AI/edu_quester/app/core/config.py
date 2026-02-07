from typing import List, Union
from pydantic import AnyHttpUrl, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict
from app.core.enums import LogEvents

class Settings(BaseSettings):
    PROJECT_NAME: str = "EduQuest AI"
    API_V1_STR: str = "/api/v1"
    PORT: int = 8001
    
    # Add this field
    ENVIRONMENT: str = "dev"  # Default to local/dev

    # CORS
    BACKEND_CORS_ORIGINS: List[Union[str, AnyHttpUrl]] = []

    @field_validator("BACKEND_CORS_ORIGINS", mode="before")
    @classmethod
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> List[str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # Secrets (Required in Prod)
    SECRET_KEY: str = "SECRET_KEY_CHANGEME"
    
    # Database
    MONGODB_URL: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "eduquest"
    
    # Redis
    REDIS_URL: str = "redis://:securepassword@localhost:6379"

    # JWT
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 days
    ALGORITHM: str = "HS256"

    model_config = SettingsConfigDict(case_sensitive=True, env_file=".env")

settings = Settings()
