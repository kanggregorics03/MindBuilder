from openai import OpenAI

from .config import get_settings


SYSTEM_PROMPT = """You are a CBT writing assistant.

Rewrite the user's input as a concise CBT situation statement in Korean.
Requirements:
- Focus on observable context, timing, place, people, and what happened.
- Do not include interpretation, prediction, blame, or advice.
- Preserve the user's core facts.
- Return exactly one polished sentence in Korean.
"""


def refine_situation(raw_situation: str) -> str:
    settings = get_settings()
    client = OpenAI(api_key=settings.openai_api_key)

    response = client.responses.create(
        model=settings.openai_model,
        instructions=SYSTEM_PROMPT,
        input=f"사용자 입력: {raw_situation}",
    )

    refined = (response.output_text or "").strip()
    if not refined:
        raise ValueError("OpenAI returned an empty refinement.")
    return refined
