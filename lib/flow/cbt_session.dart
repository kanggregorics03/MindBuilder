import 'package:flutter/material.dart';

import '../features/automatic_thought.dart';
import '../features/cognitive_distortion.dart';
import '../features/conversation_widgets.dart';
import '../features/emotion.dart';
import '../features/intervention.dart';
import '../features/situation.dart';

class CbtSessionScreen extends StatefulWidget {
  const CbtSessionScreen({super.key});

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

  bool get _isComplete => _stepIndex > 4;

  bool get _canProceed {
    if (_isComplete) {
      return true;
    }

    switch (_stepIndex) {
      case 0:
        return _situation.rawSituation.trim().isNotEmpty;
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

  void _goNext() {
    if (!_canProceed) {
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
    });
  }

  String _fallbackText(String text) {
    if (text.trim().isEmpty) {
      return '추후 구현 예정 또는 미입력';
    }
    return text;
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
                          '보노와 함께하는 CBT',
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
                      onPressed: _stepIndex == 0 ? null : _goBack,
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
          onChanged: (SituationDraft next) {
            setState(() {
              _situation = next;
            });
          },
        );
      case 1:
        return EmotionStepView(
          situationPrompt: 'llm 생성 상황문장',
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
              ? 'llm 생성 자동적 사고 문장'
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
              ? 'llm 생성 인지왜곡 설명'
              : '지금 보이는 인지왜곡은 ${_distortion.selectedDistortions.join(', ')} 이야.',
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
          message: '여기까지 정말 잘 왔어. 지금까지 이야기한 내용을 내가 한 번 정리해봤어.',
        ),
        const SizedBox(height: 16),
        Text('요약', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _SummaryCard(
          title: '상황',
          content: '원문: ${_fallbackText(_situation.rawSituation)}\n'
              '보노 응답: LLM 미구현으로 인해 비워둠',
        ),
        _SummaryCard(
          title: '감정',
          content: emotionLines.isEmpty ? '미입력' : emotionLines.join('\n'),
        ),
        _SummaryCard(
          title: '자동적 사고',
          content: '1차 선택: ${_fallbackText(_automaticThought.starterChoice)}\n'
              '메모: ${_fallbackText(_automaticThought.userNotes)}\n'
              '최종: ${_fallbackText(_automaticThought.selectedThought)}',
        ),
        _SummaryCard(
          title: '인지왜곡',
          content: '선택: ${_distortion.selectedDistortions.isEmpty ? '미선택' : _distortion.selectedDistortions.join(', ')}\n'
              '보노 설명: LLM 미구현으로 인해 비워둠\n'
              '내 이유: ${_fallbackText(_distortion.userReason)}',
        ),
        _SummaryCard(
          title: '개입',
          content: '회복 도구: LLM 미구현으로 인해 비워둠\n'
              '재구성: ${_fallbackText(_intervention.reframe)}\n'
              '행동계획: ${_fallbackText(_intervention.actionPlan)}',
        ),
      ],
    );
  }

  String _emotionSummary() {
    if (_emotion.selectedMajors.isEmpty) {
      return 'llm 생성 감정 정리 문장';
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
