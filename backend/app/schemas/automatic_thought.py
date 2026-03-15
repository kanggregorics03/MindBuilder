from pydantic import BaseModel, Field


class AutomaticThoughtGenerateRequest(BaseModel):
    situation: str = Field(min_length=1, max_length=4000)


class AutomaticThoughtGenerateResponse(BaseModel):
    automatic_thoughts: list[str]
