import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

enum SituationProgressChoice { none, original, reframed }

class SituationRefineResult {
  const SituationRefineResult({
    this.original = '',
    this.feedback = '',
    this.reframed = '',
  });

  final String original;
  final String feedback;
  final String reframed;

  factory SituationRefineResult.fromJson(Map<String, dynamic> json) {
    return SituationRefineResult(
      original: (json['original'] as String? ?? '').trim(),
      feedback: (json['feedback'] as String? ?? '').trim(),
      reframed: (json['reframed'] as String? ?? '').trim(),
    );
  }
}

class SituationDraft {
  const SituationDraft({
    this.rawSituation = '',
    this.refineResult = const SituationRefineResult(),
    this.hasPendingEdits = false,
    this.originalSituation = '',
    this.revisedSituation = '',
    this.progressChoice = SituationProgressChoice.none,
  });

  final String rawSituation;
  final SituationRefineResult refineResult;
  final bool hasPendingEdits;
  final String originalSituation;
  final String revisedSituation;
  final SituationProgressChoice progressChoice;

  SituationDraft copyWith({
    String? rawSituation,
    SituationRefineResult? refineResult,
    bool? hasPendingEdits,
    String? originalSituation,
    String? revisedSituation,
    SituationProgressChoice? progressChoice,
  }) {
    return SituationDraft(
      rawSituation: rawSituation ?? this.rawSituation,
      refineResult: refineResult ?? this.refineResult,
      hasPendingEdits: hasPendingEdits ?? this.hasPendingEdits,
      originalSituation: originalSituation ?? this.originalSituation,
      revisedSituation: revisedSituation ?? this.revisedSituation,
      progressChoice: progressChoice ?? this.progressChoice,
    );
  }
}

class SituationStepView extends StatelessWidget {
  const SituationStepView({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onRewriteRequested,
    this.isLoading = false,
    this.errorText,
  });

  final SituationDraft value;
  final ValueChanged<SituationDraft> onChanged;
  final VoidCallback onRewriteRequested;
  final bool isLoading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return ConversationStepLayout(
      message:
          '무슨 일이 있었는지 사실 위주로 적어줘. 평가보다 장면과 행동을 적어주면 내가 CBT 상황 문장으로 더 정확하게 정리할게.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ControlledTextArea(
            value: value.rawSituation,
            minLines: 3,
            maxLines: 5,
            onChanged: (String text) {
              onChanged(
                value.copyWith(
                  rawSituation: text,
                  hasPendingEdits: value.refineResult.reframed
                      .trim()
                      .isNotEmpty,
                ),
              );
            },
            labelText: '상황 입력',
            hintText: '예: 회의 중 발표를 했는데 준비한 내용을 몇 군데 빠뜨리고 말이 자주 끊겼어.',
          ),
          if (isLoading) ...<Widget>[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              '입력한 상황을 CBT 관점의 상황 문장으로 정리하고 있어.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (errorText != null && errorText!.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              errorText!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          if (value.refineResult.reframed.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            _ChoiceCard(
              title: '처음 문장',
              content: value.originalSituation.trim().isNotEmpty
                  ? value.originalSituation
                  : value.rawSituation,
              isSelected: value.progressChoice == SituationProgressChoice.original,
            ),
            const SizedBox(height: 12),
            if (value.refineResult.feedback.trim().isNotEmpty) ...<Widget>[
              _ResultSection(
                title: value.hasPendingEdits ? '이전 피드백' : '피드백',
                content: value.refineResult.feedback,
              ),
              const SizedBox(height: 12),
            ],
            _ChoiceCard(
              title: '다듬은 문장',
              content: value.refineResult.reframed,
              isSelected: value.progressChoice == SituationProgressChoice.reframed,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: onRewriteRequested,
                child: const Text('피드백 반영해서 다시 쓰기'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value.hasPendingEdits
                  ? '이전 피드백과 정리 문장을 참고하면서 원문을 수정하고 있어. 준비되면 다시 정리하기를 눌러줘.'
                  : '입력한 원문은 그대로 남아 있어. 수정한 뒤 다시 정리하기를 눌러줘.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.content,
    required this.isSelected,
  });

  final String title;
  final String content;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? const Color(0xFF126E82)
        : const Color(0xFFB6DDE5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          SelectableText(content),
        ],
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({required this.title, required this.content});

  final String? title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB6DDE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null && title!.trim().isNotEmpty) ...<Widget>[
            Text(
              title!,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
          ],
          SelectableText(content),
        ],
      ),
    );
  }
}
