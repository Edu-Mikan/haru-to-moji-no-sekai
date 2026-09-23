import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'components/haru_component.dart';
import 'components/map_stop_component.dart';
import '../../domain/map_constants.dart';

class RouteData {
  const RouteData({
    required this.id,
    required this.from,
    required this.to,
    required this.duration,
    required this.points,
  });

  final String id;
  final String from;
  final String to;
  final double duration;
  final List<Vector2> points;
}

class RouteMatch {
  const RouteMatch({required this.route, required this.reversed});

  final RouteData route;
  final bool reversed;
}

class StopData {
  const StopData({
    required this.id,
    required this.object,
    required this.label,
    required this.kana,
    required this.activity,
    required this.lesson,
    required this.visible,
  });

  final String id;
  final TiledObject object;
  final String label;
  final String kana;
  final String activity;
  final String lesson;
  final bool visible;
}

class ActivityRequest {
  const ActivityRequest({required this.activity, required this.lesson});

  final String activity;
  final String lesson;
}

class VowelsWorldGame extends FlameGame {
  VowelsWorldGame({required this.onOpenActivity}) : super();

  static const String mapFileName = 'vowels_world.tmx';
  static const String mapPrefix = 'assets/maps/vowels_world/';

  static const String stopsLayerName = 'stops';
  static const String routesLayerName = 'routes';

  static const String haruStartId = 'haru-start';

  static const double tileSize = 48;
  static const double stopSizeMultiplier = 1.3;

  final void Function(ActivityRequest request) onOpenActivity;

  late final HaruComponent _haru;

  late final Vector2 _haruStartCenter;

  final Map<String, StopData> _stops = {};

  final List<RouteData> _routes = [];

  var _isMoving = false;
  String _currentStopId = haruStartId;

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

    _loadStops(map);
    _loadRoutes(map);

    final mapWidth = map.tileMap.map.width * map.tileMap.map.tileWidth;

    final mapHeight = map.tileMap.map.height * map.tileMap.map.tileHeight;

    final haruStart = _getStop(haruStartId).object;

    _haruStartCenter = _objectCenter(haruStart);

    _haru = HaruComponent(position: _haruStartCenter);

    await world.add(_haru);

    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1.75;

    await Future.delayed(Duration.zero);

    final halfVisibleWidth = size.x / camera.viewfinder.zoom / 2;

    final halfVisibleHeight = size.y / camera.viewfinder.zoom / 2;

    camera.setBounds(
      Rectangle.fromLTRB(
        halfVisibleWidth,
        halfVisibleHeight,
        mapWidth.toDouble() - halfVisibleWidth,
        mapHeight.toDouble() - halfVisibleHeight,
      ),
    );

    camera.follow(_haru, maxSpeed: 240, snap: true);

    for (final stop in _stops.values) {
      await _addStop(stop);
    }
  }

  List<Vector2> _absolutePolylinePoints(TiledObject route) {
    if (route.polyline.isEmpty) {
      throw StateError('The route does not contain a polyline.');
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

    _haru.startWalking();

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
          _haru.stopWalking();
          onComplete?.call();
        },
      ),
    );
  }

  void _openKanaReadingStop(StopData stop) {
    if (_currentStopId == stop.id) {
      _openActivity(stop);
      return;
    }

    _goToStop(
      stop.id,
      onComplete: () {
        _openActivity(stop);
      },
    );
  }

  void _returnHome() {
    _goToStop(haruStartId);
  }

  Vector2 _objectCenter(TiledObject object) {
    return Vector2(
      object.x + (object.width / 2),
      object.y + (object.height / 2),
    );
  }

  void _loadStops(TiledComponent map) {
    final layer = map.tileMap.getLayer<ObjectGroup>(stopsLayerName);

    if (layer == null) {
      throw StateError('The map does not contain the "$stopsLayerName" layer.');
    }

    for (final stop in layer.objects) {
      final stopId = stop.properties.getValue<String>('id');

      if (stopId == null) {
        continue;
      }

      _stops[stopId] = StopData(
        id: stopId,
        object: stop,
        label: stop.properties.getValue<String>('label') ?? stopId,
        kana: stop.properties.getValue<String>('kana') ?? '？',
        activity: stop.properties.getValue<String>('activity') ?? 'unknown',
        lesson: stop.properties.getValue<String>('lesson') ?? '',
        visible: stop.properties.getValue<bool>('visible') ?? true,
      );
    }
  }

  void _loadRoutes(TiledComponent map) {
    final layer = map.tileMap.getLayer<ObjectGroup>(routesLayerName);

    if (layer == null) {
      throw StateError(
        'The map does not contain the "$routesLayerName" layer.',
      );
    }

    for (final route in layer.objects) {
      final routeId = route.properties.getValue<String>('id');

      final from = route.properties.getValue<String>('from');

      final to = route.properties.getValue<String>('to');

      if (routeId == null || from == null || to == null) {
        continue;
      }

      _routes.add(
        RouteData(
          id: routeId,
          from: from,
          to: to,
          duration: route.properties.getValue<double>('duration') ?? 3.0,
          points: _absolutePolylinePoints(route),
        ),
      );
    }
  }

  RouteMatch _findRoute(String from, String to) {
    for (final route in _routes) {
      if (route.from == from && route.to == to) {
        return RouteMatch(route: route, reversed: false);
      }

      if (route.from == to && route.to == from) {
        return RouteMatch(route: route, reversed: true);
      }
    }

    throw StateError(
      'No route found between '
      '$from and $to',
    );
  }

  void _goToStop(String destinationStopId, {VoidCallback? onComplete}) {
    final match = _findRoute(_currentStopId, destinationStopId);

    _moveAlongRoute(
      routePoints: match.reversed
          ? match.route.points.reversed.toList()
          : match.route.points,
      duration: match.route.duration,
      onComplete: () {
        _currentStopId = destinationStopId;
        onComplete?.call();
      },
    );
  }

  Future<void> _addStop(StopData stop) async {
    if (!stop.visible) {
      return;
    }
    await world.add(
      MapStopComponent(
        character: stop.kana,
        position: Vector2(stop.object.x, stop.object.y),
        size: Vector2.all(tileSize * stopSizeMultiplier),
        onSelected: () {
          _onStopSelected(stop.id);
        },
      ),
    );
  }

  void _onStopSelected(String stopId) {
    final stop = _getStop(stopId);

    switch (stop.activity) {
      case StopActivities.home:
        _returnHome();
        break;

      case StopActivities.kanaReading:
        _openKanaReadingStop(stop);
        break;

      case StopActivities.travelOnly:
        _goToStop(stopId);
        break;

      default:
        _goToStop(stopId);
    }
  }

  StopData _getStop(String stopId) {
    final stop = _stops[stopId];

    if (stop == null) {
      throw StateError('The stop "$stopId" does not exist.');
    }

    return stop;
  }

  void _openActivity(StopData stop) {
    onOpenActivity(
      ActivityRequest(activity: stop.activity, lesson: stop.lesson),
    );
  }
}
