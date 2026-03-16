from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict

from .domain.models.language import Language


class Settings(BaseSettings):
    groq_api_key: str
    situation_refinement_provider: str = "groq"
    situation_refinement_model: str = "openai/gpt-oss-20b"
    situation_refinement_prompt_profile: str = "default"
    automatic_thought_generation_provider: str = "groq"
    automatic_thought_generation_model: str = (
        "meta-llama/llama-4-scout-17b-16e-instruct"
    )
    automatic_thought_generation_prompt_profile: str = "default"
    translation_provider: str = "groq"
    translation_model: str = "openai/gpt-oss-20b"
    translation_prompt_profile: str = "default"
    refinement_language: Language = Language.KOREAN
    allowed_origins: list[str] = ["*"]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()
