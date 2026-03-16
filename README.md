# Mind Builder

Mind Builder는 CBT(Cognitive Behavioral Therapy) 흐름을 따라 생각을 정리할 수 있게 돕는 Flutter 앱입니다. 상황을 입력하면 Python 백엔드가 LLM을 통해 문장을 다듬고, 그 결과를 바탕으로 감정과 자동적 사고를 이어서 탐색할 수 있습니다.

## 주요 흐름

1. 상황 입력
2. 감정 선택
3. 자동적 사고 정리
4. 인지 왜곡 확인
5. 개입 문장과 행동 계획 작성

각 단계의 입력값은 다음 단계의 프롬프트와 요약 화면에 반영됩니다.

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
    intervention.dart
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
- `lib/services/situation_service.dart`: 상황 정제 API 호출
- `lib/services/automatic_thought_service.dart`: 자동적 사고 생성 API 호출
- `backend/app/main.py`: FastAPI 앱 진입점
- `backend/app/api/routes/situation.py`: 상황 정제 라우트
- `backend/app/api/routes/automatic_thought.py`: 자동적 사고 라우트

## 할 것

1. 프롬프트 고도화
- 번역체 개선, 왜곡 태그 같이 요청하기

2. 치료 도구 표를 토대로 구조 잡아오기

3. 각 치료 도구 제작

4. ui 개선
- 캐릭터 자체 교체
- 캐릭터 이름 고심하기
- 캐릭터 여러 개 쓰는 구조 교체

5. 더 큰 틀, 시작, 히스토리, 인사이트 만들기
- 인사이트 페이지에서 개인화된 핵심 믿음 제시

6. 치료 자체 고도화
- 데이터 수집
- LLM 부분 교체 방안

7. 감정 도수 추가
- 치료 전, 후로 구분