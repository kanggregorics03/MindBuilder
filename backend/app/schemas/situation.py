from pydantic import BaseModel, ConfigDict, Field


class SituationRefineRequest(BaseModel):
    raw_situation: str = Field(min_length=1, max_length=2000)


class SituationRefineResult(BaseModel):
    model_config = ConfigDict(strict=True, str_strip_whitespace=True)
    original: str = Field(min_length=1)
    feedback: str = Field(min_length=1)
    reframed: str = Field(min_length=1)


class SituationRefineResponse(BaseModel):
    original: str
    feedback: str
    reframed: str
