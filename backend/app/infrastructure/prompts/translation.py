from typing import Sequence

from ...domain.models.language import Language
from ..llm.base import ChatMessage


class DefaultTranslationPromptBuilder:
    def build_messages(
        self,
        *,
        source_language: Language,
        target_language: Language,
        text: str,
    ) -> Sequence[ChatMessage]:
        return [
            ChatMessage(
                role="system",
                content=build_translation_system_prompt(
                    source_language,
                    target_language,
                ),
            ),
            ChatMessage(
                role="user",
                content=build_translation_user_prompt(text),
            ),
        ]


class GptOssTranslationPromptBuilder(DefaultTranslationPromptBuilder):
    """Dedicated extension point for GPT-OSS-specific translation tuning."""


def build_translation_system_prompt(
    source_language: Language,
    target_language: Language,
) -> str:
    source_name = _language_name(source_language)
    target_name = _language_name(target_language)

    return f"""You are a precise translator.

Translate the user's text from {source_name} to {target_name}.

Requirements:
- Preserve all facts, uncertainty, and emotional intensity from the original text.
- Do not add explanations, examples, or extra context.
- Do not censor or summarize the input.
- If the input is already in {target_name}, return it naturally in {target_name}.
- Return only the translated text.
"""


def build_translation_user_prompt(text: str) -> str:
    return f"Text: {text}"


def _language_name(language: Language) -> str:
    if language is Language.KOREAN:
        return "Korean"

    return "English"
