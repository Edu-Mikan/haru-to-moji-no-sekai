import '../domain/kana.dart';
import '../domain/kana_catalog.dart';
import '../domain/kana_script.dart';

class KakikukekoKanaCatalog implements KanaCatalog {
  const KakikukekoKanaCatalog();

  static const List<Kana> _kaKanas = [
    Kana(
      id: 'hiragana-ka',
      character: 'か',
      reading: 'ka',
      script: KanaScript.hiragana,
      order: 1,
    ),
    Kana(
      id: 'hiragana-ki',
      character: 'き',
      reading: 'ki',
      script: KanaScript.hiragana,
      order: 2,
    ),
    Kana(
      id: 'hiragana-ku',
      character: 'く',
      reading: 'ku',
      script: KanaScript.hiragana,
      order: 3,
    ),
    Kana(
      id: 'hiragana-ke',
      character: 'け',
      reading: 'ke',
      script: KanaScript.hiragana,
      order: 4,
    ),
    Kana(
      id: 'hiragana-ko',
      character: 'こ',
      reading: 'ko',
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
