import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/domain/kana_script.dart';

void main() {
  test('two kana with the same values are equal', () {
    const first = Kana(
      id: 'hiragana-a',
      character: 'あ',
      reading: 'a',
      script: KanaScript.hiragana,
      order: 1,
    );

    const second = Kana(
      id: 'hiragana-a',
      character: 'あ',
      reading: 'a',
      script: KanaScript.hiragana,
      order: 1,
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  test('kana with different identifiers are not equal', () {
    const first = Kana(
      id: 'hiragana-a',
      character: 'あ',
      reading: 'a',
      script: KanaScript.hiragana,
      order: 1,
    );

    const second = Kana(
      id: 'hiragana-i',
      character: 'い',
      reading: 'i',
      script: KanaScript.hiragana,
      order: 2,
    );

    expect(first, isNot(second));
  });
}
