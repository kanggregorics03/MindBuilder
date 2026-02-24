# Mind Builder API Contract

이 문서는 현재 프로젝트의 "내부 API 계약"을 정리합니다.  
외부 HTTP API가 아니라, Flutter 앱 내부에서 UI와 데이터 계층이 맞춰 써야 하는 인터페이스입니다.

## 1. Repository API

파일: `lib/features/entry/data/entry_repository.dart`

### `Stream<List<Entry>> watchRecentEntries({int limit = 20})`
- 용도: 최근 기록 목록을 실시간 구독
- 기본값: `limit = 20`
- 정렬: `createdAt DESC`, `id DESC`
- 반환: Drift의 `Entry` 리스트 스트림

### `Future<Entry?> getEntry(int id)`
- 용도: 단건 상세 조회
- 입력: `id` (PK)
- 반환: 해당 레코드가 없으면 `null`

### `Future<int> insertEntry(EntryDraft draft)`
- 용도: 새 기록 저장
- 입력: `EntryDraft`
- 반환: 생성된 row id (`int`)
- 예외:
  - `draft.hasMinimumRequirements == false` 이면 `ArgumentError`
- 내부 정규화:
  - `negativeTemplateId`, `balancedTemplateId`: 공백이면 `FREE_TEXT`
  - `negativeConfidence`: 0~100으로 clamp
  - `emotionBefore`, `emotionAfter`: 0~10으로 clamp
  - `negativeFrequency`: 허용값(`항상`, `자주`, `가끔`) 아니면 `null`

### `Future<void> deleteEntry(int id)`
- 용도: 단건 삭제
- 입력: `id` (PK)

## 2. Domain Model API

파일: `lib/features/entry/domain/entry_draft.dart`

## `EntryDraft`
- 생성자 필수 필드:
  - `situationTags`
  - `negativeTemplateId`
  - `negativeText`
  - `distortions`
  - `balancedTemplateId`
  - `balancedText`
- 유효성:
  - `hasMinimumRequirements == true` 조건
  - `situationTags.isNotEmpty`
  - `negativeText.trim().isNotEmpty`
  - `balancedText.trim().isNotEmpty`

파일: `lib/features/entry/domain/wizard_draft.dart`

## `WizardDraft`
- UI 단계 입력용 mutable draft
- 변환 메서드:
  - `EntryDraft toEntryDraft()`
- 변환 시 정리:
  - 공백 텍스트 trim
  - 템플릿 id 공백이면 `FREE_TEXT`
  - 리스트는 `unmodifiable`로 변환

## 3. UI Route Contract

파일:
- `lib/features/entry/ui/home_screen.dart`
- `lib/features/entry/ui/builder_wizard_screen.dart`
- `lib/features/entry/ui/detail_screen.dart`
- `lib/app.dart`

### Route names
- `/` -> `HomeScreen`
- `/wizard` -> `BuilderWizardScreen`
- `/detail` -> `DetailScreen`

### Route arguments
- `/detail`:
  - `arguments`는 `int entryId` 이어야 함
  - 타입 불일치 시 `_RouteErrorScreen` 노출

## 4. Recommendation API

파일: `lib/features/recommend/recommend.dart`

### `List<String> recommendNegativeChips({List<String> tags = const <String>[]})`
- 용도: 부정적 생각 추천 칩 제공
- 규칙: 태그 기반 우선 문구 + 기본 문구 merge 후 최대 6개

### `List<String> recommendBalancedChips({List<String> tags = const <String>[]})`
- 용도: 균형 생각 추천 칩 제공
- 규칙: 태그 기반 우선 문구 + 기본 문구 merge 후 최대 6개

## 5. JSON Utility API

파일: `lib/core/utils/json_utils.dart`

### `List<String> decodeJsonStringList(String rawValue)`
- 용도: DB 문자열(JSON) -> `List<String>`
- 실패 시: 빈 리스트 반환

### `String encodeJsonStringList(List<String> values)`
- 용도: `List<String>` -> JSON 문자열

## 6. DB Schema Contract

파일: `lib/features/entry/data/app_database.dart`

테이블: `entries`
- `id` (PK, auto increment)
- `createdAt`
- `situationTagsJson`
- `situationNote` (nullable)
- `negativeTemplateId`
- `negativeText`
- `negativeConfidence` (nullable)
- `negativeFrequency` (nullable)
- `distortionsJson`
- `balancedTemplateId`
- `balancedText`
- `emotionBefore` (nullable)
- `emotionAfter` (nullable)

## 7. Notes

- 이 프로젝트는 현재 외부 REST API를 사용하지 않습니다.
- Web(Chrome) 타겟에서는 `dart:ffi` 기반 DB 접근이 동작하지 않습니다.
