import 'negative_thought_index.dart';

const Map<String, List<String>> _negativeByTag = <String, List<String>>{
  '업무/학업': <String>['성과가 안 나오면 끝이야', '실수하면 신뢰를 잃을 거야'],
  '발표/면접': <String>['말문이 막히면 망해', '긴장한 모습이 들킬 거야'],
  '시험/평가': <String>['점수 낮으면 나는 무가치해', '한 번 실패하면 끝이야'],
  '과제/마감': <String>['기한을 못 맞추면 끝이야', '이미 늦어서 의미 없어'],
  '프로젝트지연': <String>['지연 책임이 전부 내 탓이야', '회복은 불가능해'],
  '승진/성과평가': <String>['이번 평가가 내 가치를 결정해', '낮게 나오면 끝이야'],
  '취업준비': <String>['합격 못 하면 미래가 없어', '나는 경쟁력이 부족해'],
  '진로/이직': <String>['지금 선택 틀리면 망해', '남들보다 늦었어'],
  '관계갈등': <String>['이번 일로 관계가 깨질 거야', '내가 다 망쳤어'],
  '갈등대화': <String>['대화하면 더 나빠질 거야', '내 말은 통하지 않아'],
  '연애': <String>['상대가 곧 실망할 거야', '버림받을 거야'],
  '이별/거리감': <String>['연결이 끊어졌으니 나는 혼자야', '회복 못 할 거야'],
  '가족': <String>['내가 더 잘했어야 했어', '이 분위기는 절대 안 바뀔 거야'],
  '부모관계': <String>['나는 결국 인정 못 받을 거야', '내가 틀렸다는 증거야'],
  '육아': <String>['이렇게 하면 좋은 부모가 아니야', '작은 실수도 치명적이야'],
  'SNS/비교': <String>['나만 뒤처졌어', '다들 나보다 잘 살아'],
  '외모/자기이미지': <String>['내 모습은 받아들여지지 않을 거야', '나는 매력이 없어'],
  '체중/식습관': <String>['한 번 무너지면 다 끝이야', '나는 절제력이 없어'],
  '건강/통증': <String>['이 증상은 큰일의 신호야', '나는 회복 못 할 거야'],
  '병원검사대기': <String>['결과가 분명 나쁠 거야', '견딜 수 없을 거야'],
  '수면/피로': <String>['잠을 못 잤으니 오늘은 망했어', '난 버틸 수 없어'],
  '재정/돈': <String>['돈이 부족해서 아무것도 못 해', '앞으로 계속 악화될 거야'],
  '빚/대출': <String>['빚이 있으니 인생이 끝났어', '절대 회복 못 해'],
  '경제불황불안': <String>['앞으로 더 나빠질 뿐이야', '지금 준비해도 소용없어'],
  '미루기': <String>['또 미뤘으니 나는 의지가 없어', '지금 시작해도 늦었어'],
  '집중저하': <String>['집중 못 하면 나는 무능해', '이 상태는 안 바뀔 거야'],
  '완벽주의': <String>['완벽하지 않으면 의미 없어', '작은 흠도 용납되면 안 돼'],
  '번아웃': <String>['쉬면 뒤처져', '지금 멈추면 다 무너져'],
  '거절/경계': <String>['거절하면 이기적으로 보일 거야', '싫다고 말하면 미움받아'],
  '경계침해': <String>['참아야 관계가 유지돼', '내 요구는 과한 거야'],
  '불확실성': <String>['모르면 위험해', '확실하지 않으면 시도하면 안 돼'],
  '손실/실패': <String>['손해를 봤으니 나는 실패자야', '이번 실패는 반복될 거야'],
  '의사결정': <String>['결정 하나로 모든 게 망가질 거야', '틀리면 돌이킬 수 없어'],
  '변화/적응': <String>['변화를 못 버틸 거야', '난 적응력이 없어'],
  '출퇴근/이동': <String>['오늘도 지치기만 할 거야', '통제할 방법이 없어'],
  '운전스트레스': <String>['작은 실수도 큰 사고로 이어질 거야', '나는 운전에 취약해'],
  '소음/환경': <String>['이 환경에선 아무것도 못 해', '내가 예민해서 문제야'],
  '층간소음': <String>['평생 이렇게 살아야 해', '말해도 절대 안 바뀌어'],
  '안전불안': <String>['항상 위험이 도사려', '한순간에 큰일 날 거야'],
  '공공장소불안': <String>['사람들이 날 이상하게 볼 거야', '패닉이 오면 끝이야'],
  '법적분쟁': <String>['무조건 내가 불리해', '시간과 돈만 잃게 될 거야'],
  '소비후회': <String>['또 실수했어, 나는 통제가 안 돼', '앞으로도 반복될 거야'],
  '경조사스트레스': <String>['내가 제대로 못 하면 욕먹어', '모든 걸 완벽히 해야 해'],
  '명절스트레스': <String>['이번에도 갈등이 터질 거야', '피할 방법이 없어'],
  '상실/애도': <String>['이 고통은 끝나지 않을 거야', '나는 회복 못 해'],
  '트라우마기억': <String>['또 같은 일이 반복될 거야', '나는 안전하지 않아'],
  '불안': <String>['불안하다는 건 잘못됐다는 증거야', '이 불안은 못 견뎌'],
  '우울감': <String>['아무 의미가 없어', '앞으로도 달라질 게 없어'],
  '외로움': <String>['나는 결국 혼자야', '아무도 나를 이해 못 해'],
  '자존감': <String>['나는 기본적으로 부족해', '잘해도 운이었을 뿐이야'],
  '자기비난': <String>['문제는 전부 내 탓이야', '나는 늘 틀려'],
  '목표상실': <String>['이제 아무것도 소용없어', '동기 없는 나는 실패자야'],
  '의미상실': <String>['사는 게 공허해, 바뀔 수 없어', '무엇을 해도 의미 없어'],
};

