import json

from pydantic import ValidationError

from ..errors import InvalidModelResponseError
from ..ports.automatic_thought_generator import AutomaticThoughtGenerator
from ..ports.translator import Translator
from ...domain.models.language import Language
from ...schemas.automatic_thought import AutomaticThoughtGenerateResponse


class GenerateAutomaticThoughtsUseCase:
    def __init__(
        self,
        *,
        generator: AutomaticThoughtGenerator,
        translator: Translator,
    ) -> None:
        self._generator = generator
        self._translator = translator

    def execute(
        self,
        *,
        situation: str,
        original_situation: str = "",
        emotions: list[str] | None = None,
    ) -> list[str]:
        normalized = situation.strip()
        if not normalized:
            raise ValueError("situation must not be blank.")

        normalized_original = original_situation.strip()
        normalized_emotions = [
            emotion.strip() for emotion in (emotions or []) if emotion.strip()
        ]
        generation_context = self._build_generation_context(
            situation=normalized,
            original_situation=normalized_original,
            emotions=normalized_emotions,
        )
        english_situation = self._translator.translate(
            generation_context,
            source_language=Language.KOREAN,
            target_language=Language.ENGLISH,
        )
        thoughts = self._generator.generate(english_situation)
        payload = json.dumps(
            {"automatic_thoughts": thoughts},
            ensure_ascii=False,
        )
        translated_payload = self._translator.translate(
            payload,
            source_language=Language.ENGLISH,
            target_language=Language.KOREAN,
        ).strip()

        try:
            result = AutomaticThoughtGenerateResponse.model_validate_json(
                translated_payload
            )
        except ValidationError as exc:
            raise InvalidModelResponseError(
                "Translated automatic thought payload was invalid."
            ) from exc
        return list(dict.fromkeys(result.automatic_thoughts))

    def _build_generation_context(
        self,
        *,
        situation: str,
        original_situation: str,
        emotions: list[str],
    ) -> str:
        sections = [f"Refined situation:\n{situation}"]
        if original_situation:
            sections.append(f"Original situation:\n{original_situation}")
        if emotions:
            sections.append(
                "Selected emotions:\n" + "\n".join(f"- {item}" for item in emotions)
            )
        return "\n\n".join(sections)
