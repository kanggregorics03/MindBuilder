import 'package:flutter/material.dart';

import '../features/automatic_thought.dart';
import '../features/cognitive_distortion.dart';
import '../features/conversation_widgets.dart';
import '../features/emotion.dart';
import '../features/intervention.dart';
import '../features/situation.dart';
import '../services/automatic_thought_service.dart';
import '../services/situation_service.dart';

class CbtSessionScreen extends StatefulWidget {
  const CbtSessionScreen({
    super.key,
    SituationService? situationService,
    AutomaticThoughtService? automaticThoughtService,
  }) : _situationService = situationService ?? const SituationService(),
       _automaticThoughtService =
           automaticThoughtService ?? const AutomaticThoughtService();

  final SituationService _situationService;
  final AutomaticThoughtService _automaticThoughtService;

  @override
  State<CbtSessionScreen> createState() => _CbtSessionScreenState();
}

class _CbtSessionScreenState extends State<CbtSessionScreen> {
  int _stepIndex = 0;
  SituationDraft _situation = const SituationDraft();
  EmotionDraft _emotion = const EmotionDraft();
  AutomaticThoughtDraft _automaticThought = const AutomaticThoughtDraft();
  CognitiveDistortionDraft _distortion = const CognitiveDistortionDraft();
  InterventionDraft _intervention = const InterventionDraft();
  bool _isRefiningSituation = false;
  bool _isGeneratingAutomaticThoughts = false;
  String? _situationError;
  String? _automaticThoughtError;

  bool get _isComplete => _stepIndex > 4;

  bool get _canProceed {
    if (_isComplete) {
      return true;
    }

    switch (_stepIndex) {
      case 0:
        return !_isRefiningSituation &&
            (_situation.refineResult.reframed.trim().isNotEmpty ||
                _situation.rawSituation.trim().isNotEmpty);
      case 1:
        return _emotion.isComplete && !_isGeneratingAutomaticThoughts;
      case 2:
        return !_isGeneratingAutomaticThoughts &&
            _automaticThought.selectedThoughts.isNotEmpty;
      case 3:
        return _distortion.selectedDistortions.isNotEmpty;
      case 4:
        return _intervention.reframe.trim().isNotEmpty ||
            _intervention.actionPlan.trim().isNotEmpty;
      default:
        return false;
    }
  }

  String get _nextLabel {
    if (_stepIndex == 0) {
      return _situation.refineResult.reframed.trim().isNotEmpty &&
              !_situation.hasPendingEdits
          ? '이 문장으로 진행'
          : '정리하기';
    }

    return _stepIndex == 4 ? '요약 보기' : '다음';
  }

  Future<void> _goNext() async {
    if (!_canProceed) {
      return;
    }

    if (_stepIndex == 0) {
      await _refineSituationAndContinue();
      return;
    }

    if (_stepIndex == 1) {
      await _generateAutomaticThoughtsAndContinue(advanceStep: true);
      return;
    }

    setState(() {
      _stepIndex += 1;
    });
  }

  void _goBack() {
    if (_stepIndex == 0) {
      return;
    }

    setState(() {
      _stepIndex -= 1;
    });
  }

  void _restart() {
    setState(() {
      _stepIndex = 0;
      _situation = const SituationDraft();
      _emotion = const EmotionDraft();
      _automaticThought = const AutomaticThoughtDraft();
      _distortion = const CognitiveDistortionDraft();
      _intervention = const InterventionDraft();
      _isRefiningSituation = false;
      _isGeneratingAutomaticThoughts = false;
      _situationError = null;
      _automaticThoughtError = null;
    });
  }

