import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

const List<String> kDistortionOptions = <String>[
  '흑백논리',
  '과잉일반화',
  '정신적 여과',
  '긍정 축소',
  '독심술',
  '재앙화',
  '당위 진술',
  '개인화',
  '감정적 추론',
  '낙인찍기',
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
    required this.selectedThought,
    required this.value,
    required this.onChanged,
  });

  final String thoughtPrompt;
  final String selectedThought;
  final CognitiveDistortionDraft value;
  final ValueChanged<CognitiveDistortionDraft> onChanged;

  List<String> _suggestions() {
    final String lower = selectedThought.toLowerCase();
    final List<String> suggestions = <String>[];

    if (lower.contains('항상') || lower.contains('계속') || lower.contains('원래')) {
      suggestions.add('과잉일반화');
    }
    if (lower.contains('끝') || lower.contains('망') || lower.contains('더 나빠')) {
      suggestions.add('재앙화');
    }
    if (lower.contains('분명') || lower.contains('무시') || lower.contains('별로')) {
      suggestions.add('독심술');
    }
    if (lower.contains('내 책임') || lower.contains('내가 문제')) {
      suggestions.add('개인화');
    }
    if (lower.contains('느꼈') || lower.contains('불안') || lower.contains('무서')) {
      suggestions.add('감정적 추론');
    }

    if (suggestions.isEmpty) {
      suggestions.addAll(
        <String>['과잉일반화', '독심술', '감정적 추론'],
      );
    }

    return suggestions.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = _suggestions();
    final String intro = thoughtPrompt.trim().isEmpty ? '' : '$thoughtPrompt\n';
    final String message = selectedThought.trim().isEmpty
        ? '${intro}이제 네 생각에 어떤 인지왜곡이 섞여 있는지 같이 볼게.'
        : '${intro}네가 고른 생각은 "$selectedThought" 였어. 어떤 인지왜곡이 가까운지 골라보자.';

    return ConversationStepLayout(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '인지왜곡 선택',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kDistortionOptions.map((String distortion) {
              final bool selected = value.selectedDistortions.contains(distortion);
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
