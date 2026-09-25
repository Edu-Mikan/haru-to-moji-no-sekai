import 'kana_lesson.dart';

class KanaLessons {
  static const aiueo = KanaLesson(
    id: 'aiueo',
    backgroundAsset: 'assets/branding/kana_reading/lago_background.png',
    kana: ['あ', 'い', 'う', 'え', 'お'],
  );

  static const kakikukeko = KanaLesson(
    id: 'kakikukeko',
    backgroundAsset: 'assets/branding/kana_reading/tahona_background.png',
    kana: ['か', 'き', 'く', 'け', 'こ'],
  );

  static const sasisuseso = KanaLesson(
    id: 'sasisuseso',
    backgroundAsset: 'assets/branding/kana_reading/parque_background.png',
    kana: ['さ', 'し', 'す', 'せ', 'そ'],
  );

  static KanaLesson byId(String id) {
    switch (id) {
      case 'aiueo':
        return aiueo;

      case 'kakikukeko':
        return kakikukeko;

      case 'sasisuseso':
        return sasisuseso;

      default:
        throw ArgumentError('Unknown lesson: $id');
    }
  }
}
