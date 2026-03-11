from pydantic import BaseModel, Field


class SituationRefineRequest(BaseModel):
    raw_situation: str = Field(min_length=1, max_length=2000)


class SituationRefineResponse(BaseModel):
    refined_situation: str
