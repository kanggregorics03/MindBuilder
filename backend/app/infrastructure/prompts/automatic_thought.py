from typing import Sequence

from ..llm.base import ChatMessage


class DefaultAutomaticThoughtPromptBuilder:
    def build_messages(self, *, text: str) -> Sequence[ChatMessage]:
        return [
            ChatMessage(
                role="system",
                content=build_automatic_thought_system_prompt(),
            ),
            ChatMessage(
                role="user",
                content=build_automatic_thought_user_prompt(text),
            ),
        ]


def build_automatic_thought_system_prompt() -> str:
    return """You identify possible CBT automatic thoughts.

Task:
Generate 4 to 8 possible automatic thoughts the user may have had.

Rules:
- Each thought must be meaningfully different.
- Do not repeat the same idea with different wording.
- Keep only thoughts that naturally fit the user statement and situation.
- Do not overinterpret or jump too far beyond the situation.
- Use short, natural, first-person inner-monologue sentences.
- One sentence = one interpretation only.
- Prefer thoughts that show interpretation, assumption, conclusion, or prediction rather than emotion alone.
- No explanation, advice, diagnosis, labels, or counselor tone.
- Final output must be natural English.

Return JSON only:
{ "automatic_thoughts": ["...", "...", "..."] }"""


def build_automatic_thought_user_prompt(text: str) -> str:
    return f"Input:\n{text}"
