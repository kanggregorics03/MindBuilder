from typing import Mapping, Protocol, Sequence

from ...application.errors import ConfigurationError
from ...domain.models.language import Language
from ..llm.base import ChatMessage
from ..llm.registry import (
    AUTOMATIC_THOUGHT_GENERATION_TASK,
    SITUATION_REFINEMENT_TASK,
    TRANSLATION_TASK,
)
from .automatic_thought import DefaultAutomaticThoughtPromptBuilder
from .situation_refine import (
    DefaultSituationRefinePromptBuilder,
    GptOssSituationRefinePromptBuilder,
)
from .translation import (
    DefaultTranslationPromptBuilder,
    GptOssTranslationPromptBuilder,
)


class TranslationPromptBuilder(Protocol):
    def build_messages(
        self,
        *,
        source_language: Language,
        target_language: Language,
        text: str,
    ) -> Sequence[ChatMessage]: ...


class SituationRefinePromptBuilder(Protocol):
    def build_messages(
        self,
        *,
        language: Language,
        text: str,
    ) -> Sequence[ChatMessage]: ...


class AutomaticThoughtPromptBuilder(Protocol):
    def build_messages(
        self,
        *,
        text: str,
    ) -> Sequence[ChatMessage]: ...


class PromptRegistry:
    def __init__(
        self,
        *,
        translation_builders: Mapping[str, TranslationPromptBuilder],
        situation_refinement_builders: Mapping[str, SituationRefinePromptBuilder],
        automatic_thought_builders: Mapping[str, AutomaticThoughtPromptBuilder],
    ) -> None:
        self._translation_builders = dict(translation_builders)
        self._situation_refinement_builders = dict(situation_refinement_builders)
        self._automatic_thought_builders = dict(automatic_thought_builders)

    def build_translation_messages(
        self,
        *,
        prompt_profile: str,
        source_language: Language,
        target_language: Language,
        text: str,
    ) -> Sequence[ChatMessage]:
        builder = self._translation_builders.get(prompt_profile)
        if builder is None:
            raise ConfigurationError(
                _unknown_profile_message(
                    task=TRANSLATION_TASK,
                    prompt_profile=prompt_profile,
                )
            )

        return builder.build_messages(
            source_language=source_language,
            target_language=target_language,
            text=text,
        )

    def build_situation_refinement_messages(
        self,
        *,
        prompt_profile: str,
        language: Language,
        text: str,
    ) -> Sequence[ChatMessage]:
        builder = self._situation_refinement_builders.get(prompt_profile)
        if builder is None:
            raise ConfigurationError(
                _unknown_profile_message(
                    task=SITUATION_REFINEMENT_TASK,
                    prompt_profile=prompt_profile,
                )
            )

        return builder.build_messages(language=language, text=text)

    def build_automatic_thought_messages(
        self,
        *,
        prompt_profile: str,
        text: str,
    ) -> Sequence[ChatMessage]:
        builder = self._automatic_thought_builders.get(prompt_profile)
        if builder is None:
            raise ConfigurationError(
                _unknown_profile_message(
                    task=AUTOMATIC_THOUGHT_GENERATION_TASK,
                    prompt_profile=prompt_profile,
                )
            )

        return builder.build_messages(text=text)


def create_default_prompt_registry() -> PromptRegistry:
    return PromptRegistry(
        translation_builders={
            "default": DefaultTranslationPromptBuilder(),
            "gpt_oss_translation_v1": GptOssTranslationPromptBuilder(),
        },
        situation_refinement_builders={
            "default": DefaultSituationRefinePromptBuilder(),
            "gpt_oss_refine_v1": GptOssSituationRefinePromptBuilder(),
        },
        automatic_thought_builders={
            "default": DefaultAutomaticThoughtPromptBuilder(),
        },
    )


def _unknown_profile_message(*, task: str, prompt_profile: str) -> str:
    return (
        f"No prompt profile '{prompt_profile}' is registered for task '{task}'."
    )
