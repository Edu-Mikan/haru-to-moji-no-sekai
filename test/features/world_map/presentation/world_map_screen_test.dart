import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/world_map/presentation/world_map_screen.dart';

void main() {
  Widget buildSubject({VoidCallback? onOpenFirstStop}) {
    return MaterialApp(home: WorldMapScreen(onOpenFirstStop: onOpenFirstStop));
  }

  testWidgets('shows the provisional map and first stop', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byKey(WorldMapScreen.screenKey), findsOneWidget);

    expect(find.byKey(WorldMapScreen.mapPlaceholderKey), findsOneWidget);

    expect(find.byKey(WorldMapScreen.firstStopButtonKey), findsOneWidget);
  });

  testWidgets('opens the first map stop', (tester) async {
    var firstStopRequested = false;

    await tester.pumpWidget(
      buildSubject(
        onOpenFirstStop: () {
          firstStopRequested = true;
        },
      ),
    );

    final firstStopButton = find.byKey(WorldMapScreen.firstStopButtonKey);

    await tester.ensureVisible(firstStopButton);
    await tester.pumpAndSettle();

    await tester.tap(firstStopButton);
    await tester.pump();

    expect(firstStopRequested, isTrue);
  });

  testWidgets('fits on a phone-sized screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(WorldMapScreen.screenKey), findsOneWidget);
  });

  testWidgets('fits on a wide browser screen', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(WorldMapScreen.mapPlaceholderKey), findsOneWidget);
  });
}