const List<String> _negativeDefaults = <String>[
  '또 실수할 거야',
  '준비가 부족해',
  '상대가 실망할 거야',
  '기회가 없을 거야',
  '이미 늦었어',
  '내 탓이야',
  '결국 안 될 거야',
];

const Map<String, List<String>> _balancedByTag = <String, List<String>>{
  '업무/학업': <String>['성과는 과정의 누적으로 만들어져', '한 번의 결과가 전체 능력을 뜻하진 않아'],
  '발표/면접': <String>['긴장은 준비했다는 신호일 수도 있어', '완벽보다 핵심 전달이 더 중요해'],
  '시험/평가': <String>['이번 결과는 현재 상태의 스냅샷이야', '보완 포인트를 찾는 자료로 쓸 수 있어'],
  '과제/마감': <String>['전체보다 다음 20분에 집중하자', '지금 시작하는 게 가장 빠른 회복이다'],
  '프로젝트지연': <String>['지연 원인과 복구 계획을 분리하자', '작은 복구 단위로 신뢰를 회복할 수 있어'],
  '승진/성과평가': <String>['평가는 내 전체 가치가 아니다', '피드백은 개선 데이터다'],
  '취업준비': <String>['준비는 누적되며 바로 사라지지 않는다', '한 번의 결과가 경로를 닫지는 않는다'],
  '진로/이직': <String>['정답보다 현재 정보에서의 최선이 중요해', '작은 실험으로 리스크를 줄일 수 있어'],
  '관계갈등': <String>['갈등은 조정의 시작일 수 있어', '한 번의 대화로 관계 전체가 결정되진 않아'],
  '갈등대화': <String>['사실-느낌-요청 순서로 말해보자', '반응을 통제할 수는 없지만 표현은 통제할 수 있다'],
  '연애': <String>['상대의 반응은 여러 요인의 결과야', '불안해도 필요한 말을 차분히 할 수 있어'],
  '이별/거리감': <String>['거리감이 곧 내 가치의 부정은 아니다', '회복은 파도처럼 진행될 수 있다'],
  '가족': <String>['내 몫과 상대 몫을 구분해 보자', '작은 변화부터 시도할 수 있어'],
  '부모관계': <String>['인정 욕구와 사실을 분리해 보자', '경계를 세우는 것은 무례가 아니다'],
  '육아': <String>['완벽한 부모보다 안정적인 부모가 중요하다', '실수 후 수리가 관계를 강화한다'],
  'SNS/비교': <String>['SNS는 편집된 장면이야', '내 기준과 속도에 맞추면 돼'],
  '외모/자기이미지': <String>['외모 평가는 상황과 기준에 따라 달라진다', '내 가치는 외모 한 축으로만 결정되지 않는다'],
  '체중/식습관': <String>['한 끼가 전체를 결정하지 않는다', '다음 선택을 조정하면 흐름을 바꿀 수 있다'],
  '건강/통증': <String>['느낌과 사실을 분리해서 보자', '필요하면 전문가 확인으로 불확실성을 줄일 수 있어'],
  '병원검사대기': <String>['결과 전 해석은 가설일 뿐이다', '지금 가능한 관리에 집중하자'],
  '수면/피로': <String>['피곤해도 핵심 1가지는 수행할 수 있다', '회복 루틴이 내일의 상태를 바꾼다'],
  '재정/돈': <String>['지금 할 수 있는 지출 통제부터 하자', '한 번에 해결보다 우선순위가 중요해'],
  '빚/대출': <String>['문제를 수치가 아닌 계획으로 보자', '상환 계획은 협의와 조정이 가능하다'],
  '경제불황불안': <String>['거시 변수와 내 행동 변수를 분리하자', '현금흐름 관리가 체감 불안을 낮춘다'],
  '미루기': <String>['5분만 시작하면 관성이 생길 수 있어', '늦었다는 생각보다 지금 시작이 이득이야'],
  '집중저하': <String>['주의는 훈련 가능한 자원이다', '환경 정리와 단일과업으로 회복할 수 있다'],
  '완벽주의': <String>['완료가 완벽보다 가치를 만든다', '70점 초안으로 시작해도 충분해'],
  '번아웃': <String>['휴식은 이탈이 아니라 유지 전략이다', '회복 없이는 성과도 지속되지 않는다'],
  '거절/경계': <String>['경계는 관계를 지키는 기술이야', '정중한 거절은 무례가 아니야'],
  '경계침해': <String>['불편함을 신호로 읽자', '짧고 명확한 경계 문장은 연습으로 좋아진다'],
  '불확실성': <String>['100% 확실성은 드물다', '정보를 모으고 작은 실험으로 확인할 수 있어'],
  '손실/실패': <String>['손실은 방향 조정을 위한 데이터야', '실패 경험은 다음 선택의 근거가 된다'],
  '의사결정': <String>['완벽한 결정은 드물다', '되돌릴 수 있는 선택부터 실행하자'],
  '변화/적응': <String>['적응은 단계적으로 일어난다', '작은 반복이 익숙함을 만든다'],
  '출퇴근/이동': <String>['통제 어려운 구간에 대처 루틴을 두자', '오디오/호흡 루틴으로 소진을 줄일 수 있다'],
  '운전스트레스': <String>['위험 대비는 과도한 공포와 다르다', '휴식과 거리두기가 판단을 지킨다'],
  '소음/환경': <String>['환경은 조정 가능한 요소가 있다', '통제 가능한 대안부터 적용하자'],
  '층간소음': <String>['감정과 요청을 분리해 전달하자', '기록과 절차가 갈등을 줄인다'],
  '안전불안': <String>['위험 확률과 가능성을 구분하자', '예방 계획이 공포를 줄인다'],
  '공공장소불안': <String>['불안 파도는 올라왔다가 내려간다', '짧은 노출부터 단계적으로 늘리자'],
  '법적분쟁': <String>['정보 확인이 해석보다 우선이다', '전문가 조언으로 불확실성을 낮출 수 있다'],
  '소비후회': <String>['실수는 소비 기준을 다듬는 데이터다', '환불/교환/보완 옵션을 먼저 확인하자'],
  '경조사스트레스': <String>['모든 기대를 충족할 필요는 없다', '핵심 예의와 내 한계를 함께 지키자'],
  '명절스트레스': <String>['역할과 시간을 사전에 조율하자', '짧은 휴식 구간을 미리 확보하자'],
  '상실/애도': <String>['애도는 속도가 아니라 과정이다', '기억과 일상을 함께 유지할 수 있다'],
  '트라우마기억': <String>['기억 활성화는 현재 위험의 증거가 아니다', '지금-여기 안전 신호를 확인하자'],
  '불안': <String>['불안해도 행동은 선택할 수 있어', '호흡을 고르고 한 단계만 진행하자'],
  '우울감': <String>['기분과 사실은 같지 않아', '아주 작은 행동도 상태를 바꾼다'],
  '외로움': <String>['연결은 작은 시도로 시작된다', '한 사람에게 짧게 연락해도 충분하다'],
  '자존감': <String>['자존감은 결과 하나로 결정되지 않는다', '내 강점 증거를 기록으로 남기자'],
  '자기비난': <String>['비난보다 수정이 변화를 만든다', '책임과 자책은 다르다'],
  '목표상실': <String>['목표는 재설계할 수 있다', '작은 방향성부터 다시 세우자'],
  '의미상실': <String>['의미는 발견보다 구축의 성격이 있다', '가치에 맞는 작은 행동이 감각을 회복시킨다'],
};

