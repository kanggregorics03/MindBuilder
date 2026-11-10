from typing import Sequence

import groq
from groq import Groq

from ....application.errors import InvalidModelResponseError, UpstreamServiceError
from ..base import ChatCompletionClient, ChatMessage


class GroqChatCompletionClient(ChatCompletionClient):
    def __init__(self, *, api_key: str) -> None:
        self._client = Groq(api_key=api_key, timeout=30.0, max_retries=0)

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
            raise UpstreamServiceError("LLM provider request failed.") from exc

        if not response.choices:
            raise InvalidModelResponseError("LLM provider returned no choices.")
        content = response.choices[0].message.content
        if not isinstance(content, str) or not content.strip():
            raise InvalidModelResponseError("LLM provider returned no text.")
        return content.strip()
