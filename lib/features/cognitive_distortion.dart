import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

const List<String> kDistortionOptions = <String>[
  '전부 아니면 전무라는 생각',
  '지나친 일반화',
  '정신적 여과',
  '긍정적인 면 무시하기',
  '성급한 결론 짓기 - 독심술',
  '성급한 결론 짓기 - 예언자적 말하기',
  '극대화와 극소화',
  '감정적 추리',
  '해야 한다는 생각',
  '낙인찍기',
  '비난하기 - 자기 비난',
  '비난하기 - 타인 비난',
];

class CognitiveDistortionDraft {
  const CognitiveDistortionDraft({
    this.selectedDistortions = const <String>{},
    this.userReason = '',
  });

  final Set<String> selectedDistortions;
  final String userReason;

  CognitiveDistortionDraft copyWith({
    Set<String>? selectedDistortions,
    String? userReason,
  }) {
    return CognitiveDistortionDraft(
      selectedDistortions: selectedDistortions ?? this.selectedDistortions,
      userReason: userReason ?? this.userReason,
    );
  }

  CognitiveDistortionDraft toggle(String distortion) {
    final Set<String> next = Set<String>.from(selectedDistortions);
    if (next.contains(distortion)) {
      next.remove(distortion);
    } else {
      next.add(distortion);
    }
    return copyWith(selectedDistortions: next);
  }
}

class CognitiveDistortionStepView extends StatelessWidget {
  const CognitiveDistortionStepView({
    super.key,
    required this.thoughtPrompt,
    required this.selectedThoughts,
    required this.value,
    required this.onChanged,
  });

  final String thoughtPrompt;
  final List<String> selectedThoughts;
  final CognitiveDistortionDraft value;
  final ValueChanged<CognitiveDistortionDraft> onChanged;

  List<String> _suggestions() {
    final String lower = selectedThoughts.join(' ').toLowerCase();
    final List<String> suggestions = <String>[];

    if (lower.contains('항상') || lower.contains('계속') || lower.contains('원래')) {
      suggestions.add('지나친 일반화');
    }
    if (lower.contains('끝') || lower.contains('망') || lower.contains('더 나빠')) {
      suggestions.add('성급한 결론 짓기 - 예언자적 말하기');
      suggestions.add('극대화와 극소화');
    }
    if (lower.contains('분명') || lower.contains('무시') || lower.contains('별로')) {
      suggestions.add('성급한 결론 짓기 - 독심술');
      suggestions.add('긍정적인 면 무시하기');
    }
    if (lower.contains('내 책임') || lower.contains('내가 문제')) {
      suggestions.add('비난하기 - 자기 비난');
    }
    if (lower.contains('느꼈') || lower.contains('불안') || lower.contains('무서')) {
      suggestions.add('감정적 추리');
    }

    if (suggestions.isEmpty) {
      suggestions.addAll(
        <String>['지나친 일반화', '성급한 결론 짓기 - 독심술', '감정적 추리'],
      );
    }

    return suggestions.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = _suggestions();
    final String intro = thoughtPrompt.trim().isEmpty ? '' : '$thoughtPrompt\n';
    final String message = selectedThoughts.isEmpty
        ? '$intro이제 네 생각에 어떤 인지왜곡이 섞여 있는지 같이 볼게.'
        : '$intro네가 고른 생각들을 하나씩 보면서 어떤 인지왜곡이 가까운지 골라보자.';

    return ConversationStepLayout(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '인지왜곡 선택',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (selectedThoughts.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              '선택한 자동적 사고들',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...selectedThoughts.map(
              (String thought) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD8DDE8)),
                ),
                child: Text(thought),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kDistortionOptions.map((String distortion) {
              final bool selected = value.selectedDistortions.contains(
                distortion,
              );
              final bool suggested = suggestions.contains(distortion);
              return FilterChip(
                label: Text(suggested ? '$distortion 추천' : distortion),
                selected: selected,
                onSelected: (_) {
                  onChanged(value.toggle(distortion));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ControlledTextArea(
            value: value.userReason,
            minLines: 3,
            maxLines: 5,
            onChanged: (String text) {
              onChanged(value.copyWith(userReason: text));
            },
            labelText: '내가 느낀 이유',
            hintText: '왜 이 왜곡이 맞는지, 또는 아직 확신이 없는 이유를 적습니다.',
          ),
        ],
      ),
    );
  }
}