const List<String> _balancedDefaults = <String>[
  '지금 할 수 있는 걸 하자',
  '작게 나눠서 진행하자',
  '불안해도 시도할 수 있어',
  '완벽하지 않아도 괜찮아',
  '다른 해석도 가능해',
  '이번 경험도 데이터야',
  '도움을 요청할 수 있어',
  '사실과 해석을 분리해 보자',
  '한 번에 전부가 아니라 다음 1단계에 집중하자',
];

List<String> recommendNegativeChips({List<String> tags = const <String>[]}) {
  final prioritized = <String>[];
  for (final tag in tags) {
    prioritized.addAll(_negativeByTag[tag] ?? const <String>[]);
  }
  return _prioritize(prioritized, _negativeDefaults);
}

List<String> recommendBalancedChips({List<String> tags = const <String>[]}) {
  final prioritized = <String>[];
  for (final tag in tags) {
    prioritized.addAll(_balancedByTag[tag] ?? const <String>[]);
  }
  return _prioritize(prioritized, _balancedDefaults);
}

List<String> _prioritize(List<String> prioritized, List<String> defaults) {
  final merged = <String>[];
  for (final item in <String>[...prioritized, ...defaults]) {
    if (!merged.contains(item)) {
      merged.add(item);
    }
    if (merged.length == 8) {
      break;
    }
  }
  return merged;
}

