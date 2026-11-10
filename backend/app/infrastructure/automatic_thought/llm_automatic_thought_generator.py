from pydantic import ValidationError

from ...application.errors import InvalidModelResponseError
from ...application.ports.automatic_thought_generator import (
    AutomaticThoughtGenerator,
)
from ...schemas.automatic_thought import AutomaticThoughtGenerateResponse
from ..llm.registry import AUTOMATIC_THOUGHT_GENERATION_TASK, TaskLLMRouter
from ..prompts.registry import PromptRegistry


class LLMAutomaticThoughtGenerator(AutomaticThoughtGenerator):
    def __init__(
        self,
        router: TaskLLMRouter,
        prompt_registry: PromptRegistry,
    ) -> None:
        self._router = router
        self._prompt_registry = prompt_registry

    def generate(self, text: str) -> list[str]:
        response = self._router.generate_for_task(
            task=AUTOMATIC_THOUGHT_GENERATION_TASK,
            messages=self._prompt_registry.build_automatic_thought_messages(
                prompt_profile=self._router.resolve_target(
                    task=AUTOMATIC_THOUGHT_GENERATION_TASK
                ).prompt_profile,
                text=text,
            ),
        ).strip()

        if not response:
            raise InvalidModelResponseError(
                "Automatic thought model returned an empty response."
            )

        try:
            result = AutomaticThoughtGenerateResponse.model_validate_json(response)
        except ValidationError as exc:
            raise InvalidModelResponseError(
                "Automatic thought model returned an invalid result."
            ) from exc
        return list(dict.fromkeys(result.automatic_thoughts))
