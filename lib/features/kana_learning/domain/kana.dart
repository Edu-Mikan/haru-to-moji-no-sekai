import 'kana_script.dart';

class Kana {
  const Kana({
    required this.id,
    required this.character,
    required this.reading,
    required this.script,
    required this.order,
  });

  final String id;
  final String character;
  final String reading;
  final KanaScript script;
  final int order;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Kana &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            character == other.character &&
            reading == other.reading &&
            script == other.script &&
            order == other.order;
  }

  @override
  int get hashCode {
    return Object.hash(id, character, reading, script, order);
  }

  @override
  String toString() {
    return 'Kana('
        'id: $id, '
        'character: $character, '
        'reading: $reading, '
        'script: $script, '
        'order: $order'
        ')';
  }
}
