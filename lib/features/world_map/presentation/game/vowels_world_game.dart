import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'components/home_stop_component.dart';
import 'components/haru_component.dart';
import 'components/map_stop_component.dart';

class VowelsWorldGame extends FlameGame {
  VowelsWorldGame({required this.onOpenReadingStop})
    : super(
        camera: CameraComponent.withFixedResolution(
          width: viewportWidth,
          height: viewportHeight,
        ),
      );

  static const String mapFileName = 'vowels_world.tmx';
  static const String mapPrefix = 'assets/maps/vowels_world/';

  static const String stopsLayerName = 'stops';
  static const String spawnPointsLayerName = 'spawn-points';
  static const String routesLayerName = 'routes';

  static const String readingStopId = 'reading-vowels';
  static const String haruStartId = 'haru-start';
  static const String readingRouteId = 'route-start-to-reading';

  static const double tileSize = 48;
  static const double viewportWidth = 360;
  static const double viewportHeight = 640;
  static const double stopSizeMultiplier = 1.3;

  final VoidCallback onOpenReadingStop;

  late final HaruComponent _haru;
  late final List<Vector2> _readingRoutePoints;
  late final Vector2 _haruStartCenter;
  late final double _routeDuration;

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
      Vector2.all(tileSize),
      prefix: mapPrefix,
    );

    await world.add(map);

    final mapWidth = map.tileMap.map.width * map.tileMap.map.tileWidth;

    final mapHeight = map.tileMap.map.height * map.tileMap.map.tileHeight;

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

    _readingRoutePoints = _absolutePolylinePoints(readingRoute);

    if (_readingRoutePoints.length < 2) {
      throw StateError(
        'The route "$readingRouteId" must contain at least two points.',
      );
    }

    _routeDuration =
        readingRoute.properties.getValue<double>('duration') ?? 3.0;

    _haruStartCenter = _objectCenter(haruStart);

    _haru = HaruComponent(position: _haruStartCenter);

    await world.add(
      HomeStopComponent(
        position: Vector2(haruStart.x, haruStart.y),
        size: Vector2(haruStart.width, haruStart.height),
        onSelected: _returnHome,
      ),
    );

    await world.add(_haru);

    const halfViewportWidth = viewportWidth / 2;
    const halfViewportHeight = viewportHeight / 2;

    camera.viewfinder
      ..anchor = Anchor.center
      ..position = Vector2(halfViewportWidth, halfViewportHeight);

    camera.setBounds(
      Rectangle.fromLTRB(
        halfViewportWidth,
        halfViewportHeight,
        mapWidth - halfViewportWidth,
        mapHeight - halfViewportHeight,
      ),
    );

    camera.follow(_haru, maxSpeed: 240, snap: true);

    await world.add(
      MapStopComponent(
        character: 'あ',
        position: Vector2(readingStop.x, readingStop.y),
        size: Vector2.all(tileSize * stopSizeMultiplier),
        onSelected: () {
          _openReadingStop(
            routePoints: _readingRoutePoints,
            duration: _routeDuration,
          );
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

    final object = layer.objects.cast<TiledObject?>().firstWhere(
      (candidate) =>
          candidate?.properties.getValue<String>(propertyName) == propertyValue,
      orElse: () => null,
    );

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

  void _moveAlongRoute({
    required List<Vector2> routePoints,
    required double duration,
    VoidCallback? onComplete,
  }) {
    if (_isMoving) {
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
          onComplete?.call();
        },
      ),
    );
  }

  void _openReadingStop({
    required List<Vector2> routePoints,
    required double duration,
  }) {
    if (_hasReachedReadingStop) {
      onOpenReadingStop();
      return;
    }

    _moveAlongRoute(
      routePoints: routePoints,
      duration: duration,
      onComplete: () {
        _hasReachedReadingStop = true;
        onOpenReadingStop();
      },
    );
  }

  void _returnHome() {
    _moveAlongRoute(
      routePoints: _readingRoutePoints.reversed.toList(),
      duration: _routeDuration,
      onComplete: () {
        _hasReachedReadingStop = false;
      },
    );
  }

  Vector2 _objectCenter(TiledObject object) {
    return Vector2(
      object.x + (object.width / 2),
      object.y + (object.height / 2),
    );
  }
}
