import json

from ..errors import InvalidModelResponseError
from ..ports.automatic_thought_generator import AutomaticThoughtGenerator
from ..ports.translator import Translator
from ...domain.models.language import Language


class GenerateAutomaticThoughtsUseCase:
    def __init__(
        self,
        *,
        generator: AutomaticThoughtGenerator,
        translator: Translator,
    ) -> None:
        self._generator = generator
        self._translator = translator

    def execute(self, situation: str) -> list[str]:
        normalized = situation.strip()
        if not normalized:
            raise ValueError("situation must not be blank.")

        english_situation = self._translator.translate(
            normalized,
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
            data = json.loads(translated_payload)
        except json.JSONDecodeError as exc:
            raise InvalidModelResponseError(
                "Translated automatic thought payload was not valid JSON."
            ) from exc

        translated = [
            str(item).strip()
            for item in data.get("automatic_thoughts", [])
            if str(item).strip()
        ]
        if not translated:
            raise InvalidModelResponseError(
                "Translated automatic thought payload was empty."
            )

        return translated
