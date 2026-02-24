class TemplateOption {
  const TemplateOption({required this.id, required this.label});

  final String id;
  final String label;
}

class DistortionOption {
  const DistortionOption({required this.id, required this.label});

  final String id;
  final String label;
}

const int maxSituationTagSelections = 5;

const List<String> situationTagOptions = <String>[
  '업무/학업',
  '발표/면접',
  '시험/평가',
  '과제/마감',
  '프로젝트지연',
  '승진/성과평가',
  '취업준비',
  '진로/이직',
  '실수/후회',
  '손실/실패',
  '성과압박',
  '시간관리',
  '미루기',
  '집중저하',
  '완벽주의',
  '휴식죄책감',
  '번아웃',
  '관계갈등',
  '갈등대화',
  '연애',
  '이별/거리감',
  '가족',
  '부모관계',
  '형제자매',
  '육아',
  '친구/모임',
  '약속취소',
  '고객응대',
  '팀프로젝트',
  '경계침해',
  '거절/경계',
  '따돌림/왕따기억',
  '차별경험',
  'SNS/비교',
  '뉴스과몰입',
  '정치/사회갈등',
  '외모/자기이미지',
  '체중/식습관',
  '운동습관',
  '건강/통증',
  '만성질환불안',
  '병원검사대기',
  '수면/피로',
  '생리/호르몬변화',
  '임신/출산불안',
  '중독행동',
  '음주/흡연',
  '디지털과사용',
  '재정/돈',
  '지출통제',
  '소비후회',
  '빚/대출',
  '경제불황불안',
  '이사/주거',
  '출퇴근/이동',
  '운전스트레스',
  '여행계획불안',
  '소음/환경',
  '층간소음',
  '집안일',
  '정리정돈',
  '공공장소불안',
  '안전불안',
  '사건사고목격',
  '의사결정',
  '불확실성',
  '변화/적응',
  '기대불일치',
  '서비스불만',
  '법적분쟁',
  '경조사스트레스',
  '명절스트레스',
  '상실/애도',
  '반려동물건강',
  '트라우마기억',
  '죄책감',
  '수치심',
  '분노',
  '불안',
  '우울감',
  '외로움',
  '자존감',
  '자기비난',
  '목표상실',
  '의미상실',
];

const Map<String, List<String>> situationTagGroups = <String, List<String>>{
  '일/학업': <String>[
    '업무/학업',
    '발표/면접',
    '시험/평가',
    '과제/마감',
    '프로젝트지연',
    '승진/성과평가',
    '취업준비',
    '진로/이직',
    '성과압박',
    '시간관리',
    '미루기',
    '집중저하',
    '완벽주의',
    '휴식죄책감',
    '번아웃',
  ],
  '관계': <String>[
    '관계갈등',
    '갈등대화',
    '연애',
    '이별/거리감',
    '가족',
    '부모관계',
    '형제자매',
    '육아',
    '친구/모임',
    '약속취소',
    '고객응대',
    '팀프로젝트',
    '경계침해',
    '거절/경계',
    '따돌림/왕따기억',
    '차별경험',
  ],
  '신체/건강': <String>[
    '외모/자기이미지',
    '체중/식습관',
    '운동습관',
    '건강/통증',
    '만성질환불안',
    '병원검사대기',
    '수면/피로',
    '생리/호르몬변화',
    '임신/출산불안',
    '중독행동',
    '음주/흡연',
    '디지털과사용',
  ],
  '재정/생활': <String>[
    '재정/돈',
    '지출통제',
    '소비후회',
    '빚/대출',
    '경제불황불안',
    '이사/주거',
    '출퇴근/이동',
    '운전스트레스',
    '여행계획불안',
    '소음/환경',
    '층간소음',
    '집안일',
    '정리정돈',
  ],
  '환경/사회': <String>[
    'SNS/비교',
    '뉴스과몰입',
    '정치/사회갈등',
    '공공장소불안',
    '안전불안',
    '사건사고목격',
    '기대불일치',
    '서비스불만',
    '법적분쟁',
    '경조사스트레스',
    '명절스트레스',
    '상실/애도',
    '반려동물건강',
    '트라우마기억',
  ],
  '정서/내면': <String>[
    '실수/후회',
    '손실/실패',
    '의사결정',
    '불확실성',
    '변화/적응',
    '죄책감',
    '수치심',
    '분노',
    '불안',
    '우울감',
    '외로움',
    '자존감',
    '자기비난',
    '목표상실',
    '의미상실',
  ],
};

