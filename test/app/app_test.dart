import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/app/app.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/kana_reading_screen.dart';

void main() {
  testWidgets('application starts on the home screen', (tester) async {
    await tester.pumpWidget(const HaruToMojiNoSekaiApp());

    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);

    expect(find.byKey(HomeScreen.heroImageKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('navigates from home to the kana reading screen', (tester) async {
    await tester.pumpWidget(const HaruToMojiNoSekaiApp());

    await tester.tap(find.byKey(HomeScreen.startButtonKey));

    await tester.pumpAndSettle();

    expect(find.byType(KanaReadingScreen), findsOneWidget);

    expect(find.byKey(KanaReadingScreen.screenKey), findsOneWidget);
  });
}
