import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio.dart';
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

    await audioPlayer.preload(KanaAudio.values);

    expect(preloadCalls, hasLength(1));

    expect(preloadCalls.single, [
      'audio/kana/a.m4a',
      'audio/kana/i.m4a',
      'audio/kana/u.m4a',
      'audio/kana/e.m4a',
      'audio/kana/o.m4a',
    ]);
  });

  test('does not preload the same assets twice', () async {
    final preloadCalls = <List<String>>[];

    final audioPlayer = AssetKanaAudioPlayer(
      preloader: (assetPaths) async {
        preloadCalls.add(List<String>.from(assetPaths));
      },
    );

    await audioPlayer.preload(KanaAudio.values);

    await audioPlayer.preload(KanaAudio.values);

    expect(preloadCalls, hasLength(1));
  });

  test('preloads only assets that are still pending', () async {
    final preloadCalls = <List<String>>[];

    final audioPlayer = AssetKanaAudioPlayer(
      preloader: (assetPaths) async {
        preloadCalls.add(List<String>.from(assetPaths));
      },
    );

    await audioPlayer.preload([KanaAudio.a, KanaAudio.i]);

    await audioPlayer.preload([KanaAudio.i, KanaAudio.u]);

    expect(preloadCalls, hasLength(2));

    expect(preloadCalls.first, ['audio/kana/a.m4a', 'audio/kana/i.m4a']);

    expect(preloadCalls.last, ['audio/kana/u.m4a']);
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

    await expectLater(audioPlayer.preload([KanaAudio.a]), throwsStateError);

    await audioPlayer.preload([KanaAudio.a]);

    expect(attemptCount, 2);
  });
}