class RoutingOption {
  const RoutingOption({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

class RoutingQuestion {
  const RoutingQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  final String id;
  final String question;
  final List<RoutingOption> options;
}

class BranchAnswerOutcome {
  const BranchAnswerOutcome({
    this.nextQuestionId,
    this.distortionId,
    this.restartToRoot = false,
  });

  final String? nextQuestionId;
  final String? distortionId;
  final bool restartToRoot;
}

class BranchRoutingResult {
  const BranchRoutingResult({
    required this.topDistortionId,
    required this.recommendations,
  });

  final String topDistortionId;
  final List<String> recommendations;
}

class NegativeRecommendationFlow {
  static const String rootQuestionId = 'Q0';

  static RoutingQuestion questionById(
    String questionId, {
    Set<String> excludedRootBranches = const <String>{},
  }) {
    if (questionId == rootQuestionId) {
      final List<RoutingOption> options = _questionMap[rootQuestionId]!.options
          .where((RoutingOption option) => !excludedRootBranches.contains(option.id))
          .toList();
      if (options.isEmpty) {
        return _questionMap[rootQuestionId]!;
      }
      return RoutingQuestion(
        id: rootQuestionId,
        question: _questionMap[rootQuestionId]!.question,
        options: options,
      );
    }
    return _questionMap[questionId] ?? _questionMap[rootQuestionId]!;
  }

  static bool isRootBranchOption(String optionId) => optionId.startsWith('B');

  static String? branchToQuestionId(String branchOptionId) =>
      _rootBranchToQuestionId[branchOptionId];

  static BranchAnswerOutcome answer({
    required String questionId,
    required String optionId,
  }) {
    final Map<String, BranchAnswerOutcome>? rule = _answerRules[questionId];
    if (rule == null) {
      return const BranchAnswerOutcome(restartToRoot: true);
    }
    return rule[optionId] ?? const BranchAnswerOutcome(restartToRoot: true);
  }

  static BranchRoutingResult buildResult({
    required String distortionId,
    required String? situationDetail,
    required String? situationMajor,
  }) {
    return BranchRoutingResult(
      topDistortionId: distortionId,
      recommendations: recommendByDistortion(
        distortionId: distortionId,
        situationDetail: situationDetail,
        situationMajor: situationMajor,
      ),
    );
  }

  static List<String> recommendByDistortion({
    required String distortionId,
    String? situationDetail,
    String? situationMajor,
  }) {
    final List<String> fromDetailDistortion =
        (situationDetail != null && situationDetail.isNotEmpty)
        ? (kNegativeThoughtByDetail[situationDetail]?[distortionId] ??
              const <String>[])
        : const <String>[];
    final List<String> fromMajorDistortion =
        (situationMajor != null && situationMajor.isNotEmpty)
        ? (kNegativeThoughtByMajor[situationMajor]?[distortionId] ??
              const <String>[])
        : const <String>[];
    final List<String> fromDistortion = _distortionSentences[distortionId] ?? const <String>[];
    const List<String> fallback = <String>[
      '한 군데만 틀리면 이번 평가는 끝이야.',
      '지금 시작해도 결국 늦을 거야.',
      '지금 저 반응이면 다들 내가 문제라고 생각하는 거야.',
      '이렇게 떨리는 걸 보면 내가 준비가 모자란 거야.',
    ];

    final List<String> merged = <String>[];
    for (final String sentence in <String>[
      ...fromDetailDistortion,
      ...fromMajorDistortion,
      ...fromDistortion,
      ...fallback,
    ]) {
      if (!merged.contains(sentence)) {
        merged.add(sentence);
      }
      if (merged.length == 5) {
        break;
      }
    }
    return merged;
  }
}

const Map<String, String> _rootBranchToQuestionId = <String, String>{
  'B1': 'Q1-1',
  'B2': 'Q2-1',
  'B3': 'Q3-1',
  'B4': 'Q4-1',
  'B5': 'Q5-1',
};

const Map<String, RoutingQuestion> _questionMap = <String, RoutingQuestion>{
  'Q0': RoutingQuestion(
    id: 'Q0',
    question: '지금 네 마음에서 제일 크게 걸리는 건 어떤 쪽이야?',
    options: <RoutingOption>[
      RoutingOption(id: 'B1', label: '상대가 나를 어떻게 볼지, 무슨 생각할지 너무 신경 쓰여'),
      RoutingOption(id: 'B2', label: '앞으로 안 좋은 일이 생길까 봐 걱정돼'),
      RoutingOption(id: 'B3', label: '나나 상대가 꼭 이래야 한다는 생각이 들어'),
      RoutingOption(id: 'B4', label: '이게 누구 잘못인지 자꾸 따지게 돼'),
      RoutingOption(id: 'B5', label: '있었던 일을 내가 너무 안 좋게 받아들이는 것 같아'),
    ],
  ),
  'Q1-1': RoutingQuestion(
    id: 'Q1-1',
    question: '혹시 상대가 직접 말한 건 아닌데, 그냥 분명 이렇게 생각할 거야 하고 느끼고 있어?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q1_1_Y', label: '응, 그냥 그렇게 생각할 것 같아'),
      RoutingOption(id: 'Q1_1_N', label: '아니, 그 정도는 아니야'),
    ],
  ),
  'Q1-2': RoutingQuestion(
    id: 'Q1-2',
    question: '그 일의 이유를 자꾸 너무 내 탓으로 돌리거나, 반대로 너무 상대 탓으로만 보고 있는 것 같아?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q1_2_ME', label: '다 내 잘못인 것 같아'),
      RoutingOption(id: 'Q1_2_OTHER', label: '다 상대 때문인 것 같아'),
      RoutingOption(id: 'Q1_2_NONE', label: '꼭 그렇게 한쪽만의 문제는 아닌 것 같아'),
    ],
  ),
  'Q2-1': RoutingQuestion(
    id: 'Q2-1',
    question: '아직 일어나지도 않았는데, 벌써부터 안 좋은 쪽으로 끝날 것 같다고 느껴져?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q2_1_Y', label: '응, 뭔가 안 좋게 될 것 같아'),
      RoutingOption(id: 'Q2_1_N', label: '아니, 그렇게까지 확신하는 건 아니야'),
    ],
  ),
  'Q3-1': RoutingQuestion(
    id: 'Q3-1',
    question: '지금 머릿속에 이건 꼭 이래야 해, 이러면 안 돼 같은 생각이 계속 맴돌아?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q3_1_Y', label: '응, 꼭 이래야 할 것 같아'),
      RoutingOption(id: 'Q3_1_N', label: '아니, 그런 건 아니야'),
    ],
  ),
  'Q4-1': RoutingQuestion(
    id: 'Q4-1',
    question: '이 일은 거의 한 사람 책임이라고 느껴져?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q4_1_ME', label: '거의 다 내 책임 같아'),
      RoutingOption(id: 'Q4_1_OTHER', label: '거의 다 상대 책임 같아'),
      RoutingOption(id: 'Q4_1_NONE', label: '아니, 한 사람만의 문제는 아닌 것 같아'),
    ],
  ),
  'Q5-1': RoutingQuestion(
    id: 'Q5-1',
    question: '하나 있었던 일 때문에, 전체가 다 그런 것처럼 느껴지고 있어?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q5_1_Y', label: '응, 하나만 봐도 다 그런 것처럼 느껴져'),
      RoutingOption(id: 'Q5_1_N', label: '아니, 그건 아니야'),
    ],
  ),
  'Q5-2': RoutingQuestion(
    id: 'Q5-2',
    question: '혹시 항상 이래, 난 원래 이래, 맨날 똑같아 같은 생각이 들어?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q5_2_Y', label: '응, 자꾸 그런 식으로 생각돼'),
      RoutingOption(id: 'Q5_2_N', label: '아니, 그렇게까지는 아니야'),
    ],
  ),
  'Q5-3': RoutingQuestion(
    id: 'Q5-3',
    question: '중간은 잘 안 보이고, 그냥 잘했냐 망했냐처럼 딱 둘 중 하나로 느껴져?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q5_3_Y', label: '응, 그냥 둘 중 하나처럼 느껴져'),
      RoutingOption(id: 'Q5_3_N', label: '아니, 꼭 그렇진 않아'),
    ],
  ),
  'Q5-4': RoutingQuestion(
    id: 'Q5-4',
    question: '좋았던 부분도 있었는데, 이상하게 안 좋았던 쪽만 계속 눈에 들어와?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q5_4_Y', label: '응, 안 좋은 쪽만 계속 보여'),
      RoutingOption(id: 'Q5_4_N', label: '아니, 그 정도는 아니야'),
    ],
  ),
  'Q5-5': RoutingQuestion(
    id: 'Q5-5',
    question: '누가 칭찬해주거나 괜찮은 일이 있어도, 별거 아니야 하고 넘기게 돼?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q5_5_Y', label: '응, 좋은 일도 별거 아닌 것처럼 넘기게 돼'),
      RoutingOption(id: 'Q5_5_N', label: '아니, 그건 아니야'),
    ],
  ),
  'Q5-6': RoutingQuestion(
    id: 'Q5-6',
    question: '실수한 건 엄청 크게 느껴지고, 반대로 잘한 건 되게 작게 느껴져?',
    options: <RoutingOption>[
      RoutingOption(
        id: 'Q5_6_Y',
        label: '응, 실수는 엄청 크게 느껴지고 잘한 건 별거 아닌 것 같아',
      ),
      RoutingOption(id: 'Q5_6_N', label: '아니, 꼭 그렇진 않아'),
    ],
  ),
  'Q5-7': RoutingQuestion(
    id: 'Q5-7',
    question: '혹시 지금 드는 불안하거나 우울한 느낌 때문에, 그 느낌이 곧 사실처럼 느껴져?',
    options: <RoutingOption>[
      RoutingOption(id: 'Q5_7_Y', label: '응, 내가 느끼는 게 그냥 사실처럼 느껴져'),
      RoutingOption(id: 'Q5_7_N', label: '아니, 그 정도는 아니야'),
    ],
  ),
};

