import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

class InterventionDraft {
  const InterventionDraft({
    this.reframe = '',
    this.actionPlan = '',
  });

  final String reframe;
  final String actionPlan;

  InterventionDraft copyWith({
    String? reframe,
    String? actionPlan,
  }) {
    return InterventionDraft(
      reframe: reframe ?? this.reframe,
      actionPlan: actionPlan ?? this.actionPlan,
    );
  }
}

class InterventionStepView extends StatelessWidget {
  const InterventionStepView({
    super.key,
    required this.distortionPrompt,
    required this.value,
    required this.onChanged,
  });

  final String distortionPrompt;
  final InterventionDraft value;
  final ValueChanged<InterventionDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final String intro = distortionPrompt.trim().isEmpty
        ? ''
        : '$distortionPrompt\n';
    final String message =
        '${intro}마지막으로 지금 생각을 조금 덜 힘들게 볼 수 있는 문장과 다음 행동을 같이 정리해보자.';

    return ConversationStepLayout(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ControlledTextArea(
            value: value.reframe,
            minLines: 3,
            maxLines: 5,
            onChanged: (String text) {
              onChanged(value.copyWith(reframe: text));
            },
            labelText: '대안적 생각',
            hintText: 'LLM 미구현으로 인해 비워둠. 지금은 직접 적어주세요.',
          ),
          const SizedBox(height: 12),
          ControlledTextArea(
            value: value.actionPlan,
            minLines: 3,
            maxLines: 5,
            onChanged: (String text) {
              onChanged(value.copyWith(actionPlan: text));
            },
            labelText: '다음 행동',
            hintText: '예: 다음 회의에서 한 번 더 요점을 짧게 말하고, 회의 후 필요한 내용을 메시지로 정리한다.',
          ),
        ],
      ),
    );
  }
}
