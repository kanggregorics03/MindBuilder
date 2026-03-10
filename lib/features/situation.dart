import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

class SituationDraft {
  const SituationDraft({this.rawSituation = ''});

  final String rawSituation;

  SituationDraft copyWith({String? rawSituation}) {
    return SituationDraft(rawSituation: rawSituation ?? this.rawSituation);
  }
}

class SituationStepView extends StatelessWidget {
  const SituationStepView({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final SituationDraft value;
  final ValueChanged<SituationDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    return ConversationStepLayout(
      message: '무슨 상황이 있었는지 편하게 말해줘.',
      child: ControlledTextArea(
        value: value.rawSituation,
        minLines: 3,
        maxLines: 5,
        onChanged: (String text) {
          onChanged(value.copyWith(rawSituation: text));
        },
        labelText: '상황 입력',
        hintText: '예: 팀 회의에서 내 의견을 말했는데 바로 다음 안건으로 넘어갔다.',
      ),
    );
  }
}
