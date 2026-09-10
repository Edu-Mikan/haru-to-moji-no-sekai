import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/app/app.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';
import 'package:haru_to_moji_no_sekai/features/kana_learning/presentation/kana_reading_screen.dart';
import 'package:haru_to_moji_no_sekai/features/world_map/presentation/world_map_screen.dart';

void main() {
  testWidgets('application starts on the home screen', (tester) async {
    await tester.pumpWidget(const HaruToMojiNoSekaiApp());

    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);

    expect(find.byKey(HomeScreen.heroImageKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('navigates from home to the world map', (tester) async {
    await tester.pumpWidget(const HaruToMojiNoSekaiApp());

    await tester.tap(find.byKey(HomeScreen.startButtonKey));

    await tester.pumpAndSettle();

    expect(find.byType(WorldMapScreen), findsOneWidget);

    expect(find.byKey(WorldMapScreen.screenKey), findsOneWidget);

    expect(find.byType(KanaReadingScreen), findsNothing);
  });

  testWidgets('opens the reading activity from the first map stop', (
    tester,
  ) async {
    await tester.pumpWidget(const HaruToMojiNoSekaiApp());

    await tester.tap(find.byKey(HomeScreen.startButtonKey));

    await tester.pumpAndSettle();

    final firstStopButton = find.byKey(WorldMapScreen.firstStopButtonKey);

    await tester.ensureVisible(firstStopButton);
    await tester.pumpAndSettle();

    await tester.tap(firstStopButton);
    await tester.pumpAndSettle();

    expect(find.byType(KanaReadingScreen), findsOneWidget);
  });
}
