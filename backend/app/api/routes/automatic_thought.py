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
    use_case = get_generate_automatic_thoughts_use_case()

    try:
        thoughts = use_case.execute(payload.situation)
    except ValueError as exc:
        logger.exception("Automatic thought generation received invalid input.")
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except (InvalidModelResponseError, UpstreamServiceError) as exc:
        logger.exception("Automatic thought generation failed while calling an LLM.")
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except ConfigurationError as exc:
        logger.exception("Automatic thought generation is misconfigured.")
        raise HTTPException(status_code=500, detail=str(exc)) from exc
    except Exception as exc:
        logger.exception("Unexpected error during automatic thought generation.")
        raise HTTPException(status_code=500, detail=str(exc)) from exc

    return AutomaticThoughtGenerateResponse(automatic_thoughts=thoughts)
