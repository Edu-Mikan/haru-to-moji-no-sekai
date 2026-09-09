import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana_script.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/infrastructure/vowel_kana_catalog.dart';

void main() {
  const catalog = VowelKanaCatalog();

  test('contains the five hiragana vowels', () {
    expect(
      catalog.all.map((kana) => kana.character),
      orderedEquals(['あ', 'い', 'う', 'え', 'お']),
    );
  });

  test('contains the expected readings', () {
    expect(
      catalog.all.map((kana) => kana.reading),
      orderedEquals(['a', 'i', 'u', 'e', 'o']),
    );
  });

  test('uses consecutive pedagogical order', () {
    expect(
      catalog.all.map((kana) => kana.order),
      orderedEquals([1, 2, 3, 4, 5]),
    );
  });

  test('contains only hiragana', () {
    expect(
      catalog.all.every((kana) => kana.script == KanaScript.hiragana),
      isTrue,
    );
  });

  test('does not contain duplicate identifiers', () {
    final identifiers = catalog.all.map((kana) => kana.id).toSet();

    expect(identifiers, hasLength(catalog.all.length));
  });

  test('does not contain duplicate characters', () {
    final characters = catalog.all.map((kana) => kana.character);

    expect(characters.toSet(), hasLength(catalog.all.length));
  });

  test('finds a kana by identifier', () {
    final kana = catalog.findById('hiragana-u');

    expect(kana, isNotNull);
    expect(kana?.character, 'う');
    expect(kana?.reading, 'u');
  });

  test('finds a kana by character', () {
    final kana = catalog.findByCharacter('え');

    expect(kana, isNotNull);
    expect(kana?.id, 'hiragana-e');
  });

  test('returns null for an unknown identifier', () {
    expect(catalog.findById('unknown'), isNull);
  });

  test('returns null for an unknown character', () {
    expect(catalog.findByCharacter('か'), isNull);
  });
}
