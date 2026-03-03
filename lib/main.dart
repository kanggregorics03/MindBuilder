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
  final Map<String, List<String>> _detailBySituation = <String, List<String>>{
    '일/학업': <String>[
      '실수',
      '성과 압박',
      '마감 스트레스',
      '집중 안 됨',
      '갈등',
      '비교',
    ],
    '인간관계': <String>[
      '가족',
      '연인',
      '친구',
      '직장 동료',
      '오해',
      '거절/거리감',
    ],
    '건강': <String>[
      '수면',
      '피로',
      '통증',
      '몸 상태 저하',
      '식습관',
      '운동 부족',
    ],
    '진로/미래': <String>[
      '불확실성',
      '결정 어려움',
      '경제 걱정',
      '목표 혼란',
      '실패 두려움',
      '자기효능감 저하',
    ],
  };

  final Map<String, List<String>> _minorEmotionByMajor =
      <String, List<String>>{
    '불안': <String>[
      '초조함',
      '긴장됨',
      '압박감',
      '걱정',
      '불길함',
      '안절부절',
      '예민함',
      '신경과민',
      '조마조마함',
      '두려움',
      '당혹감',
      '불확실함',
    ],
    '슬픔': <String>[
      '우울함',
      '외로움',
      '허무함',
      '상실감',
      '무기력',
      '침울함',
      '서운함',
      '공허함',
      '낙담',
      '의욕 저하',
      '눈물남',
      '쓸쓸함',
    ],
    '분노': <String>[
      '짜증',
      '답답함',
      '억울함',
      '분함',
      '화남',
      '원망',
      '불만',
      '예민반응',
      '경계심',
      '적대감',
      '폭발 직전',
      '실망 분노',
    ],
    '수치심': <String>[
      '창피함',
      '자책',
      '죄책감',
      '위축감',
      '부끄러움',
      '자기혐오',
      '부담감',
      '눈치 봄',
      '자신감 하락',
      '실수 공포',
      '평가 두려움',
      '무가치감',
    ],
    '기쁨': <String>[
      '안도감',
      '만족감',
      '편안함',
      '뿌듯함',
      '감사함',
      '희망감',
      '설렘',
      '자신감',
      '안정감',
      '충만함',
      '유쾌함',
      '몰입감',
    ],
    '사랑/애정': <String>[
      '따뜻함',
      '친밀감',
      '애착',
      '신뢰감',
      '고마움',
      '배려하고 싶음',
      '보고 싶음',
      '소중함',
      '보호 본능',
      '유대감',
      '공감됨',
      '마음 열림',
    ],
    '놀람': <String>[
      '당황',
      '어리둥절',
      '충격',
      '멍함',
      '혼란',
      '예상 밖',
      '의아함',
      '현실감 없음',
      '급격한 긴장',
      '경악',
      '낯섦',
      '주의 집중',
    ],
    '혐오/거부감': <String>[
      '꺼림칙함',
      '역겨움',
      '거부감',
      '불쾌함',
      '기피하고 싶음',
      '찝찝함',
      '불편함',
      '불결감',
      '소름',
      '반감',
      '거리두고 싶음',
      '싫증',
    ],
  };

  final List<_StepQuestion> _steps = <_StepQuestion>[
    const _StepQuestion(
      title: '무슨 일이 있었나요?',
      options: <String>['일/학업', '인간관계', '건강', '진로/미래'],
    ),
    const _StepQuestion(title: '더 자세히 고르세요. (소분류)', options: <String>[]),
    const _StepQuestion(
      title: '대감정을 여러 개 선택하세요.',
      options: <String>[
        '불안',
        '슬픔',
        '분노',
        '수치심',
        '기쁨',
        '사랑/애정',
        '놀람',
        '혐오/거부감',
      ],
    ),
    const _StepQuestion(title: '소감정을 여러 개 선택하세요.', options: <String>[]),
    const _StepQuestion(
      title: '현재 감정 강도는 몇 %인가요?',
      options: <String>['10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'],
    ),
    const _StepQuestion(
      title: '목표 감정 강도는 몇 %인가요?',
      options: <String>['10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'],
    ),
  ];

  int _stepIndex = 0;
  String? _selectedSituation;
  String? _selectedDetail;
  final List<String> _selectedMajorEmotions = <String>[];
  final List<String> _selectedMinorEmotions = <String>[];
  int? _currentPercent;
  int? _targetPercent;

  bool get _isDone => _stepIndex >= _steps.length;
  bool get _isEmotionStep => _stepIndex == 2 || _stepIndex == 3;

  _StepQuestion get _currentQuestion {
    if (_stepIndex == 1) {
      return _StepQuestion(
        title: _steps[1].title,
        options: _detailBySituation[_selectedSituation] ?? const <String>['기타'],
      );
    }
    if (_stepIndex == 3) {
      final Set<String> options = <String>{};
      for (final String major in _selectedMajorEmotions) {
        options.addAll(_minorEmotionByMajor[major] ?? const <String>[]);
      }
      return _StepQuestion(
        title: _steps[3].title,
        options: options.isEmpty ? const <String>['복합감정'] : options.toList(),
      );
    }
    if (_stepIndex == 5) {
      final int current = _currentPercent ?? 0;
      final List<String> validTargets = _steps[5].options
          .where((String value) => _percent(value) <= current)
          .toList();
      return _StepQuestion(
        title: _steps[5].title,
        options: validTargets.isEmpty ? const <String>['10%'] : validTargets,
      );
    }
    return _steps[_stepIndex];
  }

  bool get _canGoBack => _isDone || _stepIndex > 0;

  bool get _canGoNextEmotionStep {
    if (_stepIndex == 2) {
      return _selectedMajorEmotions.isNotEmpty;
    }
    if (_stepIndex == 3) {
      return _selectedMinorEmotions.isNotEmpty;
    }
    return false;
  }

  void _goBack() {
    if (!_canGoBack) {
      return;
    }

    setState(() {
      if (_isDone) {
        _stepIndex = _steps.length - 1;
        return;
      }
      _stepIndex = _stepIndex - 1;
    });
  }

  void _selectOption(String value) {
    if (_isDone) {
      return;
    }

    if (_isEmotionStep) {
      _toggleEmotionSelection(value);
      return;
    }

    setState(() {
      switch (_stepIndex) {
        case 0:
          final bool situationChanged = _selectedSituation != value;
          _selectedSituation = value;
          if (situationChanged) {
            _selectedDetail = null;
          }
          break;
        case 1:
          _selectedDetail = value;
          break;
        case 4:
          _currentPercent = _percent(value);
          _targetPercent = null;
          break;
        case 5:
          _targetPercent = _percent(value);
          break;
      }
      _stepIndex = _stepIndex + 1;
    });
  }

  void _toggleEmotionSelection(String value) {
    setState(() {
      if (_stepIndex == 2) {
        if (_selectedMajorEmotions.contains(value)) {
          _selectedMajorEmotions.remove(value);
        } else {
          _selectedMajorEmotions.add(value);
        }

        final Set<String> validMinor = <String>{};
        for (final String major in _selectedMajorEmotions) {
          validMinor.addAll(_minorEmotionByMajor[major] ?? const <String>[]);
        }
        _selectedMinorEmotions.removeWhere(
          (String minor) => !validMinor.contains(minor),
        );
      } else if (_stepIndex == 3) {
        if (_selectedMinorEmotions.contains(value)) {
          _selectedMinorEmotions.remove(value);
        } else {
          _selectedMinorEmotions.add(value);
        }
      }
    });
  }

  void _goNextEmotionStep() {
    if (!_canGoNextEmotionStep) {
      return;
    }
    setState(() {
      _stepIndex = _stepIndex + 1;
    });
  }

  void _restart() {
    setState(() {
      _stepIndex = 0;
      _selectedSituation = null;
      _selectedDetail = null;
      _selectedMajorEmotions.clear();
      _selectedMinorEmotions.clear();
      _currentPercent = null;
      _targetPercent = null;
    });
  }

  int _percent(String input) {
    return int.tryParse(input.replaceAll('%', '')) ?? 0;
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
                          border: Border.all(
                            color: const Color(0xFF126E82),
                            width: 3,
                          ),
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.45,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = question.options[index];
                  final bool selected = _stepIndex == 2
                      ? _selectedMajorEmotions.contains(option)
                      : (_stepIndex == 3 &&
                            _selectedMinorEmotions.contains(option));

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selected
                              ? const Color(0xFF126E82)
                              : null,
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
                            Flexible(
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isEmotionStep)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canGoNextEmotionStep ? _goNextEmotionStep : null,
                  child: const Text('다음'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _summaryText() {
    final String major = _selectedMajorEmotions.isEmpty
        ? '-'
        : _selectedMajorEmotions.join(', ');
    final String minor = _selectedMinorEmotions.isEmpty
        ? '-'
        : _selectedMinorEmotions.join(', ');

    return '입력 완료\n'
        '상황: ${_selectedSituation ?? '-'} / ${_selectedDetail ?? '-'}\n'
        '감정: $major / $minor\n'
        '현재: ${_currentPercent ?? 0}% -> 목표: ${_targetPercent ?? 0}%';
  }
}

class _StepQuestion {
  const _StepQuestion({required this.title, required this.options});

  final String title;
  final List<String> options;
}
