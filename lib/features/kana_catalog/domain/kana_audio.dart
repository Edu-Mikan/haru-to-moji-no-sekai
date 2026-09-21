enum KanaAudio {
  a(character: 'あ', romanization: 'a', assetPath: 'audio/kana/a.wav'),
  i(character: 'い', romanization: 'i', assetPath: 'audio/kana/i.wav'),
  u(character: 'う', romanization: 'u', assetPath: 'audio/kana/u.wav'),
  e(character: 'え', romanization: 'e', assetPath: 'audio/kana/e.wav'),
  o(character: 'お', romanization: 'o', assetPath: 'audio/kana/o.wav');

  const KanaAudio({
    required this.character,
    required this.romanization,
    required this.assetPath,
  });

  final String character;
  final String romanization;
  final String assetPath;

  static KanaAudio? fromCharacter(String character) {
    for (final audio in values) {
      if (audio.character == character) {
        return audio;
      }
    }

    return null;
  }
}
