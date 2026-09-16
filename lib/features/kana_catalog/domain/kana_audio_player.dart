import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio.dart';

abstract interface class KanaAudioPlayer {
  Future<void> preload(Iterable<KanaAudio> audios);

  Future<void> play(KanaAudio audio);

  Future<void> stop();

  Future<void> dispose();
}
