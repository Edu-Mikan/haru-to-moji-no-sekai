import '../domain/kana.dart';
import '../domain/kana_catalog.dart';
import '../domain/kana_script.dart';

class VowelKanaCatalog implements KanaCatalog {
  const VowelKanaCatalog();

  static const List<Kana> _vowels = [
    Kana(
      id: 'hiragana-a',
      character: 'あ',
      reading: 'a',
      script: KanaScript.hiragana,
      order: 1,
    ),
    Kana(
      id: 'hiragana-i',
      character: 'い',
      reading: 'i',
      script: KanaScript.hiragana,
      order: 2,
    ),
    Kana(
      id: 'hiragana-u',
      character: 'う',
      reading: 'u',
      script: KanaScript.hiragana,
      order: 3,
    ),
    Kana(
      id: 'hiragana-e',
      character: 'え',
      reading: 'e',
      script: KanaScript.hiragana,
      order: 4,
    ),
    Kana(
      id: 'hiragana-o',
      character: 'お',
      reading: 'o',
      script: KanaScript.hiragana,
      order: 5,
    ),
  ];

  @override
  List<Kana> get all => _vowels;

  @override
  Kana? findById(String id) {
    for (final kana in _vowels) {
      if (kana.id == id) {
        return kana;
      }
    }

    return null;
  }

  @override
  Kana? findByCharacter(String character) {
    for (final kana in _vowels) {
      if (kana.character == character) {
        return kana;
      }
    }

    return null;
  }
}
