# Mind Builder

Mind Builder is a Flutter app that guides the user through a CBT flow.

## Flow

1. Situation
2. Emotion
3. Automatic Thought
4. Cognitive Distortion
5. Intervention

Each step collects user input and passes the result into the next step.

## Situation LLM Flow

The situation step sends the user's raw sentence to a separate Python backend.
The backend asks OpenAI to rewrite it as a cleaner CBT-style situation statement.
That refined sentence is then used as the prompt for the emotion step.

## Backend setup

1. Create a virtual environment inside `backend/`.
2. Install dependencies from `backend/requirements.txt`.
3. Copy `backend/.env.example` to `backend/.env`.
4. Fill in `OPENAI_API_KEY`.
5. Run `uvicorn app.main:app --reload` from `backend/`.

## Flutter setup

- The app calls `POST /api/situation/refine` on the next button in the situation step.
- Desktop and iOS simulator default to `http://127.0.0.1:8000`.
- Android emulator defaults to `http://10.0.2.2:8000`.
- Override the backend URL with `--dart-define=BACKEND_BASE_URL=http://<host>:8000` when needed.

## Key paths

- `lib/flow/cbt_session.dart`
- `lib/features/situation.dart`
- `lib/services/situation_service.dart`
- `backend/app/main.py`
