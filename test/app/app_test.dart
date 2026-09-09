import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/app/app.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('application starts on the home screen', (tester) async {
    await tester.pumpWidget(const HaruToMojiNoSekaiApp());

    expect(find.byType(HomeScreen), findsOneWidget);

    expect(find.byKey(HomeScreen.titleKey), findsOneWidget);

    expect(find.text('Flutter Demo Home Page'), findsNothing);
  });
}
