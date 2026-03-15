import 'package:flutter/material.dart';

import 'conversation_widgets.dart';

const Map<String, List<String>> kEmotionOptions = <String, List<String>>{
  '슬픔': <String>['슬픔', '울적함', '우울', '침울', '불행'],
  '수치심': <String>['수치심', '창피함', '바보 같은 기분', '시선 의식'],
  '불안': <String>['불안', '걱정', '공포심', '과민함', '겁이 남'],
  '절망': <String>['절망', '낙담', '비관', '좌절감'],
  '죄책감': <String>['죄책감', '가책', '불쾌감', '부끄러움'],
  '답답함': <String>['답답함', '갑갑함', '낭패감', '패배감'],
  '열등감': <String>['열등감', '무가치감', '부적절감', '결핍감', '무능감'],
  '분노': <String>['분노', '몹시 화가 남', '분개', '언짢음', '짜증 남', '속상함', '격분'],
  '외로움': <String>['외로움', '사랑받지 못함', '환영받지 못함', '거절감', '고독감', '버림받음'],
  '기타 감정': <String>['기타 감정', '직접 입력'],
};

class EmotionDraft {
  const EmotionDraft({
    this.selectedMajors = const <String>[],
    this.selectedMinors = const <String, Set<String>>{},
    this.customEmotion = '',
  });

  final List<String> selectedMajors;
  final Map<String, Set<String>> selectedMinors;
  final String customEmotion;

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

    if (!nextMajors.contains('기타 감정')) {
      nextMinors.remove('기타 감정');
      return EmotionDraft(
        selectedMajors: nextMajors,
        selectedMinors: nextMinors,
        customEmotion: '',
      );
    }

    return EmotionDraft(
      selectedMajors: nextMajors,
      selectedMinors: nextMinors,
      customEmotion: customEmotion,
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
      customEmotion: customEmotion,
    );
  }

  EmotionDraft updateCustomEmotion(String text) {
    return EmotionDraft(
      selectedMajors: List<String>.from(selectedMajors),
      selectedMinors: <String, Set<String>>{
        for (final MapEntry<String, Set<String>> entry
            in selectedMinors.entries)
          entry.key: Set<String>.from(entry.value),
      },
      customEmotion: text,
    );
  }

  bool get isComplete {
    if (selectedMajors.isEmpty) {
      return false;
    }
    final bool hasSelectedMinors = selectedMajors.every(
      (String major) => (selectedMinors[major] ?? const <String>{}).isNotEmpty,
    );

    if (!hasSelectedMinors) {
      return false;
    }

    final bool needsCustomEmotion =
        selectedMinors['기타 감정']?.contains('직접 입력') ?? false;
    if (!needsCustomEmotion) {
      return true;
    }

    return customEmotion.trim().isNotEmpty;
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
            if (major == '기타 감정' &&
                (value.selectedMinors[major]?.contains('직접 입력') ??
                    false)) ...<Widget>[
              const SizedBox(height: 12),
              TextFormField(
                initialValue: value.customEmotion,
                onChanged: (String text) {
                  onChanged(value.updateCustomEmotion(text));
                },
                decoration: const InputDecoration(
                  labelText: '직접 입력한 감정',
                  hintText: '예: 서운함, 허탈함, 긴장됨',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