const Map<String, Map<String, BranchAnswerOutcome>> _answerRules =
    <String, Map<String, BranchAnswerOutcome>>{
      'Q1-1': <String, BranchAnswerOutcome>{
        'Q1_1_Y': BranchAnswerOutcome(distortionId: 'G5'),
        'Q1_1_N': BranchAnswerOutcome(nextQuestionId: 'Q1-2'),
      },
      'Q1-2': <String, BranchAnswerOutcome>{
        'Q1_2_ME': BranchAnswerOutcome(distortionId: 'G10'),
        'Q1_2_OTHER': BranchAnswerOutcome(distortionId: 'G10'),
        'Q1_2_NONE': BranchAnswerOutcome(restartToRoot: true),
      },
      'Q2-1': <String, BranchAnswerOutcome>{
        'Q2_1_Y': BranchAnswerOutcome(distortionId: 'G6'),
        'Q2_1_N': BranchAnswerOutcome(restartToRoot: true),
      },
      'Q3-1': <String, BranchAnswerOutcome>{
        'Q3_1_Y': BranchAnswerOutcome(distortionId: 'G9'),
        'Q3_1_N': BranchAnswerOutcome(restartToRoot: true),
      },
      'Q4-1': <String, BranchAnswerOutcome>{
        'Q4_1_ME': BranchAnswerOutcome(distortionId: 'G10'),
        'Q4_1_OTHER': BranchAnswerOutcome(distortionId: 'G10'),
        'Q4_1_NONE': BranchAnswerOutcome(restartToRoot: true),
      },
      'Q5-1': <String, BranchAnswerOutcome>{
        'Q5_1_Y': BranchAnswerOutcome(nextQuestionId: 'Q5-2'),
        'Q5_1_N': BranchAnswerOutcome(nextQuestionId: 'Q5-4'),
      },
      'Q5-2': <String, BranchAnswerOutcome>{
        'Q5_2_Y': BranchAnswerOutcome(distortionId: 'G2'),
        'Q5_2_N': BranchAnswerOutcome(nextQuestionId: 'Q5-3'),
      },
      'Q5-3': <String, BranchAnswerOutcome>{
        'Q5_3_Y': BranchAnswerOutcome(distortionId: 'G1'),
        'Q5_3_N': BranchAnswerOutcome(nextQuestionId: 'Q5-4'),
      },
      'Q5-4': <String, BranchAnswerOutcome>{
        'Q5_4_Y': BranchAnswerOutcome(distortionId: 'G3'),
        'Q5_4_N': BranchAnswerOutcome(nextQuestionId: 'Q5-5'),
      },
      'Q5-5': <String, BranchAnswerOutcome>{
        'Q5_5_Y': BranchAnswerOutcome(distortionId: 'G4'),
        'Q5_5_N': BranchAnswerOutcome(nextQuestionId: 'Q5-6'),
      },
      'Q5-6': <String, BranchAnswerOutcome>{
        'Q5_6_Y': BranchAnswerOutcome(distortionId: 'G7'),
        'Q5_6_N': BranchAnswerOutcome(nextQuestionId: 'Q5-7'),
      },
      'Q5-7': <String, BranchAnswerOutcome>{
        'Q5_7_Y': BranchAnswerOutcome(distortionId: 'G8'),
        'Q5_7_N': BranchAnswerOutcome(restartToRoot: true),
      },
    };

