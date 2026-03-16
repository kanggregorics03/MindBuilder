from ...application.errors import InvalidModelResponseError
from ...application.ports.translator import Translator
from ...domain.models.language import Language
from ..llm.registry import TRANSLATION_TASK, TaskLLMRouter
from ..prompts.registry import PromptRegistry


class LLMTranslator(Translator):
    def __init__(
        self,
        router: TaskLLMRouter,
        prompt_registry: PromptRegistry,
    ) -> None:
        self._router = router
        self._prompt_registry = prompt_registry

    def translate(
        self,
        text: str,
        *,
        source_language: Language,
        target_language: Language,
    ) -> str:
        normalized = text.strip()
        if not normalized:
            raise InvalidModelResponseError("Translator received empty text.")

        if source_language == target_language:
            return normalized

        target = self._router.resolve_target(task=TRANSLATION_TASK)
        translated = self._router.generate_for_task(
            task=TRANSLATION_TASK,
            messages=self._prompt_registry.build_translation_messages(
                prompt_profile=target.prompt_profile,
                source_language=source_language,
                target_language=target_language,
                text=normalized,
            ),
        ).strip()

        if not translated:
            raise InvalidModelResponseError(
                "Translation model returned an empty response."
            )

        return translated
