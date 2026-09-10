import 'package:audioplayers/audioplayers.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio_player.dart';

class AssetKanaAudioPlayer implements KanaAudioPlayer {
  AssetKanaAudioPlayer({AudioPlayer? player})
    : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<void> play(KanaAudio audio) async {
    await _player.stop();
    await _player.play(AssetSource(audio.assetPath));
  }

  @override
  Future<void> stop() {
    return _player.stop();
  }

  @override
  Future<void> dispose() {
    return _player.dispose();
  }
}
