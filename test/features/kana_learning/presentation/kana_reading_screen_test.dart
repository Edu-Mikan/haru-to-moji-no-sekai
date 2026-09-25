import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/infrastructure/vowel_kana_catalog.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/kana_reading_screen.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/widgets/kana_button.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio_player.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana_lessons.dart';

class FakeKanaAudioPlayer implements KanaAudioPlayer {
  final List<String> preloadedAssets = [];
  final List<String> playedAssets = [];

  var stopCallCount = 0;
  var disposeCallCount = 0;

  @override
  Future<void> preload(Iterable<String> assetPaths) async {
    preloadedAssets.addAll(assetPaths);
  }

  @override
  Future<void> playAsset(String assetPath) async {
    playedAssets.add(assetPath);
  }

  @override
  Future<void> stop() async {
    stopCallCount++;
  }

  @override
  Future<void> dispose() async {
    disposeCallCount++;
  }
}

void main() {
  const catalog = VowelKanaCatalog();

  Widget buildSubject({
    required KanaAudioPlayer audioPlayer,
    ValueChanged<Kana>? onKanaSelected,
    VoidCallback? onContinue,
  }) {
    return MaterialApp(
      home: KanaReadingScreen(
        lesson: KanaLessons.aiueo,
        catalog: catalog,
        audioPlayer: audioPlayer,
        onKanaSelected: onKanaSelected,
        onContinue: onContinue,
      ),
    );
  }

  testWidgets('shows the five hiragana vowel buttons', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();
    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    for (final kana in catalog.all) {
      expect(find.byKey(KanaButton.keyFor(kana.id)), findsOneWidget);

      expect(find.text(kana.character), findsOneWidget);
    }
  });

  testWidgets('notifies the selected kana', (tester) async {
    Kana? selectedKana;
    final audioPlayer = FakeKanaAudioPlayer();
    await tester.pumpWidget(
      buildSubject(
        audioPlayer: audioPlayer,
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

  testWidgets('fits on a phone-sized screen', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(KanaReadingScreen.screenKey), findsOneWidget);
  });

  testWidgets('fits on a wide browser screen', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(KanaReadingScreen.screenKey), findsOneWidget);
  });

  testWidgets('plays the audio associated with the selected kana', (
    tester,
  ) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.tap(find.byKey(KanaButton.keyFor('hiragana-a')));

    await tester.pump();

    expect(audioPlayer.playedAssets, ['audio/kana/a.wav']);
  });
  testWidgets('plays the most recently selected kana', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.tap(find.byKey(KanaButton.keyFor('hiragana-a')));

    await tester.pump();

    await tester.tap(find.byKey(KanaButton.keyFor('hiragana-i')));

    await tester.pump();

    expect(audioPlayer.playedAssets, ['audio/kana/a.wav', 'audio/kana/i.wav']);
  });
  testWidgets('does not dispose the shared audio player when removed', (
    tester,
  ) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    await tester.pump();

    expect(audioPlayer.disposeCallCount, 0);
  });

  testWidgets('shows the illustrated reading background', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    expect(find.byKey(KanaReadingScreen.backgroundKey), findsOneWidget);
  });

  testWidgets('shows the button for returning to the map', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    expect(find.byKey(KanaReadingScreen.backButtonKey), findsOneWidget);
  });
}
