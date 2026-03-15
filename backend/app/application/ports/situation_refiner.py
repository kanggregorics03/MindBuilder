from typing import Protocol

from ...domain.models.language import Language
from ...schemas.situation import SituationRefineResult


class SituationRefiner(Protocol):
    def refine(self, text: str, *, language: Language) -> SituationRefineResult:
        """Rewrite input into a structured CBT situation response."""
