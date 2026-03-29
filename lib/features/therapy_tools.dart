import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

enum TherapyToolStatus { pending, completed }

enum PositiveReframingStage { intro, benefitQuestion, valueQuestion, done }

class TherapyToolDefinition {
  const TherapyToolDefinition({
    required this.id,
    required this.title,
    required this.supportedDistortions,
  });

  final String id;
  final String title;
  final Set<String> supportedDistortions;
}

class TherapyToolScheduleItem {
  const TherapyToolScheduleItem({
    required this.toolId,
    required this.toolTitle,
    required this.triggeringDistortions,
    this.status = TherapyToolStatus.pending,
  });

  final String toolId;
  final String toolTitle;
  final Set<String> triggeringDistortions;
  final TherapyToolStatus status;

  TherapyToolScheduleItem copyWith({
    String? toolId,
    String? toolTitle,
    Set<String>? triggeringDistortions,
    TherapyToolStatus? status,
  }) {
    return TherapyToolScheduleItem(
      toolId: toolId ?? this.toolId,
      toolTitle: toolTitle ?? this.toolTitle,
      triggeringDistortions: triggeringDistortions ?? this.triggeringDistortions,
      status: status ?? this.status,
    );
  }
}

class PositiveReframingEntry {
  const PositiveReframingEntry({
    required this.thought,
    this.benefitAnswer = '',
    this.valueAnswer = '',
    this.isSaved = false,
  });

  final String thought;
  final String benefitAnswer;
  final String valueAnswer;
  final bool isSaved;

  bool get canSave =>
      benefitAnswer.trim().isNotEmpty && valueAnswer.trim().isNotEmpty;

