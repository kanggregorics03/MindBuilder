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
    try:
        use_case = get_refine_situation_use_case()
        refined = use_case.execute(payload.raw_situation)
    except ValueError as exc:
        logger.warning("Situation refinement received invalid input.")
        raise HTTPException(status_code=400, detail="Invalid situation input.") from exc
    except (InvalidModelResponseError, UpstreamServiceError) as exc:
        logger.warning("Situation refinement failed while calling an LLM.")
        raise HTTPException(
            status_code=502, detail="LLM service returned an unusable response."
        ) from exc
    except ConfigurationError as exc:
        logger.error("Situation refinement is misconfigured.")
        raise HTTPException(
            status_code=500, detail="Service configuration error."
        ) from exc
    except Exception as exc:
        logger.error("Unexpected error during situation refinement.")
        raise HTTPException(status_code=500, detail="Internal service error.") from exc

    return SituationRefineResponse(
        original=refined.original,
        feedback=refined.feedback,
        reframed=refined.reframed,
    )
