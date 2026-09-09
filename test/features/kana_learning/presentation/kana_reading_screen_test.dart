import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/infrastructure/vowel_kana_catalog.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/kana_reading_screen.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/widgets/kana_button.dart';

void main() {
  const catalog = VowelKanaCatalog();

  Widget buildSubject({
    ValueChanged<Kana>? onKanaSelected,
    VoidCallback? onContinue,
  }) {
    return MaterialApp(
      home: KanaReadingScreen(
        catalog: catalog,
        onKanaSelected: onKanaSelected,
        onContinue: onContinue,
      ),
    );
  }

  testWidgets('shows the five hiragana vowel buttons', (tester) async {
    await tester.pumpWidget(buildSubject());

    for (final kana in catalog.all) {
      expect(find.byKey(KanaButton.keyFor(kana.id)), findsOneWidget);

      expect(find.text(kana.character), findsOneWidget);
    }
  });

  testWidgets('notifies the selected kana', (tester) async {
    Kana? selectedKana;

    await tester.pumpWidget(
      buildSubject(
        onKanaSelected: (kana) {
          selectedKana = kana;
        },
      ),
    );

    await tester.tap(find.byKey(KanaButton.keyFor('hiragana-u')));

    await tester.pumpAndSettle();

    expect(selectedKana?.character, 'う');
    expect(selectedKana?.reading, 'u');

    expect(find.byKey(KanaReadingScreen.selectedKanaKey), findsOneWidget);
  });

  testWidgets('invokes the continue action', (tester) async {
    var continueRequested = false;

    await tester.pumpWidget(
      buildSubject(
        onContinue: () {
          continueRequested = true;
        },
      ),
    );

    final continueButton = find.byKey(KanaReadingScreen.continueButtonKey);

    await tester.ensureVisible(continueButton);
    await tester.pumpAndSettle();

    await tester.tap(continueButton);
    await tester.pump();

    expect(continueRequested, isTrue);
  });

  testWidgets('fits on a phone-sized screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(KanaReadingScreen.screenKey), findsOneWidget);
  });

  testWidgets('fits on a wide browser screen', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(KanaReadingScreen.screenKey), findsOneWidget);
  });
}
