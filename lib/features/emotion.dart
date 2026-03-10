import 'package:flutter/material.dart';

import 'conversation_widgets.dart';

const Map<String, List<String>> kEmotionOptions = <String, List<String>>{
  '불안': <String>['걱정', '긴장', '초조', '두려움'],
  '슬픔': <String>['허무함', '상실감', '무기력', '우울감'],
  '분노': <String>['짜증', '억울함', '답답함', '분개'],
  '수치심': <String>['창피함', '위축감', '자책', '민망함'],
  '외로움': <String>['소외감', '버려진 느낌', '고립감', '허전함'],
  '죄책감': <String>['미안함', '후회', '부담감', '자기비난'],
  '실망': <String>['낙담', '허탈함', '섭섭함', '좌절감'],
  '혼란': <String>['막막함', '헷갈림', '압도감', '방향 상실'],
};

class EmotionDraft {
  const EmotionDraft({
    this.selectedMajors = const <String>[],
    this.selectedMinors = const <String, Set<String>>{},
  });

  final List<String> selectedMajors;
  final Map<String, Set<String>> selectedMinors;

  EmotionDraft toggleMajor(String major) {
    final List<String> nextMajors = List<String>.from(selectedMajors);
    final Map<String, Set<String>> nextMinors = <String, Set<String>>{
      for (final MapEntry<String, Set<String>> entry in selectedMinors.entries)
        entry.key: Set<String>.from(entry.value),
    };

    if (nextMajors.contains(major)) {
      nextMajors.remove(major);
      nextMinors.remove(major);
    } else {
      nextMajors.add(major);
    }

    return EmotionDraft(
      selectedMajors: nextMajors,
      selectedMinors: nextMinors,
    );
  }

  EmotionDraft toggleMinor(String major, String minor) {
    final Map<String, Set<String>> nextMinors = <String, Set<String>>{
      for (final MapEntry<String, Set<String>> entry in selectedMinors.entries)
        entry.key: Set<String>.from(entry.value),
    };

    final Set<String> values = nextMinors.putIfAbsent(major, () => <String>{});
    if (values.contains(minor)) {
      values.remove(minor);
      if (values.isEmpty) {
        nextMinors.remove(major);
      }
    } else {
      values.add(minor);
    }

    return EmotionDraft(
      selectedMajors: List<String>.from(selectedMajors),
      selectedMinors: nextMinors,
    );
  }

  bool get isComplete {
    if (selectedMajors.isEmpty) {
      return false;
    }
    return selectedMajors.every(
      (String major) => (selectedMinors[major] ?? const <String>{}).isNotEmpty,
    );
  }
}

class EmotionStepView extends StatelessWidget {
  const EmotionStepView({
    super.key,
    required this.situationPrompt,
    required this.value,
    required this.onChanged,
  });

  final String situationPrompt;
  final EmotionDraft value;
  final ValueChanged<EmotionDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final String message = situationPrompt.trim().isEmpty
        ? '그때 마음에서 어떤 감정이 크게 올라왔어? 가장 가까운 감정을 골라줘.'
        : '$situationPrompt\n어떤 감정이 들었어? 가장 가까운 감정을 골라줘.';

    return ConversationStepLayout(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '대표 감정',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kEmotionOptions.keys.map((String major) {
              final bool selected = value.selectedMajors.contains(major);
              return FilterChip(
                label: Text(major),
                selected: selected,
                onSelected: (_) {
                  onChanged(value.toggleMajor(major));
                },
              );
            }).toList(),
          ),
          for (final String major in value.selectedMajors) ...<Widget>[
            const SizedBox(height: 20),
            Text(
              '$major 세부 감정',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (kEmotionOptions[major] ?? const <String>[]).map((
                String minor,
              ) {
                final bool selected =
                    value.selectedMinors[major]?.contains(minor) ?? false;
                return FilterChip(
                  label: Text(minor),
                  selected: selected,
                  onSelected: (_) {
                    onChanged(value.toggleMinor(major, minor));
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
