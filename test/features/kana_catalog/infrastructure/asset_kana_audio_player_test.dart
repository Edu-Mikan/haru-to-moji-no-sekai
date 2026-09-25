import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/infrastructure/asset_kana_audio_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('preloads the five canonical kana audio assets', () async {
    final preloadCalls = <List<String>>[];

    final audioPlayer = AssetKanaAudioPlayer(
      preloader: (assetPaths) async {
        preloadCalls.add(List<String>.from(assetPaths));
      },
    );

    await audioPlayer.preload([
      'audio/kana/a.wav',
      'audio/kana/i.wav',
      'audio/kana/u.wav',
      'audio/kana/e.wav',
      'audio/kana/o.wav',
    ]);

    expect(preloadCalls, hasLength(1));

    expect(preloadCalls.single, [
      'audio/kana/a.wav',
      'audio/kana/i.wav',
      'audio/kana/u.wav',
      'audio/kana/e.wav',
      'audio/kana/o.wav',
    ]);
  });

  test('does not preload the same assets twice', () async {
    final preloadCalls = <List<String>>[];

    final audioPlayer = AssetKanaAudioPlayer(
      preloader: (assetPaths) async {
        preloadCalls.add(List<String>.from(assetPaths));
      },
    );

    const assets = [
      'audio/kana/a.wav',
      'audio/kana/i.wav',
      'audio/kana/u.wav',
      'audio/kana/e.wav',
      'audio/kana/o.wav',
    ];

    await audioPlayer.preload(assets);
    await audioPlayer.preload(assets);

    expect(preloadCalls, hasLength(1));
  });

  test('preloads only assets that are still pending', () async {
    final preloadCalls = <List<String>>[];

    final audioPlayer = AssetKanaAudioPlayer(
      preloader: (assetPaths) async {
        preloadCalls.add(List<String>.from(assetPaths));
      },
    );

    await audioPlayer.preload(['audio/kana/a.wav', 'audio/kana/i.wav']);

    await audioPlayer.preload(['audio/kana/i.wav', 'audio/kana/u.wav']);

    expect(preloadCalls, hasLength(2));

    expect(preloadCalls.first, ['audio/kana/a.wav', 'audio/kana/i.wav']);

    expect(preloadCalls.last, ['audio/kana/u.wav']);
  });

  test('retries assets when preloading fails', () async {
    var attemptCount = 0;

    final audioPlayer = AssetKanaAudioPlayer(
      preloader: (assetPaths) async {
        attemptCount++;

        if (attemptCount == 1) {
          throw StateError('Preload failed');
        }
      },
    );

    await expectLater(
      audioPlayer.preload(['audio/kana/a.wav']),
      throwsStateError,
    );

    await audioPlayer.preload(['audio/kana/a.wav']);

    expect(attemptCount, 2);
  });
}
