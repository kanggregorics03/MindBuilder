import 'package:flutter/material.dart';

import '../features/automatic_thought.dart';
import '../features/cognitive_distortion.dart';
import '../features/conversation_widgets.dart';
import '../features/emotion.dart';
import '../features/intervention.dart';
import '../features/situation.dart';
import '../services/situation_service.dart';

class CbtSessionScreen extends StatefulWidget {
  const CbtSessionScreen({super.key});

  @override
  State<CbtSessionScreen> createState() => _CbtSessionScreenState();
}

class _CbtSessionScreenState extends State<CbtSessionScreen> {
  final SituationService _situationService = const SituationService();

  int _stepIndex = 0;
  SituationDraft _situation = const SituationDraft();
  EmotionDraft _emotion = const EmotionDraft();
  AutomaticThoughtDraft _automaticThought = const AutomaticThoughtDraft();
  CognitiveDistortionDraft _distortion = const CognitiveDistortionDraft();
  InterventionDraft _intervention = const InterventionDraft();
  bool _isRefiningSituation = false;
  String? _situationError;

  bool get _isComplete => _stepIndex > 4;

  bool get _canProceed {
    if (_isComplete) {
      return true;
    }

    switch (_stepIndex) {
      case 0:
        return _situation.rawSituation.trim().isNotEmpty && !_isRefiningSituation;
      case 1:
        return _emotion.isComplete;
      case 2:
        return _automaticThought.selectedThought.trim().isNotEmpty;
      case 3:
        return _distortion.selectedDistortions.isNotEmpty;
      case 4:
        return _intervention.reframe.trim().isNotEmpty ||
            _intervention.actionPlan.trim().isNotEmpty;
      default:
        return false;
    }
  }

  String get _nextLabel => _stepIndex == 4 ? '요약 보기' : '다음';

  Future<void> _goNext() async {
    if (!_canProceed) {
      return;
    }

    if (_stepIndex == 0) {
      await _refineSituationAndContinue();
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
      _situationError = null;
    });
  }

  Future<void> _refineSituationAndContinue() async {
    final String rawSituation = _situation.rawSituation.trim();
    if (rawSituation.isEmpty) {
      return;
    }

    if (_situation.refinedSituation.trim().isNotEmpty) {
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
      final String refinedSituation = await _situationService.refineSituation(
        rawSituation,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _situation = _situation.copyWith(refinedSituation: refinedSituation);
        _stepIndex += 1;
      });
    } on SituationServiceException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _situationError = error.message;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      const String message = '상황 문장을 정리하는 중에 알 수 없는 오류가 발생했어요.';
      setState(() {
        _situationError = message;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(message)),
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isRefiningSituation = false;
      });
    }
  }

  String _fallbackText(String text) {
    if (text.trim().isEmpty) {
      return '아직 입력되지 않았어요.';
    }
    return text;
  }

  String _refinedSituationPrompt() {
    final String refinedSituation = _situation.refinedSituation.trim();
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
                        Text(_isComplete ? '요약 단계' : '${_stepIndex + 1} / 5 단계'),
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
                      onPressed: _stepIndex == 0 || _isRefiningSituation
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
          onChanged: (AutomaticThoughtDraft next) {
            setState(() {
              _automaticThought = next;
            });
          },
        );
      case 3:
        return CognitiveDistortionStepView(
          thoughtPrompt: _automaticThought.selectedThought.trim().isEmpty
              ? '자동적 사고를 먼저 정리해보자.'
              : '네가 고른 자동적 사고는 "${_automaticThought.selectedThought}"야.',
          selectedThought: _automaticThought.selectedThought,
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
    final List<String> emotionLines = _emotion.selectedMajors.map((String major) {
      final Set<String> minors = _emotion.selectedMinors[major] ?? <String>{};
      final String minorText = minors.isEmpty ? '-' : minors.join(', ');
      return '$major: $minorText';
    }).toList();

    return ListView(
      children: <Widget>[
        const CharacterBubble(
          message: '여기까지 잘 왔어. 지금까지 이야기한 내용을 한 번 정리해볼게.',
        ),
        const SizedBox(height: 16),
        Text('요약', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _SummaryCard(
          title: '상황',
          content: '원문: ${_fallbackText(_situation.rawSituation)}\n'
              '정리: ${_fallbackText(_situation.refinedSituation)}',
        ),
        _SummaryCard(
          title: '감정',
          content: emotionLines.isEmpty ? '아직 입력되지 않았어요.' : emotionLines.join('\n'),
        ),
        _SummaryCard(
          title: '자동적 사고',
          content: '1차 선택: ${_fallbackText(_automaticThought.starterChoice)}\n'
              '메모: ${_fallbackText(_automaticThought.userNotes)}\n'
              '최종 문장: ${_fallbackText(_automaticThought.selectedThought)}',
        ),
        _SummaryCard(
          title: '인지 왜곡',
          content: '선택: ${_distortion.selectedDistortions.isEmpty ? '아직 선택되지 않았어요.' : _distortion.selectedDistortions.join(', ')}\n'
              '이유: ${_fallbackText(_distortion.userReason)}',
        ),
        _SummaryCard(
          title: '개입',
          content: '대안 문장: ${_fallbackText(_intervention.reframe)}\n'
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
      if (minors.isEmpty) {
        return major;
      }
      return '$major(${minors.join(', ')})';
    }).toList();

    return '좋아. ${parts.join(', ')} 같은 감정이 느껴졌구나.';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.content,
  });

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
