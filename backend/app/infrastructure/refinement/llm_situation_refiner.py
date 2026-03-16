import json

from ...application.errors import InvalidModelResponseError
from ...application.ports.situation_refiner import SituationRefiner
from ...domain.models.language import Language
from ...schemas.situation import SituationRefineResult
from ..llm.registry import SITUATION_REFINEMENT_TASK, TaskLLMRouter
from ..prompts.registry import PromptRegistry


class LLMSituationRefiner(SituationRefiner):
    def __init__(
        self,
        router: TaskLLMRouter,
        prompt_registry: PromptRegistry,
    ) -> None:
        self._router = router
        self._prompt_registry = prompt_registry

    def refine(self, text: str, *, language: Language) -> SituationRefineResult:
        target = self._router.resolve_target(task=SITUATION_REFINEMENT_TASK)
        refined = self._router.generate_for_task(
            task=SITUATION_REFINEMENT_TASK,
            messages=self._prompt_registry.build_situation_refinement_messages(
                prompt_profile=target.prompt_profile,
                language=language,
                text=text,
            ),
        ).strip()

        if not refined:
            raise InvalidModelResponseError(
                "Situation refinement model returned an empty response."
            )

        try:
            payload = json.loads(refined)
        except json.JSONDecodeError as exc:
            raise InvalidModelResponseError(
                "Situation refinement model returned invalid JSON."
            ) from exc

        result = SituationRefineResult(
            original=str(payload.get("original", "")).strip(),
            feedback=str(payload.get("feedback", "")).strip(),
            reframed=str(payload.get("reframed", "")).strip(),
        )

        if not result.reframed:
            raise InvalidModelResponseError(
                "Situation refinement model returned an empty reframed value."
            )

        return result
