import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/infrastructure/vowel_kana_catalog.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/kana_reading_screen.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/widgets/kana_button.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio_player.dart';

class FakeKanaAudioPlayer implements KanaAudioPlayer {
  final List<KanaAudio> playedAudios = [];

  var stopCallCount = 0;
  var disposeCallCount = 0;

  @override
  Future<void> play(KanaAudio audio) async {
    playedAudios.add(audio);
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

  testWidgets('invokes the continue action', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();
    var continueRequested = false;

    await tester.pumpWidget(
      buildSubject(
        audioPlayer: audioPlayer,
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

    expect(audioPlayer.playedAudios, [KanaAudio.a]);

    expect(audioPlayer.playedAudios.single.assetPath, 'audio/kana/a.m4a');
  });
  testWidgets('plays the most recently selected kana', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.tap(find.byKey(KanaButton.keyFor('hiragana-a')));

    await tester.pump();

    await tester.tap(find.byKey(KanaButton.keyFor('hiragana-i')));

    await tester.pump();

    expect(audioPlayer.playedAudios, [KanaAudio.a, KanaAudio.i]);
  });
  testWidgets('disposes the audio player when the screen is removed', (
    tester,
  ) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(buildSubject(audioPlayer: audioPlayer));

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    await tester.pump();

    expect(audioPlayer.disposeCallCount, 1);
  });
}
