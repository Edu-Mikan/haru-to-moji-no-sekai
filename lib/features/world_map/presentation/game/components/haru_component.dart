import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class HaruComponent extends SpriteAnimationComponent {
  HaruComponent({required super.position})
    : super(size: Vector2(48, 48), anchor: Anchor.bottomCenter, priority: 20);

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await Sprite.load('characters/haru/haru-spritesheet.png');

    final spriteSheet = SpriteSheet(
      image: image.image,
      srcSize: Vector2(384, 512),
    );

    _idleAnimation = SpriteAnimation.spriteList([
      spriteSheet.getSprite(0, 0),
    ], stepTime: 1);

    _walkAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.12, to: 4);

    animation = _idleAnimation;
  }

  void startWalking() {
    animation = _walkAnimation;
  }

  void stopWalking() {
    animation = _idleAnimation;
  }
}
