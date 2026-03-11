from openai import OpenAI

from .config import get_settings


SYSTEM_PROMPT = """You are a CBT writing assistant.

Rewrite the user's input as a concise CBT situation statement in Korean.

Requirements:
- Use only information explicitly provided by the user.
- Do not add time, place, people, causes, or other details unless the user mentioned them.
- Rewrite exaggerated or evaluative wording into a more neutral, observable situation when possible.
- Prefer concrete events, actions, and immediately noticeable outcomes over conclusions or judgments.
- If the user's input is already specific, keep the facts and only polish the wording.
- Do not include interpretation, prediction, blame, reassurance, or advice.
- Preserve the user's core facts.
- Return exactly one polished sentence in Korean.

Examples:
- Input: "발표가 다 망했어"
  Output: "발표를 했고, 준비한 내용을 충분히 전달하지 못했다고 느꼈다."
- Input: "친구가 나를 무시했어"
  Output: "친구와 대화하는 중 내가 한 말에 반응이 없어서 무시당했다고 느꼈다."
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
