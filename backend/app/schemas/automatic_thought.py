from pydantic import BaseModel, Field


class AutomaticThoughtGenerateRequest(BaseModel):
    situation: str = Field(min_length=1, max_length=4000)
    original_situation: str = Field(default="", max_length=4000)
    emotions: list[str] = Field(default_factory=list, max_length=50)


class AutomaticThoughtGenerateResponse(BaseModel):
    automatic_thoughts: list[str]
