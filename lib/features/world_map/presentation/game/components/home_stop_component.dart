import 'package:flame/components.dart';
import 'package:flame/events.dart';

class HomeStopComponent extends PositionComponent with TapCallbacks {
  HomeStopComponent({
    required super.position,
    required super.size,
    required this.onSelected,
  });

  final void Function() onSelected;

  @override
  void onTapUp(TapUpEvent event) {
    onSelected();
  }
}