  PositiveReframingEntry copyWith({
    String? thought,
    String? benefitAnswer,
    String? valueAnswer,
    bool? isSaved,
  }) {
    return PositiveReframingEntry(
      thought: thought ?? this.thought,
      benefitAnswer: benefitAnswer ?? this.benefitAnswer,
      valueAnswer: valueAnswer ?? this.valueAnswer,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class TherapyToolDraft {
  const TherapyToolDraft({
    this.sourceSignature = '',
    this.schedule = const <TherapyToolScheduleItem>[],
    this.positiveReframingEntries = const <PositiveReframingEntry>[],
    this.positiveReframingStage = PositiveReframingStage.intro,
  });

  final String sourceSignature;
  final List<TherapyToolScheduleItem> schedule;
  final List<PositiveReframingEntry> positiveReframingEntries;
  final PositiveReframingStage positiveReframingStage;

  bool get hasSchedule => schedule.isNotEmpty;

  bool get isComplete =>
      schedule.isNotEmpty &&
      schedule.every(
        (TherapyToolScheduleItem item) => item.status == TherapyToolStatus.completed,
      );

  int get currentPositiveReframingIndex {
    final int index = positiveReframingEntries.indexWhere(
      (PositiveReframingEntry entry) => !entry.isSaved,
    );
    return index == -1 ? positiveReframingEntries.length - 1 : index;
  }

  TherapyToolDraft copyWith({
    String? sourceSignature,
    List<TherapyToolScheduleItem>? schedule,
    List<PositiveReframingEntry>? positiveReframingEntries,
    PositiveReframingStage? positiveReframingStage,
  }) {
    return TherapyToolDraft(
      sourceSignature: sourceSignature ?? this.sourceSignature,
      schedule: schedule ?? this.schedule,
      positiveReframingEntries:
          positiveReframingEntries ?? this.positiveReframingEntries,
      positiveReframingStage:
          positiveReframingStage ?? this.positiveReframingStage,
    );
  }

  TherapyToolDraft nextPositiveReframingStage() {
    switch (positiveReframingStage) {
      case PositiveReframingStage.intro:
        return copyWith(
          positiveReframingStage: PositiveReframingStage.benefitQuestion,
        );
      case PositiveReframingStage.benefitQuestion:
        if (positiveReframingEntries.isEmpty) {
          return this;
        }
        final PositiveReframingEntry current =
            positiveReframingEntries[currentPositiveReframingIndex];
        if (current.benefitAnswer.trim().isEmpty) {
          return this;
        }
        return copyWith(
          positiveReframingStage: PositiveReframingStage.valueQuestion,
        );
      case PositiveReframingStage.valueQuestion:
      case PositiveReframingStage.done:
        return this;
    }
  }

  TherapyToolDraft updatePositiveReframingBenefit(String text) {
    if (positiveReframingEntries.isEmpty) {
      return this;
    }

    final int index = currentPositiveReframingIndex;
    final List<PositiveReframingEntry> next =
        List<PositiveReframingEntry>.from(positiveReframingEntries);
    next[index] = next[index].copyWith(benefitAnswer: text, isSaved: false);
    return copyWith(positiveReframingEntries: next);
  }

  TherapyToolDraft updatePositiveReframingValue(String text) {
    if (positiveReframingEntries.isEmpty) {
      return this;
    }

    final int index = currentPositiveReframingIndex;
    final List<PositiveReframingEntry> next =
        List<PositiveReframingEntry>.from(positiveReframingEntries);
    next[index] = next[index].copyWith(valueAnswer: text, isSaved: false);
    return copyWith(positiveReframingEntries: next);
  }

  TherapyToolDraft saveCurrentPositiveReframingEntry() {
    if (positiveReframingEntries.isEmpty) {
      return this;
    }

    final int index = currentPositiveReframingIndex;
    final PositiveReframingEntry current = positiveReframingEntries[index];
    if (!current.canSave) {
      return this;
    }

    final List<PositiveReframingEntry> nextEntries =
        List<PositiveReframingEntry>.from(positiveReframingEntries);
    nextEntries[index] = current.copyWith(isSaved: true);

    final bool allCompleted = nextEntries.every(
      (PositiveReframingEntry entry) => entry.isSaved,
    );
    final List<TherapyToolScheduleItem> nextSchedule = schedule.isEmpty
        ? schedule
        : <TherapyToolScheduleItem>[
            schedule.first.copyWith(
              status: allCompleted
                  ? TherapyToolStatus.completed
                  : TherapyToolStatus.pending,
            ),
            ...schedule.skip(1),
          ];

    return copyWith(
      schedule: nextSchedule,
      positiveReframingEntries: nextEntries,
      positiveReframingStage: allCompleted
          ? PositiveReframingStage.done
          : PositiveReframingStage.intro,
    );
  }
}

const String kPositiveReframingToolId = 'positive_reframing';

const TherapyToolDefinition kPositiveReframingTool = TherapyToolDefinition(
  id: kPositiveReframingToolId,
  title: '긍정적 재구성',
  supportedDistortions: <String>{
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
  },
);

const List<TherapyToolDefinition> kTherapyToolDefinitions =
    <TherapyToolDefinition>[kPositiveReframingTool];

TherapyToolDraft buildTherapyToolDraft({
  required Set<String> selectedDistortions,
  required List<String> selectedThoughts,
}) {
  final List<String> normalizedThoughts = selectedThoughts
      .map((String thought) => thought.trim())
      .where((String thought) => thought.isNotEmpty)
      .toList();
  final List<String> sortedDistortions = selectedDistortions.toList()..sort();
  final String sourceSignature =
      '${sortedDistortions.join('|')}::${normalizedThoughts.join('|')}';

  final List<TherapyToolScheduleItem> schedule = kTherapyToolDefinitions
      .where(
        (TherapyToolDefinition tool) => tool.supportedDistortions.any(
          selectedDistortions.contains,
        ),
      )
      .map(
        (TherapyToolDefinition tool) => TherapyToolScheduleItem(
          toolId: tool.id,
          toolTitle: tool.title,
          triggeringDistortions: selectedDistortions.intersection(
            tool.supportedDistortions,
          ),
        ),
      )
      .toList();

  final List<PositiveReframingEntry> entries = normalizedThoughts
      .map((String thought) => PositiveReframingEntry(thought: thought))
      .toList();

  return TherapyToolDraft(
    sourceSignature: sourceSignature,
    schedule: schedule,
    positiveReframingEntries: entries,
    positiveReframingStage: entries.isEmpty
        ? PositiveReframingStage.done
        : PositiveReframingStage.intro,
  );
}

class TherapyToolsStepView extends StatelessWidget {
  const TherapyToolsStepView({
    super.key,
    required this.selectedDistortions,
    required this.selectedThoughts,
    required this.value,
    required this.onChanged,
  });

  final Set<String> selectedDistortions;
  final List<String> selectedThoughts;
  final TherapyToolDraft value;
  final ValueChanged<TherapyToolDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final String message = _message();

    if (!value.hasSchedule) {
      return ConversationStepLayout(
        message: message,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '선택한 왜곡',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              selectedDistortions.isEmpty
                  ? '아직 선택한 왜곡이 없어요.'
                  : selectedDistortions.join(', '),
            ),
          ],
        ),
      );
    }

