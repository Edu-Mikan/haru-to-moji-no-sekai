import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/app/app.dart';

void main() {
  testWidgets('muestra la presentación inicial', (tester) async {
    await tester.pumpWidget(const HaruToMojiApp());

    expect(find.text('はるともじのせかい'), findsOneWidget);
    expect(
      find.text('Una aventura para aprender a escribir japonés'),
      findsOneWidget,
    );
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
