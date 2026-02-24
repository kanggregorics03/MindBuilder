import 'package:flutter/material.dart';

import '../../recommend/recommend.dart';
import '../data/entry_repository.dart';
import '../domain/cbt_catalog.dart';
import '../domain/wizard_draft.dart';

class BuilderWizardScreen extends StatefulWidget {
  const BuilderWizardScreen({required this.repository, super.key});

  static const String routeName = '/wizard';

  final EntryRepository repository;

  @override
  State<BuilderWizardScreen> createState() => _BuilderWizardScreenState();
}

class _BuilderWizardScreenState extends State<BuilderWizardScreen> {
  final WizardDraft _draft = WizardDraft();
  final TextEditingController _situationNoteController =
      TextEditingController();
  final TextEditingController _negativeTextController = TextEditingController();
  final TextEditingController _balancedTextController = TextEditingController();

  int _step = 0;
  bool _isSaving = false;

  bool _useNegativeConfidence = false;
  double _negativeConfidence = 50;

  double _emotionBefore = 5;
  double _emotionAfter = 5;

  @override
  void initState() {
    super.initState();
    _draft.emotionBefore = _emotionBefore.round();
    _draft.emotionAfter = _emotionAfter.round();

    _situationNoteController.addListener(() {
      _draft.situationNote = _situationNoteController.text;
    });
    _negativeTextController.addListener(() {
      setState(() {
        _draft.negativeText = _negativeTextController.text;
      });
    });
    _balancedTextController.addListener(() {
      setState(() {
        _draft.balancedText = _balancedTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _situationNoteController.dispose();
    _negativeTextController.dispose();
    _balancedTextController.dispose();
    super.dispose();
  }

  bool get _canGoNext {
    switch (_step) {
      case 0:
        return _draft.situationTags.isNotEmpty;
      case 1:
        return _negativeTextController.text.trim().isNotEmpty;
      case 2:
        return _canSave;
      default:
        return false;
    }
  }

  bool get _canSave {
    return _draft.situationTags.isNotEmpty &&
        _negativeTextController.text.trim().isNotEmpty &&
        _balancedTextController.text.trim().isNotEmpty &&
        _draft.emotionBefore != null &&
        _draft.emotionAfter != null;
  }

  void _goBack() {
    if (_step == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _step = _step - 1;
    });
  }

  void _goNext() {
    if (!_canGoNext || _step >= 2) {
      return;
    }
    setState(() {
      _step = _step + 1;
    });
  }

  Future<void> _save() async {
    if (!_canSave || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
      _draft.negativeConfidence = _useNegativeConfidence
          ? _negativeConfidence.round()
          : null;
      _draft.emotionBefore = _emotionBefore.round();
      _draft.emotionAfter = _emotionAfter.round();
    });

    try {
      final entryId = await widget.repository.insertEntry(
        _draft.toEntryDraft(),
      );
      debugPrint('entry_saved:$entryId');
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장에 실패했습니다. 입력값을 확인해 주세요.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _applyChipToController(
    TextEditingController controller,
    String chipText,
  ) {
    final current = controller.text;
    final nextText = current.trim().isEmpty ? chipText : '$current $chipText';
    controller.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
  }

  void _setControllerText(TextEditingController controller, String text) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _toggleSituationTag(String tag, bool value) {
    if (value && _draft.situationTags.length >= maxSituationTagSelections) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('태그는 최대 $maxSituationTagSelections개까지 선택할 수 있습니다.'),
        ),
      );
      return;
    }

    setState(() {
      if (value) {
        _draft.situationTags = <String>[..._draft.situationTags, tag];
      } else {
        _draft.situationTags = _draft.situationTags
            .where((String t) => t != tag)
            .toList();
      }
    });
  }

  void _selectNegativeTemplate(String templateId) {
    setState(() {
      _draft.negativeTemplateId = templateId;
    });
    final guide = negativeTemplateGuide(templateId);
    if (guide.isNotEmpty) {
      _setControllerText(_negativeTextController, guide);
    }
  }

  void _selectBalancedTemplate(String templateId) {
    setState(() {
      _draft.balancedTemplateId = templateId;
    });
    final guide = balancedTemplateGuide(templateId);
    if (guide.isNotEmpty) {
      _setControllerText(_balancedTextController, guide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3단계 정리')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  TextButton.icon(
                    onPressed: _goBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Step ${_step + 1}/3',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _step == 2
                        ? (_canSave && !_isSaving ? _save : null)
                        : (_canGoNext ? _goNext : null),
                    child: Text(
                      _step == 2 ? (_isSaving ? '저장중...' : '저장') : 'Next',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: switch (_step) {
                  0 => _buildStepOne(),
                  1 => _buildStepTwo(),
                  _ => _buildStepThree(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('상황', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('태그를 1~$maxSituationTagSelections개 선택하세요. (그룹별 선택)'),
        const SizedBox(height: 12),
        if (_draft.situationTags.isNotEmpty) ...<Widget>[
          const Text('선택된 태그'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _draft.situationTags.map((String tag) {
              return InputChip(
                label: Text(tag),
                onDeleted: () => _toggleSituationTag(tag, false),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        ...situationTagGroups.entries.map((
          MapEntry<String, List<String>> group,
        ) {
          final selectedCount = group.value
              .where((String tag) => _draft.situationTags.contains(tag))
              .length;
          return Card(
            child: ExpansionTile(
              initiallyExpanded: selectedCount > 0,
              title: Text(group.key),
              subtitle: Text(
                selectedCount > 0
                    ? '전체 ${group.value.length}개 · 선택 $selectedCount개'
                    : '전체 ${group.value.length}개',
              ),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: group.value.map((String tag) {
                      final selected = _draft.situationTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: selected,
                        onSelected: (bool value) =>
                            _toggleSituationTag(tag, value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Text('감정 전 (필수, 0~10)', style: Theme.of(context).textTheme.titleMedium),
        Slider(
          value: _emotionBefore,
          min: 0,
          max: 10,
          divisions: 10,
          label: _emotionBefore.round().toString(),
          onChanged: (double value) {
            setState(() {
              _emotionBefore = value;
              _draft.emotionBefore = value.round();
            });
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${_emotionBefore.round()}'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _situationNoteController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: '상황 메모 (옵션)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    final chips = recommendNegativeChips(tags: _draft.situationTags);
    final templateGuide = negativeTemplateGuide(_draft.negativeTemplateId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('부정적 생각', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('템플릿 선택 (선택 시 문장 초안 자동 입력)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: negativeTemplateOptions.map((TemplateOption template) {
            return ChoiceChip(
              label: Text(template.label),
              selected: _draft.negativeTemplateId == template.id,
              onSelected: (_) => _selectNegativeTemplate(template.id),
            );
          }).toList(),
        ),
        if (templateGuide.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(templateGuide),
          ),
        ],
        const SizedBox(height: 16),
        const Text('추천 문장 조각'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((String chipText) {
            return ActionChip(
              label: Text(chipText),
              onPressed: () {
                _applyChipToController(_negativeTextController, chipText);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _negativeTextController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: '부정적 생각 (필수)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('확신 입력 (0~100)'),
          value: _useNegativeConfidence,
          onChanged: (bool value) {
            setState(() {
              _useNegativeConfidence = value;
              _draft.negativeConfidence = value
                  ? _negativeConfidence.round()
                  : null;
            });
          },
        ),
        if (_useNegativeConfidence) ...<Widget>[
          Slider(
            value: _negativeConfidence,
            min: 0,
            max: 100,
            divisions: 100,
            label: _negativeConfidence.round().toString(),
            onChanged: (double value) {
              setState(() {
                _negativeConfidence = value;
                _draft.negativeConfidence = value.round();
              });
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${_negativeConfidence.round()}'),
          ),
        ],
        const SizedBox(height: 16),
        const Text('인지 왜곡 (복수 선택 가능, 옵션)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: distortionOptions.map((DistortionOption distortion) {
            final selected = _draft.distortions.contains(distortion.id);
            return FilterChip(
              label: Text(distortion.label),
              selected: selected,
              onSelected: (bool value) {
                setState(() {
                  if (value) {
                    _draft.distortions = <String>[
                      ..._draft.distortions,
                      distortion.id,
                    ];
                  } else {
                    _draft.distortions = _draft.distortions
                        .where((String id) => id != distortion.id)
                        .toList();
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Text('빈도 (옵션)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            ChoiceChip(
              label: const Text('항상'),
              selected: _draft.negativeFrequency == '항상',
              onSelected: (bool selected) {
                setState(() {
                  _draft.negativeFrequency = selected ? '항상' : null;
                });
              },
            ),
            ChoiceChip(
              label: const Text('자주'),
              selected: _draft.negativeFrequency == '자주',
              onSelected: (bool selected) {
                setState(() {
                  _draft.negativeFrequency = selected ? '자주' : null;
                });
              },
            ),
            ChoiceChip(
              label: const Text('가끔'),
              selected: _draft.negativeFrequency == '가끔',
              onSelected: (bool selected) {
                setState(() {
                  _draft.negativeFrequency = selected ? '가끔' : null;
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _draft.negativeFrequency = null;
                });
              },
              child: const Text('해제'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepThree() {
    final chips = recommendBalancedChips(tags: _draft.situationTags);
    final templateGuide = balancedTemplateGuide(_draft.balancedTemplateId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('균형 생각', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('템플릿 선택 (선택 시 문장 초안 자동 입력)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: balancedTemplateOptions.map((TemplateOption template) {
            return ChoiceChip(
              label: Text(template.label),
              selected: _draft.balancedTemplateId == template.id,
              onSelected: (_) => _selectBalancedTemplate(template.id),
            );
          }).toList(),
        ),
        if (templateGuide.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(templateGuide),
          ),
        ],
        const SizedBox(height: 16),
        const Text('추천 문장 조각'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((String chipText) {
            return ActionChip(
              label: Text(chipText),
              onPressed: () {
                _applyChipToController(_balancedTextController, chipText);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _balancedTextController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: '균형 생각 (필수)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text('감정 후 (필수, 0~10)', style: Theme.of(context).textTheme.titleMedium),
        Slider(
          value: _emotionAfter,
          min: 0,
          max: 10,
          divisions: 10,
          label: _emotionAfter.round().toString(),
          onChanged: (double value) {
            setState(() {
              _emotionAfter = value;
              _draft.emotionAfter = value.round();
            });
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${_emotionAfter.round()}'),
        ),
      ],
    );
  }
}