    return ConversationStepLayout(
      message: message,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (value.positiveReframingStage == PositiveReframingStage.intro)
            _TherapyToolsIntroPanel(
              selectedDistortions: selectedDistortions,
              schedule: value.schedule,
            )
          else if (value.schedule.first.toolId == kPositiveReframingToolId)
            PositiveReframingToolView(
              stage: value.positiveReframingStage,
              entries: value.positiveReframingEntries,
              onBenefitChanged: (String text) {
                onChanged(value.updatePositiveReframingBenefit(text));
              },
              onValueChanged: (String text) {
                onChanged(value.updatePositiveReframingValue(text));
              },
            ),
        ],
      ),
    );
  }

  String _message() {
    if (!value.hasSchedule) {
      return '지금 고른 왜곡에 연결된 치료도구는 아직 준비되지 않았어.';
    }

    final TherapyToolScheduleItem currentTool = value.schedule.first;
    final int activeIndex = value.currentPositiveReframingIndex;
    final int totalThoughts = value.positiveReframingEntries.length;
    final String thought = totalThoughts == 0
        ? ''
        : value.positiveReframingEntries[activeIndex].thought;

    switch (value.positiveReframingStage) {
      case PositiveReframingStage.intro:
        final String distortions = selectedDistortions.join(', ');
        return '좋아. 지금 네 생각에서는 $distortions 왜곡이 보여. 이 왜곡들에 맞는 치료 도구를 골라왔어. 먼저 ${currentTool.toolTitle}부터 같이 해보자.';
      case PositiveReframingStage.benefitQuestion:
        return totalThoughts == 0
            ? '긍정적 재구성을 시작해보자.'
            : '"$thought"라는 생각을 했구나.\n\n이 생각이나 감정이 너에게 도움이 되는 점이 있다면, 뭐라고 느껴져?';
      case PositiveReframingStage.valueQuestion:
        return totalThoughts == 0
            ? '다음 질문으로 가보자.'
            : '"$thought"라는 생각을 했구나.\n\n이 생각이나 감정 안에서, 너와 네 가치관의 좋은 점을 찾는다면 뭐가 떠올라?';
      case PositiveReframingStage.done:
        return '좋아. 긍정적 재구성을 여기까지 잘 해냈어. 이제 정리한 내용을 같이 확인해보자.';
    }
  }
}

class PositiveReframingToolView extends StatelessWidget {
  const PositiveReframingToolView({
    super.key,
    required this.stage,
    required this.entries,
    required this.onBenefitChanged,
    required this.onValueChanged,
  });

  final PositiveReframingStage stage;
  final List<PositiveReframingEntry> entries;
  final ValueChanged<String> onBenefitChanged;
  final ValueChanged<String> onValueChanged;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text(
        '먼저 자동적 사고를 하나 이상 선택하면 긍정적 재구성을 시작할 수 있어.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final int activeIndex = _currentIndex();
    final PositiveReframingEntry activeEntry = entries[activeIndex];
    final bool allCompleted = entries.every(
      (PositiveReframingEntry entry) => entry.isSaved,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (allCompleted)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4FBF6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB9DEC2)),
            ),
            child: const Text(
              '긍정적 재구성을 모두 적었어. 아래의 다음 버튼으로 요약으로 넘어가자.',
            ),
          )
        else ...<Widget>[
          ..._buildStageContent(context, activeEntry, activeIndex),
        ],
      ],
    );
  }

  List<Widget> _buildStageContent(
    BuildContext context,
    PositiveReframingEntry activeEntry,
    int activeIndex,
  ) {
    switch (stage) {
      case PositiveReframingStage.intro:
        return const <Widget>[];
      case PositiveReframingStage.benefitQuestion:
        return <Widget>[
          Text(
            '생각 ${activeIndex + 1} / ${entries.length}',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ControlledTextArea(
            value: activeEntry.benefitAnswer,
            onChanged: onBenefitChanged,
            labelText: '보노에게 답하기',
            hintText: '예: 실수하지 않게 조심시키려는 마음, 상처받기 전에 미리 대비하려는 마음',
            minLines: 3,
            maxLines: 5,
          ),
        ];
      case PositiveReframingStage.valueQuestion:
        return <Widget>[
          Text(
            '생각 ${activeIndex + 1} / ${entries.length}',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ControlledTextArea(
            value: activeEntry.valueAnswer,
            onChanged: onValueChanged,
            labelText: '보노에게 답하기',
            hintText: '예: 인정받고 싶어하는 마음, 책임감, 관계를 소중히 여기는 태도, 성실함',
            minLines: 3,
            maxLines: 5,
          ),
        ];
      case PositiveReframingStage.done:
        return const <Widget>[];
    }
  }

  int _currentIndex() {
    final int index = entries.indexWhere(
      (PositiveReframingEntry entry) => !entry.isSaved,
    );
    return index == -1 ? entries.length - 1 : index;
  }
}

class _TherapyToolsIntroPanel extends StatelessWidget {
  const _TherapyToolsIntroPanel({
    required this.selectedDistortions,
    required this.schedule,
  });

  final Set<String> selectedDistortions;
  final List<TherapyToolScheduleItem> schedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD7E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '지금 보이는 왜곡',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(selectedDistortions.join(', ')),
          const SizedBox(height: 16),
          Text(
            '오늘 함께 해볼 치료 도구',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...schedule.asMap().entries.map((MapEntry<int, TherapyToolScheduleItem> item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('${item.key + 1}. ${item.value.toolTitle}'),
            );
          }),
        ],
      ),
    );
  }
}
