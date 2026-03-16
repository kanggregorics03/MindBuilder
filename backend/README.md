# Backend

Mind Builder backend is a FastAPI service for two CBT-related LLM tasks:

- situation refinement
- automatic thought generation

## Structure

- `app/api`: HTTP routes
- `app/application`: use cases, ports, and application errors
- `app/domain`: shared domain types such as `Language`
- `app/infrastructure`: LLM providers, prompts, translation, and adapters
- `app/container.py`: runtime wiring for providers and use cases

## API

### `POST /api/situation/refine`

Request body:

```json
{
  "raw_situation": "친구가 오늘 내 말을 계속 피하는 것 같아."
}
```

Response body:

```json
{
  "original": "친구가 오늘 내 말을 계속 피하는 것 같아.",
  "feedback": "상황을 더 구체적인 행동 중심 문장으로 정리해 보세요.",
  "reframed": "친구가 평소보다 짧게 답하고 대화를 빨리 끝내려는 것처럼 느껴졌다."
}
```

Flow:

1. The route validates input and calls `RefineSituationUseCase`.
2. The use case refines the text in the configured `REFINEMENT_LANGUAGE`.
3. The route returns `original`, `feedback`, and `reframed`.

### `POST /api/automatic-thoughts/generate`

Request body:

```json
{
  "situation": "친구가 평소보다 짧게 답하고 대화를 빨리 끝내려는 것처럼 느껴졌다."
}
```

Response body:

```json
{
  "automatic_thoughts": [
    "내가 뭔가 잘못해서 나를 불편해하는 것 같다.",
    "친구가 나를 귀찮아하는 것 같다."
  ]
}
```

Flow:

1. The route validates input and calls `GenerateAutomaticThoughtsUseCase`.
2. The use case can translate internally as needed for the generator pipeline.
3. The generator returns multiple candidate automatic thoughts.

## Configuration

Required:

- `GROQ_API_KEY`

Task routing:

- `SITUATION_REFINEMENT_PROVIDER`
- `SITUATION_REFINEMENT_MODEL`
- `SITUATION_REFINEMENT_PROMPT_PROFILE`
- `AUTOMATIC_THOUGHT_GENERATION_PROVIDER`
- `AUTOMATIC_THOUGHT_GENERATION_MODEL`
- `AUTOMATIC_THOUGHT_GENERATION_PROMPT_PROFILE`
- `TRANSLATION_PROVIDER`
- `TRANSLATION_MODEL`
- `TRANSLATION_PROMPT_PROFILE`
- `REFINEMENT_LANGUAGE`
- `ALLOWED_ORIGINS`

Current defaults:

- situation refinement: `groq` + `openai/gpt-oss-20b`
- automatic thought generation: `groq` + `meta-llama/llama-4-scout-17b-16e-instruct`
- translation: `groq` + `openai/gpt-oss-20b`

Built-in prompt profiles are registered in `app/infrastructure/prompts/registry.py`.

- situation refinement: `default`, `gpt_oss_refine_v1`
- translation: `default`, `gpt_oss_translation_v1`
- automatic thought generation: `default`

## Run

1. Create a virtual environment in `backend/`.
2. Install dependencies from `requirements.txt`.
3. Copy `.env.example` to `.env`.
4. Fill in the API key and adjust model settings if needed.
5. Run `uvicorn app.main:app --reload` from `backend/`.

Example:

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

## Health Check

- `GET /health` returns `{ "status": "ok" }`
