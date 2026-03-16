from dataclasses import dataclass
from typing import Mapping, Sequence

from ...application.errors import ConfigurationError
from .base import ChatCompletionClient, ChatMessage

TRANSLATION_TASK = "translation"
SITUATION_REFINEMENT_TASK = "situation_refinement"
AUTOMATIC_THOUGHT_GENERATION_TASK = "automatic_thought_generation"


@dataclass(frozen=True)
class ModelTarget:
    provider: str
    model: str
    prompt_profile: str = "default"


class TaskLLMRouter:
    def __init__(
        self,
        *,
        providers: Mapping[str, ChatCompletionClient],
        task_models: Mapping[str, ModelTarget],
    ) -> None:
        self._providers = dict(providers)
        self._task_models = dict(task_models)

    def resolve_target(self, *, task: str) -> ModelTarget:
        target = self._task_models.get(task)
        if target is None:
            raise ConfigurationError(f"No model is configured for task '{task}'.")

        return target

    def generate_for_task(
        self,
        *,
        task: str,
        messages: Sequence[ChatMessage],
    ) -> str:
        target = self.resolve_target(task=task)

        provider = self._providers.get(target.provider)
        if provider is None:
            raise ConfigurationError(
                f"No provider client is registered for '{target.provider}'."
            )

        return provider.generate(model=target.model, messages=messages)