const List<TemplateOption> negativeTemplateOptions = <TemplateOption>[
  TemplateOption(id: 'FREE_TEXT', label: '자유 작성'),
  TemplateOption(id: 'SELF_LABEL', label: '자기 낙인'),
  TemplateOption(id: 'CATASTROPHIZING', label: '최악 시나리오'),
  TemplateOption(id: 'MIND_READING', label: '타인 생각 단정'),
  TemplateOption(id: 'FORTUNE_TELLING', label: '미래 예측'),
  TemplateOption(id: 'SHOULD_STATEMENT', label: '당위 압박'),
  TemplateOption(id: 'COMPARISON_TRAP', label: '비교 함정'),
  TemplateOption(id: 'ALL_OR_NOTHING', label: '흑백 사고'),
  TemplateOption(id: 'OVERGENERALIZATION', label: '과잉 일반화'),
  TemplateOption(id: 'PERSONALIZATION', label: '개인화'),
  TemplateOption(id: 'PERFECTIONISM', label: '완벽주의'),
  TemplateOption(id: 'REJECTION_FEAR', label: '거절 공포'),
  TemplateOption(id: 'FAILURE_CERTAINTY', label: '실패 확신'),
  TemplateOption(id: 'CONTROL_IMPOSSIBLE', label: '통제 불가 단정'),
  TemplateOption(id: 'GUILT_BURDEN', label: '과도한 죄책감'),
  TemplateOption(id: 'SHAME_CORE', label: '수치심 중심 사고'),
  TemplateOption(id: 'ABANDONMENT_FEAR', label: '버려짐 공포'),
  TemplateOption(id: 'BETRAYAL_EXPECTATION', label: '배신 기대'),
  TemplateOption(id: 'UNFAIRNESS_FIXATION', label: '불공정 집착'),
  TemplateOption(id: 'LOW_WORTH', label: '무가치 단정'),
  TemplateOption(id: 'RESOURCE_SCARCITY', label: '자원 부족 불안'),
  TemplateOption(id: 'TIME_SCARCITY', label: '시간 부족 공포'),
  TemplateOption(id: 'PHYSICAL_ANXIETY', label: '신체 불안 확대'),
  TemplateOption(id: 'HEALTH_DOOM', label: '건강 파국화'),
  TemplateOption(id: 'SOCIAL_EXPOSURE', label: '사회적 노출 두려움'),
  TemplateOption(id: 'MISTAKE_INTOLERANCE', label: '실수 불관용'),
  TemplateOption(id: 'UNCERTAINTY_INTOLERANCE', label: '불확실성 불관용'),
  TemplateOption(id: 'EMOTION_IS_FACT', label: '감정=사실'),
  TemplateOption(id: 'PAST_REPEAT_CERTAINTY', label: '과거 반복 확신'),
  TemplateOption(id: 'LATE_THEREFORE_FAIL', label: '늦었으니 실패'),
  TemplateOption(id: 'OTHERS_ALWAYS_BETTER', label: '타인은 항상 더 낫다'),
  TemplateOption(id: 'IF_NOT_PERFECT_USELESS', label: '완벽 아니면 무의미'),
  TemplateOption(id: 'ONE_MISTAKE_TOTAL_FAILURE', label: '한 번 실수=전체 실패'),
];

