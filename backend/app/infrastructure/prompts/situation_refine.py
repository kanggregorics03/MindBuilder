from typing import Sequence

from ...domain.models.language import Language
from ..llm.base import ChatMessage


class DefaultSituationRefinePromptBuilder:
    def build_messages(
        self,
        *,
        language: Language,
        text: str,
    ) -> Sequence[ChatMessage]:
        return [
            ChatMessage(
                role="system",
                content=build_situation_refine_system_prompt(language),
            ),
            ChatMessage(
                role="user",
                content=build_situation_refine_user_prompt(text),
            ),
        ]


class GptOssSituationRefinePromptBuilder(DefaultSituationRefinePromptBuilder):
    """Dedicated extension point for GPT-OSS-specific refinement tuning."""


def build_situation_refine_system_prompt(language: Language) -> str:
    if language is not Language.KOREAN:
        raise ValueError("Situation refinement prompt currently supports Korean only.")

    return """Please reframe the following sentence using a CBT approach.

Goal:

Reduce emotional interpretation or guessing
Rewrite it using observable, fact-based language
Soften absolute or definitive wording
Rules:

Write the feedback in exactly one sentence
Keep it short, gentle, and unlikely to hurt feelings
Do not criticize the original sentence
Do not use absolute expressions such as "always," "definitely," or "you're wrong"
Do not sound like therapy, diagnosis, or counseling
Treat this as sentence refinement only
Output format: Return only a JSON object. Do not include any explanation.

{ "original": "<original sentence>", "feedback": "<short and gentle feedback for making it more fact-based>", "reframed": "<sentence rewritten in a more fact-based way>" }

Important:

Write all output values in Korean
Respond in Korean only"""


def build_situation_refine_user_prompt(text: str) -> str:
    return f"User input: {text}"
