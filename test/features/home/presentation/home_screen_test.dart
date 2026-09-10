import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';

void main() {
  Widget buildSubject({VoidCallback? onStart}) {
    return MaterialApp(home: HomeScreen(onStart: onStart));
  }

  testWidgets('shows the home artwork and start button', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(find.byKey(HomeScreen.heroImageKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);

    expect(
      find.byKey(const ValueKey<String>('home-hero-placeholder')),
      findsNothing,
    );
  });

  testWidgets('uses the portrait artwork on a portrait screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    final image = tester.widget<Image>(find.byKey(HomeScreen.heroImageKey));

    expect(image.image, isA<AssetImage>());

    final assetImage = image.image as AssetImage;

    expect(assetImage.assetName, HomeScreen.portraitHeroAssetPath);
  });

  testWidgets('uses the landscape artwork on a landscape screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    final image = tester.widget<Image>(find.byKey(HomeScreen.heroImageKey));

    expect(image.image, isA<AssetImage>());

    final assetImage = image.image as AssetImage;

    expect(assetImage.assetName, HomeScreen.landscapeHeroAssetPath);
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

  testWidgets('fits on a phone-sized screen without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(HomeScreen.heroImageKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('fits on a wide browser screen without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(HomeScreen.heroImageKey), findsOneWidget);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('fits on a short landscape screen without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    expect(tester.takeException(), isNull);

    expect(find.byKey(HomeScreen.startButtonKey), findsOneWidget);
  });

  testWidgets('changes the artwork when the orientation changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());

    await tester.pump();

    var image = tester.widget<Image>(find.byKey(HomeScreen.heroImageKey));

    expect(
      (image.image as AssetImage).assetName,
      HomeScreen.portraitHeroAssetPath,
    );

    tester.view.physicalSize = const Size(844, 390);

    await tester.pumpAndSettle();

    image = tester.widget<Image>(find.byKey(HomeScreen.heroImageKey));

    expect(
      (image.image as AssetImage).assetName,
      HomeScreen.landscapeHeroAssetPath,
    );
  });
}
