import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/app/app.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';
import 'package:haru_to_moji_no_sekai/features/world_map/presentation/world_map_screen.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio_player.dart';

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
  testWidgets('application starts on the home screen', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(HaruToMojiNoSekaiApp(audioPlayer: audioPlayer));

    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);

    expect(find.byKey(HomeScreen.heroImageKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('navigates from home to the world map', (tester) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(HaruToMojiNoSekaiApp(audioPlayer: audioPlayer));

    await tester.tap(find.byKey(HomeScreen.startButtonKey));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(WorldMapScreen), findsOneWidget);

    expect(find.byKey(WorldMapScreen.screenKey), findsOneWidget);

    expect(find.byKey(WorldMapScreen.gameWidgetKey), findsOneWidget);
  });

  testWidgets('preloads the canonical kana audio when the app starts', (
    tester,
  ) async {
    final audioPlayer = FakeKanaAudioPlayer();

    await tester.pumpWidget(HaruToMojiNoSekaiApp(audioPlayer: audioPlayer));

    await tester.pump();

    expect(audioPlayer.preloadedAssets, [
      'audio/kana/a.wav',
      'audio/kana/i.wav',
      'audio/kana/u.wav',
      'audio/kana/e.wav',
      'audio/kana/o.wav',
    ]);

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
