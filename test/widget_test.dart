import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_builder/flow/cbt_session.dart';
import 'package:mind_builder/features/situation.dart';
import 'package:mind_builder/services/automatic_thought_service.dart';
import 'package:mind_builder/services/situation_service.dart';

class FakeSituationService extends SituationService {
  const FakeSituationService();

  @override
  Future<SituationRefineResult> refineSituation(String rawSituation) async {
    return SituationRefineResult(
      original: rawSituation,
      feedback: '친구의 행동을 구체적으로 관찰해 보는 것이 도움이 될 수 있어요.',
      reframed: '친구가 나에게 불편해 보이는 행동을 보인 것 같아요.',
    );
  }
}

class FakeAutomaticThoughtService extends AutomaticThoughtService {
  FakeAutomaticThoughtService();

  String? lastSituation;
  String? lastOriginalSituation;
  List<String> lastEmotions = const <String>[];

  @override
  Future<List<String>> generateAutomaticThoughts({
    required String situation,
    String originalSituation = '',
    List<String> emotions = const <String>[],
  }) async {
    lastSituation = situation;
    lastOriginalSituation = originalSituation;
    lastEmotions = List<String>.from(emotions);

    return const <String>[
      '친구가 나를 싫어하게 된 것 같아.',
      '내가 뭔가 잘못해서 어색해진 것 같아.',
      '앞으로 관계가 더 멀어질 것 같아.',
      '내가 별로 중요하지 않은 사람처럼 느껴질 거야.',
    ];
  }
}

void main() {
  testWidgets('uses original situation when user chooses original copy', (
    WidgetTester tester,
  ) async {
    final FakeAutomaticThoughtService automaticThoughtService =
        FakeAutomaticThoughtService();

    tester.view.physicalSize = const Size(1440, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: CbtSessionScreen(
          situationService: FakeSituationService(),
          automaticThoughtService: automaticThoughtService,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '친구가 나를 싫어하는 것 같아');
    await tester.pumpAndSettle();
    await tester.tap(find.text('정리하기'));
    await tester.pumpAndSettle();

    expect(find.text('1 / 5 단계'), findsOneWidget);
    expect(find.text('피드백 반영해서 다시 쓰기'), findsOneWidget);
    expect(find.text('처음 문장으로 진행'), findsOneWidget);
    expect(find.text('다듬은 문장으로 진행'), findsOneWidget);
    expect(find.text('피드백'), findsOneWidget);
    expect(find.text('처음 문장'), findsOneWidget);
    expect(find.text('다듬은 문장'), findsWidgets);
    expect(find.text('원래 의미'), findsNothing);
    expect(find.text('이어갈 문장 선택'), findsNothing);
    expect(find.text('친구의 행동을 구체적으로 관찰해 보는 것이 도움이 될 수 있어요.'), findsOneWidget);
    expect(find.text('친구가 나에게 불편해 보이는 행동을 보인 것 같아요.'), findsOneWidget);

    await tester.tap(find.text('처음 문장으로 진행'));
    await tester.pumpAndSettle();
    expect(find.text('2 / 5 단계'), findsOneWidget);

    await tester.tap(find.text('불안'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('걱정'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.text('3 / 5 단계'), findsOneWidget);
    expect(
      automaticThoughtService.lastSituation,
      '친구가 나를 싫어하는 것 같아',
    );
    expect(
      automaticThoughtService.lastOriginalSituation,
      '친구가 나를 싫어하는 것 같아',
    );
    expect(automaticThoughtService.lastEmotions, <String>['불안(걱정)']);
    expect(find.text('추천 자동적 사고'), findsOneWidget);
    expect(find.text('친구가 나를 싫어하게 된 것 같아.'), findsOneWidget);
    expect(find.text('내가 뭔가 잘못해서 어색해진 것 같아.'), findsOneWidget);
    expect(find.text('직접 작성'), findsOneWidget);

    await tester.tap(find.text('친구가 나를 싫어하게 된 것 같아.'));
    await tester.pumpAndSettle();
    expect(find.text('선택한 자동적 사고'), findsOneWidget);
    expect(find.text('수정'), findsOneWidget);
    expect(find.text('삭제'), findsOneWidget);
    expect(find.text('다음'), findsOneWidget);
  });

  testWidgets('uses reframed situation when user chooses reframed copy', (
    WidgetTester tester,
  ) async {
    final FakeAutomaticThoughtService automaticThoughtService =
        FakeAutomaticThoughtService();

    tester.view.physicalSize = const Size(1440, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: CbtSessionScreen(
          situationService: const FakeSituationService(),
          automaticThoughtService: automaticThoughtService,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '친구가 나를 싫어하는 것 같아');
    await tester.pumpAndSettle();
    await tester.tap(find.text('정리하기'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('다듬은 문장으로 진행'));
    await tester.tap(find.text('다듬은 문장으로 진행'));
    await tester.pumpAndSettle();

    expect(find.text('2 / 5 단계'), findsOneWidget);
    expect(find.textContaining('친구가 나에게 불편해 보이는 행동을 보인 것 같아요.'), findsOneWidget);

    await tester.tap(find.text('불안'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('걱정'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(
      automaticThoughtService.lastSituation,
      '친구가 나에게 불편해 보이는 행동을 보인 것 같아요.',
    );
    expect(
      automaticThoughtService.lastOriginalSituation,
      '친구가 나를 싫어하는 것 같아',
    );
  });
}
