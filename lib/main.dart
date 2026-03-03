import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MindBuilderAkinatorApp());
}

class MindBuilderAkinatorApp extends StatelessWidget {
  const MindBuilderAkinatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mind Builder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF126E82)),
      ),
      home: const AkinatorStyleScreen(),
    );
  }
}

class AkinatorStyleScreen extends StatefulWidget {
  const AkinatorStyleScreen({super.key});

  @override
  State<AkinatorStyleScreen> createState() => _AkinatorStyleScreenState();
}

class _AkinatorStyleScreenState extends State<AkinatorStyleScreen> {
  final TextEditingController _situationContextController =
      TextEditingController();
  final Random _random = Random();
  String _situationHint = '';

  final Map<String, List<String>> _detailBySituation = <String, List<String>>{
    '일/학업': <String>[
      '평가/검증',
      '마감/데드라인',
      '업무량/과부하',
      '협업/프로젝트 이슈',
      '성과/완벽주의',
      '시간관리/미루기',
      '번아웃/회복 필요',
    ],
    '대인관계': <String>[
      '갈등/다툼',
      '불편한 대화/피드백',
      '거리감/소원함',
      '경계 침해/간섭',
      '역할/기대 압박',
      '모임/관계 피로감',
      '양육/간병 부담',
    ],
    '건강/몸': <String>[
      '통증/증상/컨디션',
      '검사/진단 대기',
      '수면/피로',
      '생애주기 변화',
      '체중/식습관/외모',
      '습관/중독 관리',
      '만성질환 관리',
    ],
    '생활/집': <String>[
      '집안일/가사/정리',
      '주거/이사/집 문제',
      '소음/환경 스트레스',
      '출퇴근/이동/교통',
      '생활 루틴 붕괴',
      '여행/계획 스트레스',
      '일상 행정 업무',
    ],
    '돈/재정': <String>[
      '지출 통제/후회',
      '빚/대출 상환',
      '수입/고정비 부담',
      '미래 재정 불안',
      '금전적 의사결정',
      '타인과의 금전 갈등',
    ],
    '미래/진로': <String>[
      '취업/이직 준비',
      '진로 방향성',
      '결과 대기/불확실성',
      '실패/불합격 두려움',
      '역량 의심/자존감',
      '장기 목표 압박',
    ],
    '사회/환경': <String>[
      '뉴스/정치/시사',
      'SNS/비교/박탈감',
      '공공장소/안전 불안',
      '행정/법적 분쟁',
      '차별/편견 경험',
      '서비스/민원 마찰',
    ],
    '상실/트라우마': <String>[
      '사별/애도',
      '트라우마 회상',
      '왕따/괴롭힘 기억',
      '사건사고 목격',
      '안전감 붕괴/과각성',
      '경조사/의례 부담',
    ],
  };

  final Map<String, List<String>> _minorEmotionByMajor =
      <String, List<String>>{
    '슬픔': <String>['울적함', '우울', '침울', '불행'],
    '불안': <String>['걱정', '공포심', '과민함', '겁이 남'],
    '죄의식': <String>['가책', '불쾌감', '부끄러움'],
    '열등감': <String>['무가치감', '부적절감', '결핍감', '무능감'],
    '외로움': <String>['사랑받지 못함', '환영받지 못함', '거절감', '고독감', '버림받음'],
    '창피함': <String>['바보 같은 기분', '수치심', '시선 의식'],
    '절망': <String>['낙담', '비관', '좌절감'],
    '답답함': <String>['갑갑함', '낭패감', '패배감'],
    '화': <String>['몹시 화가 남', '분개', '언짢음', '짜증 남', '속상함', '격분'],
  };

