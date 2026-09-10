enum KanaAudio {
  a(character: 'あ', romanization: 'a', assetPath: 'audio/kana/a.m4a'),
  i(character: 'い', romanization: 'i', assetPath: 'audio/kana/i.m4a'),
  u(character: 'う', romanization: 'u', assetPath: 'audio/kana/u.m4a'),
  e(character: 'え', romanization: 'e', assetPath: 'audio/kana/e.m4a'),
  o(character: 'お', romanization: 'o', assetPath: 'audio/kana/o.m4a');

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
