import json
from types import SimpleNamespace
from unittest.mock import Mock, patch

import groq
import httpx
import pytest

from app.application.errors import InvalidModelResponseError, UpstreamServiceError
from app.application.use_cases.generate_automatic_thoughts import (
    GenerateAutomaticThoughtsUseCase,
)
from app.application.use_cases.refine_situation import RefineSituationUseCase
from app.domain.models.language import Language
from app.infrastructure.automatic_thought.llm_automatic_thought_generator import (
    LLMAutomaticThoughtGenerator,
)
from app.infrastructure.llm.providers.groq_client import GroqChatCompletionClient
from app.infrastructure.prompts import create_default_prompt_registry
from app.infrastructure.refinement.llm_situation_refiner import LLMSituationRefiner


def router_returning(response):
    router = Mock()
    router.resolve_target.return_value = SimpleNamespace(prompt_profile="default")
    router.generate_for_task.return_value = response
    return router


@pytest.mark.parametrize(
    "response",
    [
        "",
        "not json",
        "[]",
        "null",
        '"text"',
        "{}",
        '{"original":"x","feedback":"x"}',
        '{"original":null,"feedback":"x","reframed":"x"}',
        '{"original":"x","feedback":{},"reframed":"x"}',
        '{"original":"x","feedback":"x","reframed":"  "}',
    ],
)
def test_situation_rejects_unusable_json(response):
    refiner = LLMSituationRefiner(
        router_returning(response), create_default_prompt_registry()
    )
    with pytest.raises(InvalidModelResponseError):
        refiner.refine("synthetic input", language=Language.KOREAN)


def test_valid_situation_is_trimmed():
    payload = json.dumps(
        dict(original=" original ", feedback=" feedback ", reframed=" reframed ")
    )
    result = LLMSituationRefiner(
        router_returning(payload), create_default_prompt_registry()
    ).refine("synthetic", language=Language.KOREAN)
    assert result.model_dump() == dict(
        original="original", feedback="feedback", reframed="reframed"
    )


BAD_THOUGHTS = [
    "",
    "broken",
    "[]",
    "null",
    "{}",
    '{"automatic_thoughts":null}',
    '{"automatic_thoughts":"abc"}',
    '{"automatic_thoughts":[null]}',
    '{"automatic_thoughts":[123]}',
    '{"automatic_thoughts":[{}]}',
    '{"automatic_thoughts":[]}',
    '{"automatic_thoughts":[" "]}',
]


@pytest.mark.parametrize("response", BAD_THOUGHTS)
def test_generator_rejects_invalid_thought_payload(response):
    generator = LLMAutomaticThoughtGenerator(
        router_returning(response), create_default_prompt_registry()
    )
    with pytest.raises(InvalidModelResponseError):
        generator.generate("synthetic input")


@pytest.mark.parametrize("response", BAD_THOUGHTS)
def test_translated_json_is_also_validated(response):
    translator = Mock()
    translator.translate.side_effect = ["translated context", response]
    generator = Mock()
    generator.generate.return_value = ["synthetic thought"]
    with pytest.raises(InvalidModelResponseError):
        GenerateAutomaticThoughtsUseCase(
            generator=generator, translator=translator
        ).execute(situation="test")


def test_valid_thoughts_are_trimmed_and_deduplicated():
    response = '{"automatic_thoughts":[" first ","first","second"]}'
    result = LLMAutomaticThoughtGenerator(
        router_returning(response), create_default_prompt_registry()
    ).generate("test")
    assert result == ["first", "second"]


def test_provider_failure_hides_body_and_sets_request_budget():
    with patch("app.infrastructure.llm.providers.groq_client.Groq") as client_type:
        client = GroqChatCompletionClient(api_key="fake-key")
        client_type.assert_called_once_with(
            api_key="fake-key", timeout=30.0, max_retries=0
        )
        client_type.return_value.chat.completions.create.side_effect = (
            groq.APIConnectionError(
                message="private synthetic conversation",
                request=httpx.Request("POST", "https://example.invalid"),
            )
        )
        with pytest.raises(UpstreamServiceError) as exc:
            client.generate(model="fake-model", messages=[])
        assert "private synthetic" not in str(exc.value)


@pytest.mark.parametrize(
    "choices",
    [
        [],
        [SimpleNamespace(message=SimpleNamespace(content=None))],
        [SimpleNamespace(message=SimpleNamespace(content="  "))],
    ],
)
def test_provider_empty_choices_is_invalid_model_response(choices):
    with patch("app.infrastructure.llm.providers.groq_client.Groq") as client_type:
        client_type.return_value.chat.completions.create.return_value = SimpleNamespace(
            choices=choices
        )
        with pytest.raises(InvalidModelResponseError):
            GroqChatCompletionClient(api_key="fake").generate(model="fake", messages=[])


def test_blank_input_never_reaches_provider_ports():
    refiner, generator, translator = Mock(), Mock(), Mock()
    with pytest.raises(ValueError):
        RefineSituationUseCase(
            refiner=refiner, refinement_language=Language.KOREAN
        ).execute("  ")
    with pytest.raises(ValueError):
        GenerateAutomaticThoughtsUseCase(
            generator=generator, translator=translator
        ).execute(situation="  ")
    refiner.refine.assert_not_called()
    generator.generate.assert_not_called()
    translator.translate.assert_not_called()


def test_valid_translation_pipeline_keeps_context_and_validates_final_result():
    translator, generator = Mock(), Mock()
    translator.translate.side_effect = [
        "English context",
        '{"automatic_thoughts":[" thought ","thought"]}',
    ]
    generator.generate.return_value = ["English thought"]
    result = GenerateAutomaticThoughtsUseCase(
        generator=generator, translator=translator
    ).execute(
        situation="refined", original_situation="original", emotions=[" worried ", ""]
    )
    assert result == ["thought"]
    first_context = translator.translate.call_args_list[0].args[0]
    assert (
        "refined" in first_context
        and "original" in first_context
        and "worried" in first_context
    )
    generator.generate.assert_called_once_with("English context")
