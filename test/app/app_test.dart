import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/app/app.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';
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

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(WorldMapScreen), findsOneWidget);

    expect(find.byKey(WorldMapScreen.screenKey), findsOneWidget);

    expect(find.byKey(WorldMapScreen.gameWidgetKey), findsOneWidget);
  });
}