  final List<_StepQuestion> _steps = <_StepQuestion>[
    const _StepQuestion(
      title: '무슨 일이 있었나요?',
      options: <String>[
        '일/학업',
        '대인관계',
        '건강/몸',
        '생활/집',
        '돈/재정',
        '미래/진로',
        '사회/환경',
        '상실/트라우마',
      ],
    ),
    const _StepQuestion(title: '더 자세히 고르세요. (소분류)', options: <String>[]),
    const _StepQuestion(
      title: '그때의 구체적인 상황을 적어주세요.',
      options: <String>[],
    ),
    const _StepQuestion(
      title: '대감정을 선택하세요. (여러 개 가능)',
      options: <String>[
        '슬픔',
        '불안',
        '죄의식',
        '열등감',
        '외로움',
        '창피함',
        '절망',
        '답답함',
        '화',
      ],
    ),
    const _StepQuestion(title: '소감정을 선택하세요.', options: <String>[]),
    const _StepQuestion(title: '대감정별 감정 감도와 목표 감도를 조절하세요.', options: <String>[]),
  ];

  int _stepIndex = 0;
  String? _selectedSituation;
  String? _selectedDetail;
  String _situationContext = '';
  final List<String> _selectedMajorEmotions = <String>[];
  final Map<String, Set<String>> _selectedMinorByMajor = <String, Set<String>>{};
  final Map<String, double> _intensityByMajor = <String, double>{};
  final Map<String, double> _targetIntensityByMajor = <String, double>{};
  String? _activeMajorEmotion;

  bool get _isDone => _stepIndex >= _steps.length;
  bool get _isSituationContextStep => _stepIndex == 2;
  bool get _isMajorEmotionStep => _stepIndex == 3;
  bool get _isMinorEmotionStep => _stepIndex == 4;
  bool get _isIntensityStep => _stepIndex == 5;
  bool get _canGoBack => _isDone || _stepIndex > 0;

  _StepQuestion get _currentQuestion {
    if (_stepIndex == 1) {
      return _StepQuestion(
        title: _steps[1].title,
        options: _detailBySituation[_selectedSituation] ?? const <String>['기타'],
      );
    }
    if (_isMinorEmotionStep) {
      final String major = _activeMajorEmotion ?? '';
      return _StepQuestion(
        title: '$major 소감정을 선택하세요.',
        options: _minorEmotionByMajor[major] ?? const <String>[],
      );
    }
    return _steps[_stepIndex];
  }

  bool get _canFinishEmotionSelection {
    if (_selectedMajorEmotions.isEmpty) {
      return false;
    }
    return _selectedMajorEmotions.every((String major) {
      final Set<String>? selected = _selectedMinorByMajor[major];
      return selected != null && selected.isNotEmpty;
    });
  }

  void _goBack() {
    if (!_canGoBack) {
      return;
    }
    setState(() {
      if (_isDone) {
        _stepIndex = _steps.length - 1;
      } else if (_isIntensityStep) {
        _stepIndex = 3;
      } else if (_isMinorEmotionStep) {
        _stepIndex = 3;
        _activeMajorEmotion = null;
      } else {
        _stepIndex = _stepIndex - 1;
      }
    });
  }

  void _selectOption(String value) {
    if (_isDone) {
      return;
    }
    if (_isMajorEmotionStep) {
      _openMinorEmotionStep(value);
      return;
    }
    if (_isMinorEmotionStep) {
      _toggleMinorEmotion(value);
      return;
    }
    if (_isSituationContextStep) {
      return;
    }

    setState(() {
      switch (_stepIndex) {
        case 0:
          final bool situationChanged = _selectedSituation != value;
          _selectedSituation = value;
          if (situationChanged) {
            _selectedDetail = null;
            _situationHint = '';
          }
          break;
        case 1:
          _selectedDetail = value;
          _situationHint = _buildRandomSituationHint(value);
          _situationContextController.clear();
          _situationContext = '';
          break;
      }
      _stepIndex = _stepIndex + 1;
    });
  }

  void _openMinorEmotionStep(String value) {
    setState(() {
      if (!_selectedMajorEmotions.contains(value)) {
        _selectedMajorEmotions.add(value);
      }
      _activeMajorEmotion = value;
      _stepIndex = 4;
    });
  }

