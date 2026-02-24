List<String> recommendNegativeChips({List<String> tags = const <String>[]}) {
  final prioritized = <String>[];
  if (tags.contains('평가')) {
    prioritized.addAll(<String>['망칠 거야', '무능해 보일 거야']);
  }
  const defaults = <String>[
    '또 실수할 거야',
    '준비가 부족해',
    '상대가 실망할 거야',
    '기회가 없을 거야',
    '이미 늦었어',
    '내 탓이야',
    '결국 안 될 거야',
  ];
  return _prioritize(prioritized, defaults);
}

List<String> recommendBalancedChips({List<String> tags = const <String>[]}) {
  final prioritized = <String>[];
  if (tags.contains('평가')) {
    prioritized.addAll(<String>['증거는 충분하지 않아', '한 번의 실수로 전체가 결정되진 않아']);
  }
  const defaults = <String>[
    '지금 할 수 있는 걸 하자',
    '작게 나눠서 진행하자',
    '불안해도 시도할 수 있어',
    '완벽하지 않아도 괜찮아',
    '다른 해석도 가능해',
    '이번 경험도 데이터야',
    '도움을 요청할 수 있어',
  ];
  return _prioritize(prioritized, defaults);
}

List<String> _prioritize(List<String> prioritized, List<String> defaults) {
  final merged = <String>[];
  for (final item in <String>[...prioritized, ...defaults]) {
    if (!merged.contains(item)) {
      merged.add(item);
    }
    if (merged.length == 6) {
      break;
    }
  }
  return merged;
}
