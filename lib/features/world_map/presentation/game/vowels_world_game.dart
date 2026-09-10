import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/map_stop_component.dart';

class VowelsWorldGame extends FlameGame {
  VowelsWorldGame({required this.onOpenReadingStop});

  final VoidCallback onOpenReadingStop;

  @override
  Color backgroundColor() {
    return const Color(0xFFBDE9FF);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero();

    await world.add(
      MapStopComponent(
        label: 'Vocales',
        position: Vector2(180, 220),
        onSelected: onOpenReadingStop,
      ),
    );
  }
}
