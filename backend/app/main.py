import logging

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from openai import OpenAIError

from .config import get_settings
from .models import SituationRefineRequest, SituationRefineResponse
from .openai_service import refine_situation

settings = get_settings()
logger = logging.getLogger(__name__)

app = FastAPI(title="Mind Builder Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/api/situation/refine", response_model=SituationRefineResponse)
def refine_situation_endpoint(
    payload: SituationRefineRequest,
) -> SituationRefineResponse:
    try:
        refined = refine_situation(payload.raw_situation.strip())
    except ValueError as exc:
        logger.exception("Situation refinement returned an empty response.")
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except OpenAIError as exc:
        logger.exception("OpenAI request failed during situation refinement.")
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except Exception as exc:
        logger.exception("Unexpected error during situation refinement.")
        raise HTTPException(status_code=500, detail=str(exc)) from exc

    return SituationRefineResponse(refined_situation=refined)
