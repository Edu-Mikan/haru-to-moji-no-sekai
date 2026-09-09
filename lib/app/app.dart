import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import 'app_theme.dart';

class HaruToMojiNoSekaiApp extends StatelessWidget {
  const HaruToMojiNoSekaiApp({super.key});

  static const String applicationTitle = 'Haru to Moji no Sekai';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(
        onStart: () {
          // La navegación al mapa se añadirá cuando exista
          // la primera pantalla funcional del mundo.
        },
      ),
    );
  }
}
