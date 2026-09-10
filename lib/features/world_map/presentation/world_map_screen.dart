import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/vowels_world_game.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key, this.onOpenFirstStop});

  static const Key screenKey = ValueKey<String>('world-map-screen');

  static const Key gameWidgetKey = ValueKey<String>('world-map-game-widget');

  final VoidCallback? onOpenFirstStop;

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
                onOpenReadingStop: () {
                  onOpenFirstStop?.call();
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
                    'No se pudo cargar el mapa.',
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