  Future<void> _refineSituationAndContinue() async {
    final String rawSituation = _situation.rawSituation.trim();
    if (rawSituation.isEmpty) {
      return;
    }

    if (_situation.refineResult.reframed.trim().isNotEmpty &&
        !_situation.hasPendingEdits) {
      setState(() {
        _stepIndex += 1;
      });
      return;
    }

    setState(() {
      _isRefiningSituation = true;
      _situationError = null;
    });

    try {
      final SituationRefineResult refinedSituation = await widget
          ._situationService
          .refineSituation(rawSituation);

      if (!mounted) {
        return;
      }

      setState(() {
        final String currentInput = rawSituation;
        final String previousOriginal = _situation.originalSituation.trim();
        final String originalSituation = previousOriginal.isEmpty
            ? currentInput
            : _situation.originalSituation;
        final String revisedSituation =
            previousOriginal.isNotEmpty && previousOriginal != currentInput
            ? currentInput
            : '';

        _situation = _situation.copyWith(
          refineResult: refinedSituation,
          hasPendingEdits: false,
          originalSituation: originalSituation,
          revisedSituation: revisedSituation,
        );
      });
    } on SituationServiceException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _situationError = error.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      const String message = '상황 문장을 정리하는 중에 알 수 없는 오류가 발생했어요.';
      setState(() {
        _situationError = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isRefiningSituation = false;
        });
      }
    }
  }

  String _fallbackText(String text) {
    if (text.trim().isEmpty) {
      return '아직 입력되지 않았어요.';
    }
    return text;
  }

  Future<void> _generateAutomaticThoughtsAndContinue({
    required bool advanceStep,
  }) async {
    if (_automaticThought.recommendedThoughts.isNotEmpty) {
      if (advanceStep) {
        setState(() {
          _stepIndex += 1;
        });
      }
      return;
    }

    final String situationPrompt = _refinedSituationPrompt().trim();
    if (situationPrompt.isEmpty) {
      return;
    }

    setState(() {
      _isGeneratingAutomaticThoughts = true;
      _automaticThoughtError = null;
    });

    try {
      final List<String> thoughts = await _automaticThoughtService
          .generateAutomaticThoughts(situationPrompt);

      if (!mounted) {
        return;
      }

      setState(() {
        _automaticThought = _automaticThought.copyWith(
          recommendedThoughts: thoughts,
          selectedThoughts: const <String>[],
          customThoughtDraft: '',
          editingThoughtIndex: -1,
          isComposerOpen: false,
        );
        if (advanceStep) {
          _stepIndex += 1;
        }
      });
    } on AutomaticThoughtServiceException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _automaticThoughtError = error.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      const String message = '자동적 사고 추천을 불러오는 중에 알 수 없는 오류가 발생했어요.';
      setState(() {
        _automaticThoughtError = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingAutomaticThoughts = false;
        });
      }
    }
  }

  AutomaticThoughtService get _automaticThoughtService =>
      widget._automaticThoughtService;

  String _refinedSituationPrompt() {
    final String refinedSituation = _situation.refineResult.reframed.trim();
    if (refinedSituation.isNotEmpty) {
      return refinedSituation;
    }

    final String rawSituation = _situation.rawSituation.trim();
    if (rawSituation.isNotEmpty) {
      return rawSituation;
    }

    return '상황 문장을 먼저 입력해줘.';
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _isComplete ? _buildSummary() : _buildCurrentStep();

    return Scaffold(
      appBar: AppBar(title: const Text('Mind Builder')),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFF6FBFD), Color(0xFFEAF4F8)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const CharacterAvatar(size: 48),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '보노와 대화하는 CBT',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          _isComplete ? '요약 단계' : '${_stepIndex + 1} / 5 단계',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _isComplete ? 1 : (_stepIndex + 1) / 5,
                ),
                const SizedBox(height: 16),
                Expanded(child: body),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed:
                          _stepIndex == 0 ||
                              _isRefiningSituation ||
                              _isGeneratingAutomaticThoughts
                          ? null
                          : _goBack,
                      child: const Text('이전'),
                    ),
                    const Spacer(),
                    if (_isComplete)
                      ElevatedButton(
                        onPressed: _restart,
                        child: const Text('처음부터 다시'),
                      )
                    else
                      ElevatedButton(
                        onPressed: _canProceed ? _goNext : null,
                        child: Text(_nextLabel),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_stepIndex) {
      case 0:
        return SituationStepView(
          value: _situation,
          isLoading: _isRefiningSituation,
          errorText: _situationError,
          onRewriteRequested: () {
            setState(() {
              _situation = _situation.copyWith(hasPendingEdits: true);
              _situationError = null;
            });
          },
          onChanged: (SituationDraft next) {
            setState(() {
              _situation = next;
              _situationError = null;
            });
          },
        );
      case 1:
        return EmotionStepView(
          situationPrompt: _refinedSituationPrompt(),
          value: _emotion,
          onChanged: (EmotionDraft next) {
            setState(() {
              _emotion = next;
            });
          },
        );
      case 2:
        return AutomaticThoughtStepView(
          emotionPrompt: _emotionSummary(),
          value: _automaticThought,
          isLoading: _isGeneratingAutomaticThoughts,
          errorText: _automaticThoughtError,
          onRetry: () {
            _generateAutomaticThoughtsAndContinue(advanceStep: false);
          },
          onChanged: (AutomaticThoughtDraft next) {
            setState(() {
              _automaticThought = next;
            });
          },
        );
      case 3:
        return CognitiveDistortionStepView(
          thoughtPrompt: _automaticThought.selectedThoughts.isEmpty
              ? '자동적 사고를 먼저 정리해보자.'
              : '네가 고른 자동적 사고를 같이 살펴보자.',
          selectedThoughts: _automaticThought.selectedThoughts,
          value: _distortion,
          onChanged: (CognitiveDistortionDraft next) {
            setState(() {
              _distortion = next;
            });
          },
        );
      case 4:
        return InterventionStepView(
          distortionPrompt: _distortion.selectedDistortions.isEmpty
              ? '인지 왜곡을 먼저 골라보자.'
              : '지금 보이는 인지 왜곡은 ${_distortion.selectedDistortions.join(', ')}이야.',
          value: _intervention,
          onChanged: (InterventionDraft next) {
            setState(() {
              _intervention = next;
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSummary() {
    final List<String> emotionLines = _emotion.selectedMajors.map((
      String major,
    ) {
      final Set<String> minors = _emotion.selectedMinors[major] ?? <String>{};
      final List<String> labels = <String>[
        ...minors.where((String minor) => minor != '직접 입력'),
      ];
      if (major == '기타 감정' && _emotion.customEmotion.trim().isNotEmpty) {
        labels.add('직접 입력(${_emotion.customEmotion.trim()})');
      } else if (minors.contains('직접 입력')) {
        labels.add('직접 입력');
      }
      final String minorText = labels.isEmpty ? '-' : labels.join(', ');
      return '$major: $minorText';
    }).toList();

    return ListView(
      children: <Widget>[
        const CharacterBubble(message: '여기까지 잘 왔어. 지금까지 이야기한 내용을 한 번 정리해볼게.'),
        const SizedBox(height: 16),
        Text('요약', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _SummaryCard(
          title: '상황',
          content:
              '처음 원문: ${_fallbackText(_situation.originalSituation)}\n'
              '수정한 문장: ${_fallbackText(_situation.revisedSituation)}\n'
              '의미: ${_fallbackText(_situation.refineResult.original)}\n'
              '피드백: ${_fallbackText(_situation.refineResult.feedback)}\n'
              '정리: ${_fallbackText(_situation.refineResult.reframed)}',
        ),
        _SummaryCard(
          title: '감정',
          content: emotionLines.isEmpty
              ? '아직 입력되지 않았어요.'
              : emotionLines.join('\n'),
        ),
        _SummaryCard(
          title: '자동적 사고',
          content:
              '추천 개수: ${_automaticThought.recommendedThoughts.length}\n'
              '선택 문장들: ${_automaticThought.selectedThoughts.isEmpty ? '아직 입력되지 않았어요.' : _automaticThought.selectedThoughts.join(' / ')}',
        ),
        _SummaryCard(
          title: '인지 왜곡',
          content:
              '선택: ${_distortion.selectedDistortions.isEmpty ? '아직 선택되지 않았어요.' : _distortion.selectedDistortions.join(', ')}\n'
              '이유: ${_fallbackText(_distortion.userReason)}',
        ),
        _SummaryCard(
          title: '개입',
          content:
              '대안 문장: ${_fallbackText(_intervention.reframe)}\n'
              '행동 계획: ${_fallbackText(_intervention.actionPlan)}',
        ),
      ],
    );
  }

  String _emotionSummary() {
    if (_emotion.selectedMajors.isEmpty) {
      return '지금 느낀 감정을 골라줘.';
    }

    final List<String> parts = _emotion.selectedMajors.map((String major) {
      final Set<String> minors = _emotion.selectedMinors[major] ?? <String>{};
      final List<String> labels = <String>[
        ...minors.where((String minor) => minor != '직접 입력'),
      ];
      if (major == '기타 감정' && _emotion.customEmotion.trim().isNotEmpty) {
        labels.add('직접 입력(${_emotion.customEmotion.trim()})');
      } else if (minors.contains('직접 입력')) {
        labels.add('직접 입력');
      }

      if (labels.isEmpty) {
        return major;
      }
      return '$major(${labels.join(', ')})';
    }).toList();

    return '좋아. ${parts.join(', ')} 같은 감정이 느껴졌구나.';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
