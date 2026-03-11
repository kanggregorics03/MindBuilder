# Mind Builder

`Mind Builder`는 캐릭터와 문답하는 형식으로 CBT 흐름을 따라가는 Flutter 앱이다.

## 핵심 흐름

앱은 아래 순서로 진행된다.

1. 상황
2. 감정
3. 자동적 사고
4. 인지왜곡
5. 개입

각 단계에서 보노가 먼저 말을 걸고, 사용자가 입력하거나 선택지로 답한다.
다음 단계로 넘어가면 보노가 이전 단계 내용을 이어받아 다음 질문을 던지는 구조를 목표로 한다.

## 현재 상태

- 구조는 CBT 단계 기준으로 얕게 나뉘어 있다.
- UI는 캐릭터 중심 문답형으로 구성되어 있다.
- LLM이 들어갈 자리는 아직 구현하지 않았다.
- 미구현된 LLM 출력은 `llm 생성 상황문장` 같은 placeholder 문구나 직접 입력 칸으로 임시 대응하고 있다.

## 디렉터리 구조

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
```

## 파일 역할

- `lib/main.dart`: 앱 시작점
- `lib/app.dart`: 앱 루트와 테마 설정
- `lib/flow/cbt_session.dart`: 전체 단계 흐름과 상태 관리
- `lib/features/situation.dart`: 상황 입력 단계
- `lib/features/emotion.dart`: 감정 선택 단계
- `lib/features/automatic_thought.dart`: 자동적 사고 단계
- `lib/features/cognitive_distortion.dart`: 인지왜곡 단계
- `lib/features/intervention.dart`: 개입 단계
- `lib/features/controlled_text_area.dart`: 공용 텍스트 입력 위젯
- `lib/features/conversation_widgets.dart`: 캐릭터 말풍선과 입력 패널 같은 공용 대화 UI

## 구조 원칙

- 복잡한 계층 대신 얕은 구조를 유지한다.
- `flow/`는 전체 진행을 관리한다.
- `features/`는 단계별 UI와 입력을 담당한다.
- 특정 모듈이 커지면 그 모듈만 별도 폴더로 승격한다.
