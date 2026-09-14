import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/kana.dart';

class KanaButton extends StatelessWidget {
  const KanaButton({
    required this.kana,
    required this.color,
    required this.onPressed,
    super.key,
    this.size = 120,
    this.rotation = 0,
    this.isSelected = false,
    this.selectedKey,
  });

  static const String blockAssetPath =
      'assets/branding/kana_reading/kana_block.png';

  final Kana kana;
  final Color color;
  final ValueChanged<Kana> onPressed;
  final double size;
  final double rotation;
  final bool isSelected;
  final Key? selectedKey;

  static Key keyFor(String kanaId) {
    return ValueKey<String>('kana-button-$kanaId');
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Reproducir el sonido ${kana.reading}',
      child: Transform.rotate(
        angle: rotation * math.pi / 180,
        filterQuality: FilterQuality.none,
        child: AnimatedScale(
          scale: isSelected ? 1.08 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: SizedBox.square(
            key: selectedKey,
            dimension: size,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: keyFor(kana.id),
                onTap: () => onPressed(kana),
                borderRadius: BorderRadius.circular(size * 0.22),
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      blockAssetPath,
                      fit: BoxFit.contain,
                      color: color,
                      colorBlendMode: BlendMode.modulate,
                      filterQuality: FilterQuality.none,
                      isAntiAlias: false,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size * 0.08),
                      child: Center(
                        child: Text(
                          kana.character,
                          style: TextStyle(
                            color: const Color(0xFFFFF8E8),
                            fontSize: size * 0.47,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            shadows: const [
                              Shadow(
                                color: Color(0x45000000),
                                offset: Offset(0, 3),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
