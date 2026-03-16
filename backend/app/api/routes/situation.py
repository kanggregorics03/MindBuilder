import logging

from fastapi import APIRouter, HTTPException

from ...application.errors import (
    ConfigurationError,
    InvalidModelResponseError,
    UpstreamServiceError,
)
from ...container import get_refine_situation_use_case
from ...schemas.situation import SituationRefineRequest, SituationRefineResponse

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post("/api/situation/refine", response_model=SituationRefineResponse)
def refine_situation_endpoint(
    payload: SituationRefineRequest,
) -> SituationRefineResponse:
    use_case = get_refine_situation_use_case()

    try:
        refined = use_case.execute(payload.raw_situation)
    except ValueError as exc:
        logger.exception("Situation refinement received invalid input.")
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except (InvalidModelResponseError, UpstreamServiceError) as exc:
        logger.exception("Situation refinement failed while calling an LLM.")
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except ConfigurationError as exc:
        logger.exception("Situation refinement is misconfigured.")
        raise HTTPException(status_code=500, detail=str(exc)) from exc
    except Exception as exc:
        logger.exception("Unexpected error during situation refinement.")
        raise HTTPException(status_code=500, detail=str(exc)) from exc

    return SituationRefineResponse(
        original=refined.original,
        feedback=refined.feedback,
        reframed=refined.reframed,
    )
