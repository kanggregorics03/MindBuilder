import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

const List<String> kAutomaticThoughtStarterOptions = <String>[
  '내가 부족하다고 느꼈어',
  '상대가 나를 안 좋게 본다고 느꼈어',
  '앞으로 더 나빠질 것 같았어',
  '내가 뭔가 망쳤다고 느꼈어',
  '아무 의미가 없다고 느꼈어',
];

class AutomaticThoughtDraft {
  const AutomaticThoughtDraft({
    this.starterChoice = '',
    this.userNotes = '',
    this.selectedThought = '',
  });

  final String starterChoice;
  final String userNotes;
  final String selectedThought;

  AutomaticThoughtDraft copyWith({
    String? starterChoice,
    String? userNotes,
    String? selectedThought,
  }) {
    return AutomaticThoughtDraft(
      starterChoice: starterChoice ?? this.starterChoice,
      userNotes: userNotes ?? this.userNotes,
      selectedThought: selectedThought ?? this.selectedThought,
    );
  }
}

class AutomaticThoughtStepView extends StatelessWidget {
  const AutomaticThoughtStepView({
    super.key,
    required this.emotionPrompt,
    required this.value,
    required this.onChanged,
  });

  final String emotionPrompt;
  final AutomaticThoughtDraft value;
  final ValueChanged<AutomaticThoughtDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final String intro = emotionPrompt.trim().isEmpty
        ? ''
        : '$emotionPrompt\n';
    final String message =
        '${intro}그때 머릿속에 바로 떠오른 생각이 뭐였는지 같이 찾아보자. 먼저 가까운 느낌을 하나 고르고, 필요하면 직접 적어줘.';

    return ConversationStepLayout(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '1차 선택',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kAutomaticThoughtStarterOptions.map((String option) {
              final bool selected = value.starterChoice == option;
              return ChoiceChip(
                label: Text(option),
                selected: selected,
                onSelected: (_) {
                  onChanged(
                    value.copyWith(
                      starterChoice: option,
                      selectedThought: '',
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ControlledTextArea(
            value: value.userNotes,
            minLines: 2,
            maxLines: 4,
            onChanged: (String text) {
              onChanged(value.copyWith(userNotes: text));
            },
            labelText: '추가 메모',
            hintText: '떠오른 생각을 조금 더 적어주세요.',
          ),
          const SizedBox(height: 12),
          ControlledTextArea(
            value: value.selectedThought,
            minLines: 3,
            maxLines: 5,
            onChanged: (String text) {
              onChanged(value.copyWith(selectedThought: text));
            },
            labelText: '가장 가까운 자동적 사고',
            hintText: 'LLM 미구현으로 인해 비워둠. 지금은 직접 적어주세요.',
          ),
        ],
      ),
    );
  }
}
