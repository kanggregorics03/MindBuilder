from typing import Protocol

from ...domain.models.language import Language


class Translator(Protocol):
    def translate(
        self,
        text: str,
        *,
        source_language: Language,
        target_language: Language,
    ) -> str:
        """Translate text between languages without changing facts."""
