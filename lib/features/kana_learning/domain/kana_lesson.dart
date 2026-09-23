class KanaLesson {
  const KanaLesson({
    required this.id,
    required this.backgroundAsset,
    required this.kana,
  });

  final String id;
  final String backgroundAsset;
  final List<String> kana;
}
