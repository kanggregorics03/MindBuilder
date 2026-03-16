from ..ports.situation_refiner import SituationRefiner
from ...domain.models.language import Language
from ...schemas.situation import SituationRefineResult


class RefineSituationUseCase:
    def __init__(
        self,
        *,
        refiner: SituationRefiner,
        refinement_language: Language,
    ) -> None:
        self._refiner = refiner
        self._refinement_language = refinement_language

    def execute(self, raw_situation: str) -> SituationRefineResult:
        normalized = raw_situation.strip()
        if not normalized:
            raise ValueError("raw_situation must not be blank.")

        return self._refiner.refine(
            normalized,
            language=self._refinement_language,
        )
