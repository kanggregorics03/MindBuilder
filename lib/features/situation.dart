import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

class SituationDraft {
  const SituationDraft({
    this.rawSituation = '',
    this.refinedSituation = '',
  });

  final String rawSituation;
  final String refinedSituation;

  SituationDraft copyWith({
    String? rawSituation,
    String? refinedSituation,
  }) {
    return SituationDraft(
      rawSituation: rawSituation ?? this.rawSituation,
      refinedSituation: refinedSituation ?? this.refinedSituation,
    );
  }
}

class SituationStepView extends StatelessWidget {
  const SituationStepView({
    super.key,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
    this.errorText,
  });

  final SituationDraft value;
  final ValueChanged<SituationDraft> onChanged;
  final bool isLoading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return ConversationStepLayout(
      message: '무슨 상황이 있었는지 편하게 말해줘. 내가 CBT용 상황 문장으로 정리해볼게.',
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
                  refinedSituation: '',
                ),
              );
            },
            labelText: '상황 입력',
            hintText: '예: 회의에서 내 의견을 말했는데 팀장이 바로 다른 안건으로 넘어갔다.',
          ),
          if (isLoading) ...<Widget>[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              '입력한 상황을 CBT 관점의 상황 문장으로 정리하고 있어요.',
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
          if (value.refinedSituation.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Text(
              '정리된 상황 문장',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB6DDE5)),
              ),
              child: Text(value.refinedSituation),
            ),
          ],
        ],
      ),
    );
  }
}
