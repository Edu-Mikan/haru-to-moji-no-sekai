abstract interface class KanaAudioPlayer {
  Future<void> preload(Iterable<String> assetPaths);

  Future<void> playAsset(String assetPath);

  Future<void> stop();

  Future<void> dispose();
}
