from typing import Protocol


class AutomaticThoughtGenerator(Protocol):
    def generate(self, text: str) -> list[str]:
        """Generate candidate automatic thoughts in English."""
