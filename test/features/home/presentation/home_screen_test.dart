import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';

void main() {
  Widget buildSubject({VoidCallback? onStart}) {
    return MaterialApp(home: HomeScreen(onStart: onStart));
  }

  testWidgets('shows the principal home elements', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byKey(HomeScreen.titleKey), findsOneWidget);

    expect(find.byKey(HomeScreen.heroPlaceholderKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('invokes the start action when the button is pressed', (
    tester,
  ) async {
    var startRequested = false;

    await tester.pumpWidget(
      buildSubject(
        onStart: () {
          startRequested = true;
        },
      ),
    );

    await tester.tap(find.byKey(HomeScreen.startButtonKey));

    await tester.pump();

    expect(startRequested, isTrue);
  });

  testWidgets('uses a compact layout on a phone-sized screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    expect(tester.takeException(), isNull);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('uses a wide layout without overflowing', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    expect(tester.takeException(), isNull);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });
}
