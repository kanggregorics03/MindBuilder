from typing import Annotated

from pydantic import BaseModel, ConfigDict, Field, StringConstraints


class AutomaticThoughtGenerateRequest(BaseModel):
    situation: str = Field(min_length=1, max_length=4000)
    original_situation: str = Field(default="", max_length=4000)
    emotions: list[str] = Field(default_factory=list, max_length=50)


class AutomaticThoughtGenerateResponse(BaseModel):
    model_config = ConfigDict(strict=True)
    automatic_thoughts: list[
        Annotated[str, StringConstraints(strip_whitespace=True, min_length=1)]
    ] = Field(min_length=1)
