import 'dart:async';

import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/kana_catalog/domain/kana_audio.dart';
import '../features/kana_catalog/domain/kana_audio_player.dart';
import '../features/kana_catalog/infrastructure/asset_kana_audio_player.dart';
import '../features/kana_learning/infrastructure/vowel_kana_catalog.dart';
import '../features/kana_learning/presentation/kana_reading_screen.dart';
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
      await _audioPlayer.preload(KanaAudio.values);
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

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      onStart: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) {
              return WorldMapScreen(
                onOpenFirstStop: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) {
                        return KanaReadingScreen(
                          catalog: const VowelKanaCatalog(),
                          audioPlayer: audioPlayer,
                          onContinue: () {
                            // El siguiente destino pedagógico
                            // se añadirá posteriormente.
                          },
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
