# Mind Builder

Mind Builder는 CBT(Cognitive Behavioral Therapy)를 `기록 도구`처럼 푸는 앱이 아니라, 캐릭터와 대화하면서 함께 진행하는 Flutter 앱입니다. 사용자는 보노와 대화하듯 상황, 감정, 자동적 사고, 인지 왜곡을 따라가고, 필요한 치료 도구를 하나씩 수행합니다.

상황 입력과 자동적 사고 추천에는 Python 백엔드의 LLM을 사용하고, 치료 도구 단계는 캐릭터가 질문을 던지고 사용자가 답하는 대화형 흐름을 중심으로 설계합니다.

## 주요 흐름

1. 상황 입력
2. 감정 선택
3. 자동적 사고 정리
4. 인지 왜곡 확인
5. 왜곡에 맞는 치료 도구 실행

각 단계의 입력값은 다음 단계의 프롬프트, 치료 도구 추천, 요약 화면에 반영됩니다.

## 제품 원칙

- 핵심 UX는 `캐릭터와의 대화`다.
- 치료 도구는 워크시트보다 `대사 -> 답변 -> 다음 대사` 흐름을 우선한다.
- 마지막 단계는 자유 입력형 개입이 아니라, 왜곡에 맞는 치료 도구를 직렬로 수행하는 구조로 확장한다.

## 현재 구현 상태

- 상황 정리: LLM 기반
- 자동적 사고 추천: LLM 기반
- 인지 왜곡 선택: 사용자 선택 + 간단한 추천
- 치료 도구 엔진: 왜곡에 따라 도구를 불러오는 구조 추가
- 첫 구현 도구: `긍정적 재구성`

현재 `긍정적 재구성`은 보노가 한 번에 한 질문씩 던지고, 사용자가 답하면 다음 질문이나 다음 생각으로 넘어가는 대화형 플로우로 동작합니다.

## 현재 구성

- 프론트엔드: Flutter
- 백엔드: FastAPI
- LLM 연동: Groq API
- 핵심 API:
  - `POST /api/situation/refine`
  - `POST /api/automatic-thoughts/generate`

## 프로젝트 구조

```text
lib/
  main.dart
  app.dart
  flow/
    cbt_session.dart
  features/
    situation.dart
    emotion.dart
    automatic_thought.dart
    cognitive_distortion.dart
    therapy_tools.dart
    controlled_text_area.dart
    conversation_widgets.dart
  services/
    backend_config.dart
    situation_service.dart
    automatic_thought_service.dart

backend/
  app/
    api/
    application/
    domain/
    infrastructure/
    main.py
  requirements.txt
  .env.example
```

## 실행 방법

### 1. 백엔드 실행

`backend/` 폴더에서 가상환경을 만들고 FastAPI 서버를 실행합니다.

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

PowerShell 실행 정책 때문에 `Activate.ps1`이 막히면, 위처럼 가상환경의 Python을 직접 호출하면 됩니다.

### 2. 환경 변수 설정

`backend/.env.example`를 참고해서 `backend/.env`를 채우세요.

필수 값:

- `GROQ_API_KEY`

기본 예시는 [backend/.env.example](/c:/Users/jybdr/MindBuilder/backend/.env.example)에 있습니다.

### 3. Flutter 앱 실행

프로젝트 루트에서 실행합니다.

```powershell
flutter pub get
flutter run
```

## 백엔드 주소 규칙

- Windows, iOS 시뮬레이터, Web: `http://127.0.0.1:8000`
- Android 에뮬레이터: `http://10.0.2.2:8000`

필요하면 `--dart-define`로 덮어쓸 수 있습니다.

```powershell
flutter run --dart-define=BACKEND_BASE_URL=http://127.0.0.1:8000
```

## 확인 포인트

- 백엔드 헬스 체크: `GET http://127.0.0.1:8000/health`
- 정상 응답: `{"status":"ok"}`

## 주요 파일

- `lib/main.dart`: 앱 시작점
- `lib/app.dart`: MaterialApp 및 테마 설정
- `lib/flow/cbt_session.dart`: 전체 CBT 단계 진행과 상태 관리
- `lib/features/therapy_tools.dart`: 치료 도구 정의, 스케줄, 긍정적 재구성 UI
- `lib/services/situation_service.dart`: 상황 정제 API 호출
- `lib/services/automatic_thought_service.dart`: 자동적 사고 생성 API 호출
- `backend/app/main.py`: FastAPI 앱 진입점
- `backend/app/api/routes/situation.py`: 상황 정제 라우트
- `backend/app/api/routes/automatic_thought.py`: 자동적 사고 라우트

## 다음 작업

1. `docs/therapy-tools.md`를 기준으로 치료 도구를 하나씩 추가
2. 왜곡별 치료 도구 매핑 고도화
3. 치료 도구 단계의 대화 톤과 UX 정리
4. 시작 화면, 히스토리, 인사이트 등 상위 구조 확장
