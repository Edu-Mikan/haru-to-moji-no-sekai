import 'dart:async';

import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/kana_catalog/domain/kana_audio_player.dart';
import '../features/kana_catalog/infrastructure/asset_kana_audio_player.dart';
import '../features/kana_learning/domain/kana_catalog.dart';
import '../features/kana_learning/domain/kana_lessons.dart';
import '../features/kana_learning/infrastructure/vowel_kana_catalog.dart';
import '../features/kana_learning/infrastructure/kakikukeko_kana_catalog.dart';
import '../features/kana_learning/infrastructure/sasisuseso_kana_catalog.dart';
import '../features/kana_learning/presentation/kana_reading_screen.dart';
import '../features/world_map/domain/map_constants.dart';
import '../features/world_map/presentation/world_map_screen.dart';
import 'app_theme.dart';

class HaruToMojiNoSekaiApp extends StatefulWidget {
  const HaruToMojiNoSekaiApp({super.key, this.audioPlayer});

  static const String applicationTitle = 'Haru to Moji no Sekai';

  final KanaAudioPlayer? audioPlayer;

  @override
  State<HaruToMojiNoSekaiApp> createState() {
    return _HaruToMojiNoSekaiAppState();
  }
}

class _HaruToMojiNoSekaiAppState extends State<HaruToMojiNoSekaiApp> {
  late final KanaAudioPlayer _audioPlayer;
  late final bool _ownsAudioPlayer;

  @override
  void initState() {
    super.initState();

    _ownsAudioPlayer = widget.audioPlayer == null;
    _audioPlayer = widget.audioPlayer ?? AssetKanaAudioPlayer();

    unawaited(_preloadKanaAudio());
  }

  Future<void> _preloadKanaAudio() async {
    try {
      await _audioPlayer.preload([
        'audio/kana/a.wav',
        'audio/kana/i.wav',
        'audio/kana/u.wav',
        'audio/kana/e.wav',
        'audio/kana/o.wav',
      ]);
    } on Object {
      // La precarga es una optimización.
      // La reproducción normal volverá a intentar cargar
      // el recurso cuando el usuario pulse una vocal.
    }
  }

  @override
  void dispose() {
    if (_ownsAudioPlayer) {
      unawaited(_audioPlayer.dispose());
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HaruToMojiNoSekaiApp.applicationTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _HomeNavigator(audioPlayer: _audioPlayer),
    );
  }
}

class _HomeNavigator extends StatelessWidget {
  const _HomeNavigator({required this.audioPlayer});

  final KanaAudioPlayer audioPlayer;

  KanaCatalog _catalogForLesson(String lesson) {
    switch (lesson) {
      case Lessons.aiueo:
        return const VowelKanaCatalog();

      case Lessons.kakikukeko:
        return const KakikukekoKanaCatalog();

      case Lessons.sasisuseso:
        return const SasisusesoKanaCatalog();

      default:
        return const VowelKanaCatalog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      onStart: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) {
              return WorldMapScreen(
                onOpenLesson: (lessonId) {
                  final catalog = _catalogForLesson(lessonId);
                  final lesson = KanaLessons.byId(lessonId);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) {
                        return KanaReadingScreen(
                          lesson: lesson,
                          catalog: catalog,
                          audioPlayer: audioPlayer,
                          onContinue: () {},
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
