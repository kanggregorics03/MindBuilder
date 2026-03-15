import 'package:flutter/material.dart';

import 'controlled_text_area.dart';
import 'conversation_widgets.dart';

class AutomaticThoughtDraft {
  const AutomaticThoughtDraft({
    this.recommendedThoughts = const <String>[],
    this.selectedThoughts = const <String>[],
    this.customThoughtDraft = '',
    this.editingThoughtIndex = -1,
    this.isComposerOpen = false,
  });

  final List<String> recommendedThoughts;
  final List<String> selectedThoughts;
  final String customThoughtDraft;
  final int editingThoughtIndex;
  final bool isComposerOpen;

  AutomaticThoughtDraft copyWith({
    List<String>? recommendedThoughts,
    List<String>? selectedThoughts,
    String? customThoughtDraft,
    int? editingThoughtIndex,
    bool? isComposerOpen,
  }) {
    return AutomaticThoughtDraft(
      recommendedThoughts: recommendedThoughts ?? this.recommendedThoughts,
      selectedThoughts: selectedThoughts ?? this.selectedThoughts,
      customThoughtDraft: customThoughtDraft ?? this.customThoughtDraft,
      editingThoughtIndex: editingThoughtIndex ?? this.editingThoughtIndex,
      isComposerOpen: isComposerOpen ?? this.isComposerOpen,
    );
  }

  bool isSelected(String thought) => selectedThoughts.contains(thought);

  AutomaticThoughtDraft toggleSelection(String thought) {
    final List<String> next = List<String>.from(selectedThoughts);
    if (next.contains(thought)) {
      next.remove(thought);
    } else {
      next.add(thought);
    }

    return copyWith(selectedThoughts: next);
  }

  AutomaticThoughtDraft openComposerForNew() {
    return copyWith(
      isComposerOpen: true,
      editingThoughtIndex: -1,
      customThoughtDraft: '',
    );
  }

  AutomaticThoughtDraft openComposerForEdit(int index) {
    if (index < 0 || index >= selectedThoughts.length) {
      return this;
    }

    return copyWith(
      isComposerOpen: true,
      editingThoughtIndex: index,
      customThoughtDraft: selectedThoughts[index],
    );
  }

  AutomaticThoughtDraft updateCustomThoughtDraft(String text) {
    return copyWith(customThoughtDraft: text);
  }

  AutomaticThoughtDraft saveComposer() {
    final String normalized = customThoughtDraft.trim();
    if (normalized.isEmpty) {
      return this;
    }

    final List<String> next = List<String>.from(selectedThoughts);
    if (editingThoughtIndex >= 0 && editingThoughtIndex < next.length) {
      next[editingThoughtIndex] = normalized;
    } else if (!next.contains(normalized)) {
      next.add(normalized);
    }

    return copyWith(
      selectedThoughts: next,
      customThoughtDraft: '',
      editingThoughtIndex: -1,
      isComposerOpen: false,
    );
  }

  AutomaticThoughtDraft closeComposer() {
    return copyWith(
      customThoughtDraft: '',
      editingThoughtIndex: -1,
      isComposerOpen: false,
    );
  }

  AutomaticThoughtDraft removeSelectedThought(int index) {
    if (index < 0 || index >= selectedThoughts.length) {
      return this;
    }

    final List<String> next = List<String>.from(selectedThoughts)
      ..removeAt(index);
    return copyWith(
      selectedThoughts: next,
      customThoughtDraft: editingThoughtIndex == index
          ? ''
          : customThoughtDraft,
      editingThoughtIndex: editingThoughtIndex == index
          ? -1
          : editingThoughtIndex,
      isComposerOpen: editingThoughtIndex == index ? false : isComposerOpen,
    );
  }
}

class AutomaticThoughtStepView extends StatelessWidget {
  const AutomaticThoughtStepView({
    super.key,
    required this.emotionPrompt,
    required this.value,
    required this.onChanged,
    required this.isLoading,
    required this.onRetry,
    this.errorText,
  });

  final String emotionPrompt;
  final AutomaticThoughtDraft value;
  final ValueChanged<AutomaticThoughtDraft> onChanged;
  final bool isLoading;
  final VoidCallback onRetry;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final String intro = emotionPrompt.trim().isEmpty ? '' : '$emotionPrompt\n';
    final String message =
        '$intro그 상황에서 머릿속을 스쳤을 법한 자동적 사고를 몇 가지 추려봤어. 여러 개를 골라도 되고, 직접 추가해도 돼.';

    return ConversationStepLayout(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '추천 자동적 사고',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (isLoading) ...<Widget>[
            const LinearProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              '상황 문장을 바탕으로 자동적 사고를 추천하고 있어.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ] else if (errorText != null &&
              errorText!.trim().isNotEmpty) ...<Widget>[
            Text(
              errorText!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('다시 불러오기')),
          ] else ...<Widget>[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: value.recommendedThoughts.map((String thought) {
                final bool selected = value.isSelected(thought);
                return FilterChip(
                  label: Text(thought),
                  selected: selected,
                  onSelected: (_) {
                    onChanged(value.toggleSelection(thought));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              '선택한 자동적 사고',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (value.selectedThoughts.isEmpty)
              Text(
                '아직 선택한 문장이 없어. 추천 문장을 누르거나 직접 작성해줘.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              Column(
                children: value.selectedThoughts.asMap().entries.map((
                  MapEntry<int, String> entry,
                ) {
                  return _SelectedThoughtCard(
                    text: entry.value,
                    onEdit: () {
                      onChanged(value.openComposerForEdit(entry.key));
                    },
                    onDelete: () {
                      onChanged(value.removeSelectedThought(entry.key));
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  onChanged(value.openComposerForNew());
                },
                icon: const Icon(Icons.edit_note),
                label: const Text('직접 작성'),
              ),
            ),
            if (value.isComposerOpen) ...<Widget>[
              const SizedBox(height: 12),
              ControlledTextArea(
                value: value.customThoughtDraft,
                minLines: 3,
                maxLines: 5,
                onChanged: (String text) {
                  onChanged(value.updateCustomThoughtDraft(text));
                },
                labelText: value.editingThoughtIndex >= 0
                    ? '문장 수정'
                    : '자동적 사고 직접 작성',
                hintText: '예: 친구가 나를 싫어하게 된 것 같아.',
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      onChanged(value.closeComposer());
                    },
                    child: const Text('취소'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: value.customThoughtDraft.trim().isEmpty
                        ? null
                        : () {
                            onChanged(value.saveComposer());
                          },
                    child: Text(
                      value.editingThoughtIndex >= 0 ? '수정 저장' : '추가',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SelectedThoughtCard extends StatelessWidget {
  const _SelectedThoughtCard({
    required this.text,
    required this.onEdit,
    required this.onDelete,
  });

  final String text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDDE3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              TextButton.icon(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('수정'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('삭제'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
