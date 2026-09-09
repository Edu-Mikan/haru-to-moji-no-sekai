import 'kana.dart';

abstract interface class KanaCatalog {
  List<Kana> get all;

  Kana? findById(String id);

  Kana? findByCharacter(String character);
}
