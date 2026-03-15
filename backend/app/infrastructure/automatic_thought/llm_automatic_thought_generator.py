import json

from ...application.errors import InvalidModelResponseError
from ...application.ports.automatic_thought_generator import (
    AutomaticThoughtGenerator,
)
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
            payload = json.loads(response)
        except json.JSONDecodeError as exc:
            raise InvalidModelResponseError(
                "Automatic thought model returned invalid JSON."
            ) from exc

        thoughts = [
            str(item).strip()
            for item in payload.get("automatic_thoughts", [])
            if str(item).strip()
        ]
        unique_thoughts = list(dict.fromkeys(thoughts))
        if not unique_thoughts:
            raise InvalidModelResponseError(
                "Automatic thought model returned no thoughts."
            )

        return unique_thoughts
