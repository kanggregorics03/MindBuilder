import 'package:flutter/material.dart';

import 'flow/cbt_session.dart';
import 'features/situation.dart';
import 'services/automatic_thought_service.dart';
import 'services/situation_service.dart';

class FakeSituationService extends SituationService {
  const FakeSituationService();

  @override
  Future<SituationRefineResult> refineSituation(String rawSituation) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return SituationRefineResult(
      original: rawSituation.trim().isEmpty
          ? '입력한 내용이 없어요.'
          : rawSituation.trim(),
      feedback: '친구의 행동을 구체적으로 관찰해 보는 것이 도움이 될 수 있어요.',
      reframed: '친구가 나에게 불편해 보이는 행동을 보인 것 같아요.',
    );
  }
}

class FakeAutomaticThoughtService extends AutomaticThoughtService {
  const FakeAutomaticThoughtService();

  @override
  Future<List<String>> generateAutomaticThoughts({
    required String situation,
    String originalSituation = '',
    List<String> emotions = const <String>[],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const <String>[
      '친구가 나를 싫어하게 된 것 같아.',
      '내가 뭔가 잘못해서 어색해진 것 같아.',
      '앞으로 관계가 더 멀어질 것 같아.',
      '내가 별로 중요하지 않은 사람처럼 느껴질 거야.',
    ];
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FakeMindBuilderApp());
}

class FakeMindBuilderApp extends StatelessWidget {
  const FakeMindBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mind Builder Fake',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF126E82)),
      ),
      home: const CbtSessionScreen(
        situationService: FakeSituationService(),
        automaticThoughtService: FakeAutomaticThoughtService(),
      ),
    );
  }
}
