import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'components/map_stop_component.dart';

class VowelsWorldGame extends FlameGame {
  VowelsWorldGame({required this.onOpenReadingStop});

  static const String mapFileName = 'vowels_world.tmx';

  static const String mapPrefix = 'maps/vowels_world/';

  static const String stopsLayerName = 'stops';

  static const String readingStopId = 'reading-vowels';

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

    final map = await TiledComponent.load(
      mapFileName,
      Vector2.all(16),
      prefix: mapPrefix,
    );

    await world.add(map);

    final stopsLayer = map.tileMap.getLayer<ObjectGroup>(stopsLayerName);

    if (stopsLayer == null) {
      throw StateError(
        'The map does not contain the "$stopsLayerName" object layer.',
      );
    }

    final readingStop = stopsLayer.objects.cast<TiledObject?>().firstWhere((
      object,
    ) {
      return object?.properties.getValue<String>('id') == readingStopId;
    }, orElse: () => null);

    if (readingStop == null) {
      throw StateError(
        'The map does not contain the "$readingStopId" learning stop.',
      );
    }

    await world.add(
      MapStopComponent(
        label: readingStop.properties.getValue<String>('label') ?? 'Vocales',
        position: Vector2(readingStop.x, readingStop.y),
        onSelected: onOpenReadingStop,
      ),
    );
  }
}
