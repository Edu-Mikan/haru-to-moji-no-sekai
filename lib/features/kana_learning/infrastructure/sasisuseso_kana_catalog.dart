import '../domain/kana.dart';
import '../domain/kana_catalog.dart';
import '../domain/kana_script.dart';

class SasisusesoKanaCatalog implements KanaCatalog {
  const SasisusesoKanaCatalog();

  static const List<Kana> _kaKanas = [
    Kana(
      id: 'hiragana-sa',
      character: 'さ',
      reading: 'sa',
      script: KanaScript.hiragana,
      order: 1,
    ),
    Kana(
      id: 'hiragana-shi',
      character: 'し',
      reading: 'shi',
      script: KanaScript.hiragana,
      order: 2,
    ),
    Kana(
      id: 'hiragana-su',
      character: 'す',
      reading: 'su',
      script: KanaScript.hiragana,
      order: 3,
    ),
    Kana(
      id: 'hiragana-se',
      character: 'せ',
      reading: 'se',
      script: KanaScript.hiragana,
      order: 4,
    ),
    Kana(
      id: 'hiragana-so',
      character: 'そ',
      reading: 'so',
      script: KanaScript.hiragana,
      order: 5,
    ),
  ];

  @override
  List<Kana> get all => _kaKanas;

  @override
  Kana? findById(String id) {
    for (final kana in _kaKanas) {
      if (kana.id == id) {
        return kana;
      }
    }

    return null;
  }

  @override
  Kana? findByCharacter(String character) {
    for (final kana in _kaKanas) {
      if (kana.character == character) {
        return kana;
      }
    }

    return null;
  }
}
