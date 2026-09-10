import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/world_map/presentation/world_map_screen.dart';

void main() {
  Widget buildSubject({VoidCallback? onOpenFirstStop}) {
    return MaterialApp(home: WorldMapScreen(onOpenFirstStop: onOpenFirstStop));
  }

  testWidgets('shows the Flame world map', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(find.byKey(WorldMapScreen.screenKey), findsOneWidget);

    expect(find.byKey(WorldMapScreen.gameWidgetKey), findsOneWidget);
  });

  testWidgets('fits on a phone-sized screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(WorldMapScreen.gameWidgetKey), findsOneWidget);
  });

  testWidgets('fits on a wide browser screen', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(WorldMapScreen.gameWidgetKey), findsOneWidget);
  });
}