  void _toggleMinorEmotion(String minorEmotion) {
    final String? major = _activeMajorEmotion;
    if (major == null) {
      return;
    }
    setState(() {
      final Set<String> selected = Set<String>.from(
        _selectedMinorByMajor[major] ?? <String>{},
      );
      if (selected.contains(minorEmotion)) {
        selected.remove(minorEmotion);
      } else {
        selected.add(minorEmotion);
      }
      if (selected.isEmpty) {
        _selectedMinorByMajor.remove(major);
      } else {
        _selectedMinorByMajor[major] = selected;
      }
    });
  }

  void _goNextFromSituationContext() {
    final String value = _situationContextController.text.trim();
    if (value.isEmpty) {
      return;
    }
    setState(() {
      _situationContext = value;
      _stepIndex = 3;
    });
  }

  String _buildRandomSituationHint(String detail) {
    final List<String> templates = <String>[
      '예) $detail 상황에서 누가, 언제, 무엇을 말/행동했는지 적어보세요.',
      '예) $detail 때문에 가장 힘들었던 순간을 1~2문장으로 적어보세요.',
      '예) $detail 직후 떠오른 생각과 몸 반응을 함께 적어보세요.',
    ];
    return templates[_random.nextInt(templates.length)];
  }

  void _finishEmotionSelection() {
    if (!_canFinishEmotionSelection) {
      return;
    }
    setState(() {
      for (final String major in _selectedMajorEmotions) {
        final double current = _intensityByMajor.putIfAbsent(major, () => 50);
        _targetIntensityByMajor.putIfAbsent(major, () => current);
      }
      _stepIndex = 5;
      _activeMajorEmotion = null;
    });
  }

  void _setIntensity(String major, double value) {
    setState(() {
      _intensityByMajor[major] = value;
      final double target = _targetIntensityByMajor[major] ?? value;
      if (target > value) {
        _targetIntensityByMajor[major] = value;
      }
    });
  }

  void _setTargetIntensity(String major, double value) {
    setState(() {
      final double current = _intensityByMajor[major] ?? 100;
      _targetIntensityByMajor[major] = value > current ? current : value;
    });
  }

  void _finishIntensitySelection() {
    setState(() {
      _stepIndex = _steps.length;
    });
  }

  void _backToMajorEmotionStep() {
    setState(() {
      _stepIndex = 3;
      _activeMajorEmotion = null;
    });
  }

  void _restart() {
    setState(() {
      _stepIndex = 0;
      _selectedSituation = null;
      _selectedDetail = null;
      _situationContext = '';
      _situationHint = '';
      _situationContextController.clear();
      _selectedMajorEmotions.clear();
      _selectedMinorByMajor.clear();
      _intensityByMajor.clear();
      _targetIntensityByMajor.clear();
      _activeMajorEmotion = null;
    });
  }

