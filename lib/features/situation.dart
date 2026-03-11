import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  refinedSituation: '',
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
          if (value.refinedSituation.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '정리된 상황 문장',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: value.refinedSituation),
                    );
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('정리된 문장을 복사했어.')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('복사'),
                ),
              ],
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
              child: SelectableText(value.refinedSituation),
            ),
          ],
        ],
      ),
    );
  }
}
