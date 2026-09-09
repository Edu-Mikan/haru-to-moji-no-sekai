import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/kana_learning/infrastructure/vowel_kana_catalog.dart';
import '../features/kana_learning/presentation/kana_reading_screen.dart';
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
      home: const _HomeNavigator(),
    );
  }
}

class _HomeNavigator extends StatelessWidget {
  const _HomeNavigator();

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      onStart: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) {
              return KanaReadingScreen(
                catalog: const VowelKanaCatalog(),
                onKanaSelected: (kana) {
                  // La reproducción local se añadirá cuando
                  // estén disponibles los audios definitivos.
                },
                onContinue: () {
                  // La navegación hacia el mapa o la práctica
                  // se añadirá en un bloque posterior.
                },
              );
            },
          ),
        );
      },
    );
  }
}