const List<TemplateOption> balancedTemplateOptions = <TemplateOption>[
  TemplateOption(id: 'FREE_TEXT', label: '자유 작성'),
  TemplateOption(id: 'EVIDENCE_REVIEW', label: '증거 재검토'),
  TemplateOption(id: 'ALTERNATIVE_VIEW', label: '대안 해석'),
  TemplateOption(id: 'PROBABILITY_REFRAME', label: '가능성 재평가'),
  TemplateOption(id: 'PARTIAL_SUCCESS', label: '부분 성공 보기'),
  TemplateOption(id: 'SELF_COMPASSION', label: '자기 자비'),
  TemplateOption(id: 'SMALL_STEP', label: '작은 단계'),
  TemplateOption(id: 'NEXT_ACTION', label: '다음 행동'),
  TemplateOption(id: 'TIME_DISTANCE', label: '시간 거리두기'),
  TemplateOption(id: 'FRIEND_ADVICE', label: '친구에게 하듯'),
  TemplateOption(id: 'BOUNDARY_OPTION', label: '경계 설정'),
  TemplateOption(id: 'HELP_REQUEST', label: '도움 요청'),
  TemplateOption(id: 'PLAN_B', label: '대안 계획'),
  TemplateOption(id: 'VALUE_BASED', label: '가치 기반 선택'),
  TemplateOption(id: 'LEARNING_FRAME', label: '학습 관점'),
  TemplateOption(id: 'BODY_CALMING', label: '몸 진정'),
  TemplateOption(id: 'REALISTIC_STANDARD', label: '현실적 기준'),
  TemplateOption(id: 'RESPONSIBILITY_SPLIT', label: '책임 분리'),
  TemplateOption(id: 'SLOW_THINKING', label: '속도 늦추기'),
  TemplateOption(id: 'TRIGGER_AWARENESS', label: '촉발요인 인식'),
  TemplateOption(id: 'DISTORTION_NAME_IT', label: '왜곡 이름 붙이기'),
  TemplateOption(id: 'WHAT_IS_IN_CONTROL', label: '통제 가능 영역'),
  TemplateOption(id: 'FACT_FEELING_SEPARATE', label: '사실/감정 분리'),
  TemplateOption(id: 'GOOD_ENOUGH', label: '충분히 괜찮음'),
  TemplateOption(id: 'PROGRESS_OVER_PERFECT', label: '완벽보다 진전'),
  TemplateOption(id: 'DELAY_REACTION', label: '반응 유예'),
  TemplateOption(id: 'ASSERTIVE_SCRIPT', label: '단호한 대화 스크립트'),
  TemplateOption(id: 'SELF_CARE_MINIMUM', label: '최소 자기돌봄'),
  TemplateOption(id: 'RISK_MITIGATION', label: '리스크 완충'),
  TemplateOption(id: 'DATA_NOT_IDENTITY', label: '결과는 데이터'),
  TemplateOption(id: 'RECOVERY_PLAN', label: '회복 계획'),
  TemplateOption(id: 'RECONNECT_ONE_PERSON', label: '한 사람과 재연결'),
  TemplateOption(id: 'VALUES_FIRST_STEP', label: '가치 기반 첫걸음'),
];

const List<DistortionOption> distortionOptions = <DistortionOption>[
  DistortionOption(id: 'ALL_OR_NOTHING', label: '흑백논리'),
  DistortionOption(id: 'OVERGENERALIZATION', label: '과잉일반화'),
  DistortionOption(id: 'MENTAL_FILTER', label: '정신적 여과'),
  DistortionOption(id: 'DISCOUNT_POSITIVE', label: '긍정축소'),
  DistortionOption(id: 'MIND_READING', label: '독심술'),
  DistortionOption(id: 'FORTUNE_TELLING', label: '파국예측'),
  DistortionOption(id: 'MAGNIFICATION_MINIMIZATION', label: '확대/축소'),
  DistortionOption(id: 'EMOTIONAL_REASONING', label: '감정적 추론'),
  DistortionOption(id: 'SHOULD_STATEMENTS', label: '당위 진술'),
  DistortionOption(id: 'LABELING', label: '낙인찍기'),
  DistortionOption(id: 'PERSONALIZATION', label: '개인화'),
  DistortionOption(id: 'BLAMING', label: '비난'),
  DistortionOption(id: 'UNFAIR_COMPARISON', label: '불공정 비교'),
  DistortionOption(id: 'CONTROL_FALLACY', label: '통제 오류'),
  DistortionOption(id: 'CATASTROPHIZING', label: '파국화'),
  DistortionOption(id: 'TUNNEL_VISION', label: '터널 시야'),
  DistortionOption(id: 'ABSOLUTE_CERTAINTY', label: '절대 확신'),
  DistortionOption(id: 'INTOLERANCE_UNCERTAINTY', label: '불확실성 불내성'),
  DistortionOption(id: 'EMOTIONAL_PROOF', label: '감정 증거화'),
  DistortionOption(id: 'DOUBLE_STANDARD', label: '이중 잣대'),
  DistortionOption(id: 'FAIRNESS_FALLACY', label: '공정성 오류'),
  DistortionOption(id: 'HEAVEN_REWARD_FALLACY', label: '보상 오류'),
];

final Map<String, String> _negativeTemplateLabelMap = <String, String>{
  for (final option in negativeTemplateOptions) option.id: option.label,
};

final Map<String, String> _balancedTemplateLabelMap = <String, String>{
  for (final option in balancedTemplateOptions) option.id: option.label,
};

final Map<String, String> _distortionLabelMap = <String, String>{
  for (final option in distortionOptions) option.id: option.label,
};

const Map<String, String> _legacyTemplateLabelMap = <String, String>{
  'I_AM_LABEL': '자기 낙인',
  'BAD_OUTCOME': '최악 시나리오',
  'THEY_JUDGE': '타인 생각 단정',
  'EVIDENCE': '증거 부족 단정',
  'MUST': '당위 압박',
  'COMPARE': '비교 함정',
  'ALT': '대안 해석',
  'EVID': '증거 재검토',
  'ACTION': '다음 행동',
};

