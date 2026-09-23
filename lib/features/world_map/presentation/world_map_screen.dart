import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../domain/map_constants.dart';
import 'game/vowels_world_game.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key, this.onOpenLesson});

  static const Key screenKey = ValueKey<String>('world-map-screen');

  static const Key gameWidgetKey = ValueKey<String>('world-map-game-widget');

  final ValueChanged<String>? onOpenLesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('El mundo de はる'), centerTitle: true),
      body: SafeArea(
        child: ClipRect(
          child: GameWidget.controlled(
            key: gameWidgetKey,
            gameFactory: () {
              return VowelsWorldGame(
                onOpenActivity: (request) {
                  if (request.activity == StopActivities.kanaReading) {
                    debugPrint('Lesson requested: ${request.lesson}');
                    switch (request.lesson) {
                      case Lessons.aiueo:
                        onOpenLesson?.call(request.lesson);
                        break;

                      case Lessons.kakikukeko:
                        onOpenLesson?.call(request.lesson);
                        break;

                      default:
                        onOpenLesson?.call(request.lesson);
                    }
                  }
                },
              );
            },
            loadingBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No se pudo cargar el mapa. \n$error',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
