import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MapStopComponent extends CircleComponent with TapCallbacks {
  MapStopComponent({
    required this.label,
    required this.onSelected,
    required super.position,
    super.radius = 54,
  }) : super(
         anchor: Anchor.center,
         paint: Paint()..color = const Color(0xFFF45B86),
       );

  final String label;
  final VoidCallback onSelected;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextComponent(
        text: label,
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    onSelected();
  }
}
