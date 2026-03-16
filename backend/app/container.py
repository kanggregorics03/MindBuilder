from functools import lru_cache

from .application.use_cases.generate_automatic_thoughts import (
    GenerateAutomaticThoughtsUseCase,
)
from .application.use_cases.refine_situation import RefineSituationUseCase
from .config import get_settings
from .infrastructure.automatic_thought.llm_automatic_thought_generator import (
    LLMAutomaticThoughtGenerator,
)
from .infrastructure.llm.providers.groq_client import GroqChatCompletionClient
from .infrastructure.llm.registry import (
    AUTOMATIC_THOUGHT_GENERATION_TASK,
    SITUATION_REFINEMENT_TASK,
    TRANSLATION_TASK,
    ModelTarget,
    TaskLLMRouter,
)
from .infrastructure.prompts import create_default_prompt_registry
from .infrastructure.refinement.llm_situation_refiner import LLMSituationRefiner
from .infrastructure.translation.llm_translator import LLMTranslator


@lru_cache
def get_task_llm_router() -> TaskLLMRouter:
    settings = get_settings()

    providers = {
        "groq": GroqChatCompletionClient(api_key=settings.groq_api_key),
    }
    task_models = {
        SITUATION_REFINEMENT_TASK: ModelTarget(
            provider=settings.situation_refinement_provider,
            model=settings.situation_refinement_model,
            prompt_profile=settings.situation_refinement_prompt_profile,
        ),
        AUTOMATIC_THOUGHT_GENERATION_TASK: ModelTarget(
            provider=settings.automatic_thought_generation_provider,
            model=settings.automatic_thought_generation_model,
            prompt_profile=settings.automatic_thought_generation_prompt_profile,
        ),
        TRANSLATION_TASK: ModelTarget(
            provider=settings.translation_provider,
            model=settings.translation_model,
            prompt_profile=settings.translation_prompt_profile,
        ),
    }

    return TaskLLMRouter(providers=providers, task_models=task_models)


@lru_cache
def get_refine_situation_use_case() -> RefineSituationUseCase:
    settings = get_settings()
    router = get_task_llm_router()
    prompt_registry = create_default_prompt_registry()

    return RefineSituationUseCase(
        refiner=LLMSituationRefiner(router, prompt_registry),
        refinement_language=settings.refinement_language,
    )


@lru_cache
def get_generate_automatic_thoughts_use_case() -> GenerateAutomaticThoughtsUseCase:
    router = get_task_llm_router()
    prompt_registry = create_default_prompt_registry()

    return GenerateAutomaticThoughtsUseCase(
        generator=LLMAutomaticThoughtGenerator(router, prompt_registry),
        translator=LLMTranslator(router, prompt_registry),
    )
