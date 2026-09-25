import 'package:audioplayers/audioplayers.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio_player.dart';

typedef KanaAssetsPreloader = Future<void> Function(List<String> assetPaths);

class AssetKanaAudioPlayer implements KanaAudioPlayer {
  factory AssetKanaAudioPlayer({
    AudioPlayer? player,
    KanaAssetsPreloader? preloader,
  }) {
    return AssetKanaAudioPlayer._(player, preloader ?? _preloadAssets);
  }

  AssetKanaAudioPlayer._(this._player, this._preloader);

  AudioPlayer? _player;

  final KanaAssetsPreloader _preloader;
  final Set<String> _preloadedAssetPaths = {};

  AudioPlayer get _activePlayer {
    return _player ??= AudioPlayer();
  }

  static Future<void> _preloadAssets(List<String> assetPaths) async {
    final cache = AudioCache(prefix: 'assets/');

    await cache.loadAll(assetPaths);
  }

  @override
  Future<void> preload(Iterable<String> assetPaths) async {
    final pendingAssetPaths = assetPaths
        .where((assetPath) => !_preloadedAssetPaths.contains(assetPath))
        .toList(growable: false);

    if (pendingAssetPaths.isEmpty) {
      return;
    }

    await _preloader(pendingAssetPaths);

    _preloadedAssetPaths.addAll(pendingAssetPaths);
  }

  @override
  Future<void> playAsset(String assetPath) async {
    final player = _activePlayer;

    await player.stop();
    await player.play(AssetSource(assetPath));
  }

  @override
  Future<void> stop() async {
    final player = _player;

    if (player == null) {
      return;
    }

    await player.stop();
  }

  @override
  Future<void> dispose() async {
    final player = _player;

    if (player == null) {
      return;
    }

    _player = null;

    await player.dispose();
  }
}
