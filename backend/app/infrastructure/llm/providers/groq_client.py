from typing import Sequence

import groq
from groq import Groq

from ....application.errors import UpstreamServiceError
from ..base import ChatCompletionClient, ChatMessage


class GroqChatCompletionClient(ChatCompletionClient):
    def __init__(self, *, api_key: str) -> None:
        self._client = Groq(api_key=api_key)

    def generate(self, *, model: str, messages: Sequence[ChatMessage]) -> str:
        try:
            response = self._client.chat.completions.create(
                model=model,
                messages=[
                    {"role": message.role, "content": message.content}
                    for message in messages
                ],
            )
        except groq.APIError as exc:
            raise UpstreamServiceError(str(exc)) from exc

        return (response.choices[0].message.content or "").strip()
