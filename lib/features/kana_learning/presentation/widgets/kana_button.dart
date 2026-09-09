import 'package:flutter/material.dart';

import '../../domain/kana.dart';

class KanaButton extends StatelessWidget {
  const KanaButton({
    required this.kana,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final Kana kana;
  final Color color;
  final ValueChanged<Kana> onPressed;

  static Key keyFor(String kanaId) {
    return ValueKey<String>('kana-button-$kanaId');
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Reproducir el sonido ${kana.reading}',
      child: Material(
        color: color,
        elevation: 4,
        shadowColor: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          key: keyFor(kana.id),
          onTap: () => onPressed(kana),
          borderRadius: BorderRadius.circular(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 112, minHeight: 112),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  kana.character,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    shadows: [
                      Shadow(
                        color: Color(0x55000000),
                        offset: Offset(0, 3),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