  @override
  void dispose() {
    _situationContextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _StepQuestion question = _isDone
        ? const _StepQuestion(title: '입력이 완료되었습니다.', options: <String>[])
        : _currentQuestion;
    final int total = _steps.length;
    final int current = _isDone ? total : (_stepIndex + 1).clamp(1, total);
    final double progress = _isDone ? 1 : _stepIndex / total;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFEDF7FA), Color(0xFFD6EEF5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: _canGoBack ? _goBack : null,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      tooltip: '뒤로 가기',
                    ),
                    const Text(
                      'Mind Builder',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text('Q$current/$total'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(value: progress),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF126E82), width: 3),
                          color: Colors.white,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'bono.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.person, size: 60),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '보노',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _isDone ? _summaryText() : question.title,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isDone) _buildOptionPanel(question),
              if (_isDone)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _restart,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('다시 시작'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionPanel(_StepQuestion question) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.52),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _isSituationContextStep
                  ? _buildSituationContextPanel()
                  : (_isMinorEmotionStep
                        ? _buildMinorEmotionList(question)
                        : (_isIntensityStep
                              ? _buildIntensityPanel()
                              : _buildDefaultOptionList(question))),
            ),
            if (_isSituationContextStep)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _situationContextController.text.trim().isEmpty
                      ? null
                      : _goNextFromSituationContext,
                  child: const Text('다음'),
                ),
              ),
            if (_isMinorEmotionStep)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _backToMajorEmotionStep,
                  child: const Text('대감정으로 돌아가기'),
                ),
              ),
            if (_isMajorEmotionStep)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canFinishEmotionSelection ? _finishEmotionSelection : null,
                  child: const Text('감정 선택 완료'),
                ),
              ),
            if (_isIntensityStep)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finishIntensitySelection,
                  child: const Text('감도 선택 완료'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSituationContextPanel() {
    final String hint = _situationHint.isEmpty
        ? '예) 지금 선택한 상황을 구체적으로 적어주세요.'
        : _situationHint;

    return ListView(
      children: <Widget>[
        TextField(
          controller: _situationContextController,
          minLines: 5,
          maxLines: 8,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultOptionList(_StepQuestion question) {
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (BuildContext context, int index) {
        final String option = question.options[index];
        final bool selected = _isMajorEmotionStep
            ? _selectedMajorEmotions.contains(option)
            : false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selected ? const Color(0xFF126E82) : null,
                foregroundColor: selected ? Colors.white : null,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _selectOption(option),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (selected) ...<Widget>[
                    const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Flexible(child: Text(option, textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMinorEmotionList(_StepQuestion question) {
    final String major = _activeMajorEmotion ?? '';
    if (major.isEmpty) {
      return const Center(child: Text('대감정을 먼저 선택해주세요.'));
    }

    final Set<String> selected = _selectedMinorByMajor[major] ?? <String>{};
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (BuildContext context, int index) {
        final String option = question.options[index];
        final bool isSelected = selected.contains(option);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? const Color(0xFF126E82) : null,
                foregroundColor: isSelected ? Colors.white : null,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _toggleMinorEmotion(option),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (isSelected) ...<Widget>[
                    const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Flexible(child: Text(option, textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntensityPanel() {
    if (_selectedMajorEmotions.isEmpty) {
      return const Center(child: Text('대감정이 없습니다.'));
    }

    return ListView.separated(
      itemCount: _selectedMajorEmotions.length,
      separatorBuilder: (_, int index) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final String major = _selectedMajorEmotions[index];
        final List<String> minors = (_selectedMinorByMajor[major] ?? <String>{}).toList();
        final double current = _intensityByMajor[major] ?? 50;
        final double target = _targetIntensityByMajor[major] ?? current;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  major,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text('소감정: ${minors.isEmpty ? '-' : minors.join(', ')}'),
                const SizedBox(height: 10),
                Text('현재 감도: ${current.round()}%'),
                Slider(
                  value: current,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '${current.round()}%',
                  onChanged: (double next) => _setIntensity(major, next),
                ),
                const SizedBox(height: 4),
                Text('목표 감도: ${target.round()}%'),
                Slider(
                  value: target,
                  min: 0,
                  max: current,
                  divisions: current.round() == 0 ? 1 : current.round(),
                  label: '${target.round()}%',
                  onChanged: (double next) => _setTargetIntensity(major, next),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _summaryText() {
    final String major = _selectedMajorEmotions.isEmpty
        ? '-'
        : _selectedMajorEmotions.join(', ');

    final List<String> emotionSummary = _selectedMajorEmotions.map((String majorKey) {
      final Set<String> minors = _selectedMinorByMajor[majorKey] ?? <String>{};
      final int current = (_intensityByMajor[majorKey] ?? 0).round();
      final int target =
          (_targetIntensityByMajor[majorKey] ?? current.toDouble()).round();
      final String minorText = minors.isEmpty ? '-' : minors.join(', ');
      return '$majorKey[$minorText] $current% -> $target%';
    }).toList();

    return '입력 완료\n'
        '상황: ${_selectedSituation ?? '-'} / ${_selectedDetail ?? '-'}\n'
        '구체적 상황: ${_situationContext.isEmpty ? '-' : _situationContext}\n'
        '감정: $major\n'
        '감도: ${emotionSummary.isEmpty ? '-' : emotionSummary.join(' / ')}';
  }
}

class _StepQuestion {
  const _StepQuestion({required this.title, required this.options});

  final String title;
  final List<String> options;
}
