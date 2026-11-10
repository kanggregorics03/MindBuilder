import logging

from fastapi import APIRouter, HTTPException

from ...application.errors import (
    ConfigurationError,
    InvalidModelResponseError,
    UpstreamServiceError,
)
from ...container import get_generate_automatic_thoughts_use_case
from ...schemas.automatic_thought import (
    AutomaticThoughtGenerateRequest,
    AutomaticThoughtGenerateResponse,
)

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post(
    "/api/automatic-thoughts/generate",
    response_model=AutomaticThoughtGenerateResponse,
)
def generate_automatic_thoughts_endpoint(
    payload: AutomaticThoughtGenerateRequest,
) -> AutomaticThoughtGenerateResponse:
    try:
        use_case = get_generate_automatic_thoughts_use_case()
        thoughts = use_case.execute(
            situation=payload.situation,
            original_situation=payload.original_situation,
            emotions=payload.emotions,
        )
    except ValueError as exc:
        logger.warning("Automatic thought generation received invalid input.")
        raise HTTPException(
            status_code=400, detail="Invalid automatic thought input."
        ) from exc
    except (InvalidModelResponseError, UpstreamServiceError) as exc:
        logger.warning("Automatic thought generation failed while calling an LLM.")
        raise HTTPException(
            status_code=502, detail="LLM service returned an unusable response."
        ) from exc
    except ConfigurationError as exc:
        logger.error("Automatic thought generation is misconfigured.")
        raise HTTPException(
            status_code=500, detail="Service configuration error."
        ) from exc
    except Exception as exc:
        logger.error("Unexpected error during automatic thought generation.")
        raise HTTPException(status_code=500, detail="Internal service error.") from exc

    return AutomaticThoughtGenerateResponse(automatic_thoughts=thoughts)