const Map<String, List<String>> _distortionSentences = <String, List<String>>{
  'G1': <String>[
    '한 군데만 틀리면 이번 평가는 끝이야.',
    '최고 아니면 의미 없어.',
    '완벽하게 준비했어야 했는데 난 또 부족해.',
  ],
  'G2': <String>[
    '지난번에 버벅였으니 이번에도 똑같을 거야.',
    '예전에 한 번 지적받았잖아, 또 그럴 거야.',
    '한 번 망하면 늘 망한다.',
  ],
  'G3': <String>[
    '방금 말 꼬인 것만 다들 기억할 거야.',
    '잘한 부분은 아무도 안 보고 틀린 것만 볼 거야.',
    '이 한 번의 지연이 전부를 덮을 거야.',
  ],
  'G4': <String>[
    '칭찬은 그냥 예의로 한 말이야.',
    '결과가 좋게 나와도 운이 좋았던 거지.',
    '잘한 건 별거 아니고 다음에 바로 들통날 거야.',
  ],
  'G5': <String>[
    '면접관 표정 보니까 이미 마음 정한 것 같아.',
    '저 반응이면 내 답이 별로였다는 뜻이야.',
    '지금 조용한 거 보니 다들 별로라고 생각하는 거야.',
    '방금 그 눈빛은 왜 저렇게 말하지였어.',
  ],
  'G6': <String>[
    '오늘 평가는 분명 낮게 나올 거야.',
    '이번엔 분명 마감 못 맞출 거야.',
    '결과는 이미 나쁘게 정해져 있어.',
  ],
  'G7': <String>[
    '사소한 말실수도 엄청 크게 보일 거야.',
    '한 시간만 늦어도 치명적이야.',
    '작은 지연도 치명적으로 커질 거야.',
  ],
  'G8': <String>[
    '이렇게 떨리는 걸 보면 내가 준비가 모자란 거야.',
    '마음이 불편하니까 결과도 안 좋을 거야.',
    '불안이 올라오는 걸 보면 위험한 상황이야.',
  ],
  'G9': <String>[
    '답은 바로바로 나와야 해, 고민하면 끝이야.',
    '마감은 어떤 일이 있어도 지켜야 해.',
    '쉬면 안 돼, 끝날 때까지 해야 해.',
  ],
  'G10': <String>[
    '분위기가 어색해진 건 내가 말을 잘못해서야.',
    '팀 결과가 안 나오면 내가 발목 잡은 거지.',
    '성과가 흔들리면 결국 내 책임으로 돌아올 거야.',
  ],
};
