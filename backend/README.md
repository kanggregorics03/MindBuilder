# Backend

Mind Builder backend is a FastAPI service for two CBT-related LLM tasks:

- situation refinement
- automatic thought generation

## Structure

- `app/api`: HTTP routes only
- `app/application`: use cases, ports, and application errors
- `app/domain`: shared domain values such as `Language`
- `app/infrastructure`: LLM providers, prompts, translation, and task adapters
- `app/container.py`: runtime wiring for providers, prompts, and use cases

## API

### `POST /api/situation/refine`

Request body:

```json
{
  "raw_situation": "친구가 나를 싫어하는 것 같아"
}
```

Response body:

```json
{
  "original": "친구가 나를 싫어하는 것 같아",
  "feedback": "상대의 행동이나 장면을 더 구체적으로 적어보면 좋아요.",
  "reframed": "친구가 평소보다 짧게 답해서 내가 거절당한 것처럼 느꼈다."
}
```

Flow:

1. Route validates input and calls `RefineSituationUseCase`.
2. The use case refines the text in the configured `REFINEMENT_LANGUAGE`.
3. The route returns `original`, `feedback`, and `reframed`.

### `POST /api/automatic-thoughts/generate`

Request body:

```json
{
  "situation": "친구가 평소보다 짧게 답해서 내가 거절당한 것처럼 느꼈다."
}
```

Response body:

```json
{
  "automatic_thoughts": [
    "친구가 나를 싫어하게 된 것 같아.",
    "내가 뭔가 잘못해서 어색해진 것 같아."
  ]
}
```

Flow:

1. Route validates input and calls `GenerateAutomaticThoughtsUseCase`.
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

1. Create and activate a virtual environment in `backend/`.
2. Install dependencies from `requirements.txt`.
3. Copy `.env.example` to `.env`.
4. Fill in the API key and adjust model settings if needed.
5. Run `uvicorn app.main:app --reload` from `backend/`.

## Health check

- `GET /health` returns `{ "status": "ok" }`
