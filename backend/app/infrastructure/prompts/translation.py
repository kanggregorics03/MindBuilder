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
- If the input is structured text such as JSON, preserve the structure exactly.
- For JSON input, keep keys, brackets, commas, and quoting valid JSON.
- For JSON input, translate only human-readable string values when needed.
- Never wrap the output in markdown fences or commentary.
- Return only the translated text.
"""


def build_translation_user_prompt(text: str) -> str:
    return f"""Translate the following text.

If it is JSON, return valid JSON with the same structure.

Text:
{text}"""


def _language_name(language: Language) -> str:
    if language is Language.KOREAN:
        return "Korean"

    return "English"
