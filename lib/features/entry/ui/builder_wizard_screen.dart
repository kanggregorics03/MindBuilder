import 'package:flutter/material.dart';

import '../../recommend/recommend.dart';
import '../data/entry_repository.dart';
import '../domain/wizard_draft.dart';

class BuilderWizardScreen extends StatefulWidget {
  const BuilderWizardScreen({required this.repository, super.key});

  static const String routeName = '/wizard';

  final EntryRepository repository;

  @override
  State<BuilderWizardScreen> createState() => _BuilderWizardScreenState();
}

class _BuilderWizardScreenState extends State<BuilderWizardScreen> {
  static const List<String> _allSituationTags = <String>[
    '평가',
    '관계',
    '실수',
    '업무',
    '외모',
    '가족',
  ];

  static const List<String> _negativeTemplateIds = <String>[
    'I_AM_LABEL',
    'BAD_OUTCOME',
    'THEY_JUDGE',
    'EVIDENCE',
    'MUST',
    'COMPARE',
    'FREE_TEXT',
  ];

  static const List<String> _balancedTemplateIds = <String>[
    'ALT',
    'EVID',
    'ACTION',
    'FREE_TEXT',
  ];

  final WizardDraft _draft = WizardDraft();
  final TextEditingController _situationNoteController =
      TextEditingController();
  final TextEditingController _negativeTextController = TextEditingController();
  final TextEditingController _balancedTextController = TextEditingController();

  int _step = 0;
  bool _isSaving = false;

  bool _useNegativeConfidence = false;
  double _negativeConfidence = 50;

  bool _useEmotionBefore = false;
  double _emotionBefore = 5;

  bool _useEmotionAfter = false;
  double _emotionAfter = 5;

  @override
  void initState() {
    super.initState();
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
        _balancedTextController.text.trim().isNotEmpty;
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
      _draft.emotionBefore = _useEmotionBefore ? _emotionBefore.round() : null;
      _draft.emotionAfter = _useEmotionAfter ? _emotionAfter.round() : null;
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
        const Text('태그를 1~2개 선택하세요.'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allSituationTags.map((String tag) {
            final selected = _draft.situationTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: selected,
              onSelected: (bool value) {
                if (value && _draft.situationTags.length >= 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('태그는 최대 2개까지 선택할 수 있습니다.')),
                  );
                  return;
                }

                setState(() {
                  if (value) {
                    _draft.situationTags = <String>[
                      ..._draft.situationTags,
                      tag,
                    ];
                  } else {
                    _draft.situationTags = _draft.situationTags
                        .where((String t) => t != tag)
                        .toList();
                  }
                });
              },
            );
          }).toList(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('부정적 생각', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('템플릿 선택 (선택하지 않으면 FREE_TEXT)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _negativeTemplateIds.map((String templateId) {
            return ChoiceChip(
              label: Text(templateId),
              selected: _draft.negativeTemplateId == templateId,
              onSelected: (_) {
                setState(() {
                  _draft.negativeTemplateId = templateId;
                });
              },
            );
          }).toList(),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('균형 생각', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('템플릿 선택 (선택하지 않으면 FREE_TEXT)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _balancedTemplateIds.map((String templateId) {
            return ChoiceChip(
              label: Text(templateId),
              selected: _draft.balancedTemplateId == templateId,
              onSelected: (_) {
                setState(() {
                  _draft.balancedTemplateId = templateId;
                });
              },
            );
          }).toList(),
        ),
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
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('감정 전 (0~10)'),
          value: _useEmotionBefore,
          onChanged: (bool value) {
            setState(() {
              _useEmotionBefore = value;
              _draft.emotionBefore = value ? _emotionBefore.round() : null;
            });
          },
        ),
        if (_useEmotionBefore) ...<Widget>[
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
        ],
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('감정 후 (0~10)'),
          value: _useEmotionAfter,
          onChanged: (bool value) {
            setState(() {
              _useEmotionAfter = value;
              _draft.emotionAfter = value ? _emotionAfter.round() : null;
            });
          },
        ),
        if (_useEmotionAfter) ...<Widget>[
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
      ],
    );
  }
}