const Map<String, String> _legacyDistortionLabelMap = <String, String>{
  'all_or_nothing': '흑백논리',
  'overgeneralization': '과잉일반화',
  'mental_filter': '정신적 여과',
  'discounting_positive': '긍정축소',
  'mind_reading': '독심술',
  'fortune_telling': '파국예측',
  'magnification': '확대/축소',
  'emotional_reasoning': '감정적 추론',
  'should_statements': '당위 진술',
  'labeling': '낙인찍기',
  'personalization': '개인화',
  'blaming': '비난',
};

String negativeTemplateLabel(String templateId) {
  final id = templateId.trim();
  if (id.isEmpty) {
    return '자유 작성';
  }
  return _negativeTemplateLabelMap[id] ?? _legacyTemplateLabelMap[id] ?? id;
}

String balancedTemplateLabel(String templateId) {
  final id = templateId.trim();
  if (id.isEmpty) {
    return '자유 작성';
  }
  return _balancedTemplateLabelMap[id] ?? _legacyTemplateLabelMap[id] ?? id;
}

String distortionLabel(String distortionId) {
  final id = distortionId.trim();
  if (id.isEmpty) {
    return id;
  }
  return _distortionLabelMap[id] ?? _legacyDistortionLabelMap[id] ?? id;
}

const Map<String, String> _negativeTemplateGuideMap = <String, String>{
  'SELF_LABEL': '나는 [상황]에서 [한 실수]를 했고, 그래서 나는 [부정적 낙인]이라고 느낀다.',
  'CATASTROPHIZING': '이 일이 잘못되면 [최악의 결과]까지 갈 것 같아 불안하다.',
  'MIND_READING': '[상대/사람들]은 분명 나를 [부정적 평가]한다고 느낀다.',
  'FORTUNE_TELLING': '앞으로 [미래 상황]은 결국 [나쁜 결과]가 될 것 같다.',
  'SHOULD_STATEMENT': '나는 반드시 [기준]을 해야 하고, 못하면 안 된다.',
  'COMPARISON_TRAP': '다른 사람과 비교하면 나는 [부족한 점]에서 뒤처진다.',
  'ALL_OR_NOTHING': '[기준]을 완벽히 못하면 전부 실패라고 느낀다.',
  'OVERGENERALIZATION': '[한 사건]을 근거로, 나는 항상 [부정 결론]일 거라 본다.',
  'PERSONALIZATION': '[문제 상황]의 원인은 대부분 내 탓이라고 느낀다.',
  'PERFECTIONISM': '완벽하지 않으면 인정받을 수 없고 의미 없다고 느낀다.',
};

const Map<String, String> _balancedTemplateGuideMap = <String, String>{
  'EVIDENCE_REVIEW': '[부정 생각]을 지지하는 근거와 반대 근거를 나눠보면 [균형 결론]에 가깝다.',
  'ALTERNATIVE_VIEW': '같은 상황을 다른 관점에서 보면 [대안 해석]도 가능하다.',
  'PROBABILITY_REFRAME': '[걱정 결과]가 일어날 가능성은 생각보다 [낮음/중간]일 수 있다.',
  'PARTIAL_SUCCESS': '모든 게 나쁘진 않았고, [작은 성과/유지한 점]도 있었다.',
  'SELF_COMPASSION': '힘든 상황의 나에게 [친구에게 하듯 말]을 해줄 수 있다.',
  'SMALL_STEP': '지금은 [5~15분 내 가능한 행동]부터 하면 된다.',
  'NEXT_ACTION': '다음 행동은 [구체적 1단계]이고, 그 후에 [2단계]를 본다.',
  'BOUNDARY_OPTION': '[상대/상황]에 대해 [짧고 명확한 경계 문장]을 말할 수 있다.',
  'HELP_REQUEST': '이 문제에서 [도움받을 사람/자원]에게 [구체적 요청]을 하겠다.',
  'REALISTIC_STANDARD': '완벽 기준 대신 [현실적 기준]으로 조정해도 충분하다.',
};

String negativeTemplateGuide(String templateId) {
  final id = templateId.trim();
  if (id.isEmpty || id == 'FREE_TEXT') {
    return '';
  }
  return _negativeTemplateGuideMap[id] ??
      '상황: [무슨 일이 있었는지]\n자동사고: [즉시 떠오른 생각]\n근거: [왜 그렇게 느꼈는지]';
}

String balancedTemplateGuide(String templateId) {
  final id = templateId.trim();
  if (id.isEmpty || id == 'FREE_TEXT') {
    return '';
  }
  return _balancedTemplateGuideMap[id] ??
      '대안 생각: [더 균형 잡힌 해석]\n근거: [그렇게 볼 수 있는 이유]\n실행: [지금 할 1단계]';
}
