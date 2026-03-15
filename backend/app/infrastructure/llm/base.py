from dataclasses import dataclass
from typing import Protocol, Sequence


@dataclass(frozen=True)
class ChatMessage:
    role: str
    content: str


class ChatCompletionClient(Protocol):
    def generate(self, *, model: str, messages: Sequence[ChatMessage]) -> str:
        """Return a text completion for the provided chat messages."""
