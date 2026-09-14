import 'package:flame/components.dart';

class HaruComponent extends SpriteComponent {
  HaruComponent({required super.position})
    : super(size: Vector2(48, 48), anchor: Anchor.bottomCenter, priority: 20);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load('characters/haru/haru_running.png');
  }
}
