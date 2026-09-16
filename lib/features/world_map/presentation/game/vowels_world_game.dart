import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'components/haru_component.dart';
import 'components/map_stop_component.dart';

import 'package:flame/experimental.dart';

class VowelsWorldGame extends FlameGame {
  VowelsWorldGame({required this.onOpenReadingStop})
    : super(
        camera: CameraComponent.withFixedResolution(width: 360, height: 640),
      );

  static const String mapFileName = 'vowels_world.tmx';

  static const String mapPrefix = 'assets/maps/vowels_world/';

  static const String stopsLayerName = 'stops';

  static const String spawnPointsLayerName = 'spawn-points';

  static const String routesLayerName = 'routes';

  static const String readingStopId = 'reading-vowels';

  static const String haruStartId = 'haru-start';

  static const String readingRouteId = 'route-start-to-reading';

  static const double worldWidth = 640;

  static const double worldHeight = 960;

  final VoidCallback onOpenReadingStop;

  late final HaruComponent _haru;

  var _isMoving = false;
  var _hasReachedReadingStop = false;

  @override
  Color backgroundColor() {
    return const Color(0xFFBDE9FF);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final map = await TiledComponent.load(
      mapFileName,
      Vector2.all(16),
      prefix: mapPrefix,
    );

    await world.add(map);

    final readingStop = _findObjectByProperty(
      map: map,
      layerName: stopsLayerName,
      propertyName: 'id',
      propertyValue: readingStopId,
    );

    final haruStart = _findObjectByProperty(
      map: map,
      layerName: spawnPointsLayerName,
      propertyName: 'id',
      propertyValue: haruStartId,
    );

    final readingRoute = _findObjectByProperty(
      map: map,
      layerName: routesLayerName,
      propertyName: 'id',
      propertyValue: readingRouteId,
    );

    final routePoints = _absolutePolylinePoints(readingRoute);

    if (routePoints.length < 2) {
      throw StateError(
        'The route "$readingRouteId" must contain at least two points.',
      );
    }

    final routeDuration =
        readingRoute.properties.getValue<double>('duration') ?? 3.0;

    _haru = HaruComponent(position: Vector2(haruStart.x, haruStart.y));

    await world.add(_haru);

    camera.viewfinder
      ..anchor = Anchor.center
      ..position = Vector2(180, 320);

    camera.setBounds(
      Rectangle.fromLTRB(180, 320, worldWidth - 180, worldHeight - 320),
    );

    camera.follow(_haru, maxSpeed: 240, snap: true);

    await world.add(
      MapStopComponent(
        character: 'あ',
        position: Vector2(readingStop.x, readingStop.y),
        onSelected: () {
          _openReadingStop(routePoints: routePoints, duration: routeDuration);
        },
      ),
    );
  }

  TiledObject _findObjectByProperty({
    required TiledComponent map,
    required String layerName,
    required String propertyName,
    required String propertyValue,
  }) {
    final layer = map.tileMap.getLayer<ObjectGroup>(layerName);

    if (layer == null) {
      throw StateError(
        'The map does not contain the "$layerName" object layer.',
      );
    }

    final object = layer.objects.cast<TiledObject?>().firstWhere((candidate) {
      return candidate?.properties.getValue<String>(propertyName) ==
          propertyValue;
    }, orElse: () => null);

    if (object == null) {
      throw StateError(
        'The layer "$layerName" does not contain "$propertyValue".',
      );
    }

    return object;
  }

  List<Vector2> _absolutePolylinePoints(TiledObject route) {
    if (route.polyline.isEmpty) {
      throw StateError(
        'The route "$readingRouteId" does not contain a polyline.',
      );
    }

    return [
      for (final point in route.polyline)
        Vector2(route.x + point.x, route.y + point.y),
    ];
  }

  void _openReadingStop({
    required List<Vector2> routePoints,
    required double duration,
  }) {
    if (_isMoving) {
      return;
    }

    if (_hasReachedReadingStop) {
      onOpenReadingStop();
      return;
    }

    _isMoving = true;

    final path = ui.Path()..moveTo(routePoints.first.x, routePoints.first.y);

    for (final point in routePoints.skip(1)) {
      path.lineTo(point.x, point.y);
    }

    _haru.add(
      MoveAlongPathEffect(
        path,
        EffectController(duration: duration),
        absolute: true,
        onComplete: () {
          _isMoving = false;
          _hasReachedReadingStop = true;
          onOpenReadingStop();
        },
      ),
    );
  }
}
