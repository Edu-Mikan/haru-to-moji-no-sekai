import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MapStopComponent extends PositionComponent with TapCallbacks {
  MapStopComponent({
    required this.character,
    required this.onSelected,
    required super.position,
    Vector2? size,
  }) : super(
         size: size ?? Vector2.all(64),
         anchor: Anchor.center,
         priority: 10,
       );

  static const String spriteAssetPath = 'map/stops/reading_vowels.png';

  final String character;
  final VoidCallback onSelected;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await Sprite.load(spriteAssetPath);

    await addAll([
      SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.topLeft,
        position: Vector2.zero(),
      ),
      TextComponent(
        text: character,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y * 0.57),
        priority: 1,
        textRenderer: TextPaint(
          style: TextStyle(
            color: const Color(0xFFFFF8E8),
            fontSize: size.x * 0.45,
            fontWeight: FontWeight.w900,
            height: 1,
            shadows: const [
              Shadow(
                color: Color(0x55000000),
                offset: Offset(0, 3),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  @override
  void onTapUp(TapUpEvent event) {
    onSelected();
  }
}
