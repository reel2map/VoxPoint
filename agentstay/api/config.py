import os
from functools import lru_cache
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql+asyncpg://agentstay:agentstay@db:5432/agentstay"
    TELEGRAM_BOT_TOKEN: str = ""
    SITE_BASE_URL: str = "http://localhost:8000"
    SECRET_KEY: str = "agentstay-secret-key-change-in-production"
    DEBUG: bool = False

    class Config:
        env_file = ".env"


@lru_cache()
def get_settings() -> Settings:
    return Settings()
