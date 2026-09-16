import 'package:flutter/material.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio.dart';
import 'package:haru_to_moji_no_sekai/features/kana_catalog/domain/kana_audio_player.dart';

import '../domain/kana.dart';
import '../domain/kana_catalog.dart';
import 'widgets/kana_button.dart';

class KanaReadingScreen extends StatefulWidget {
  const KanaReadingScreen({
    required this.catalog,
    required this.audioPlayer,
    super.key,
    this.onKanaSelected,
    this.onContinue,
  });

  static const Key screenKey = ValueKey<String>('kana-reading-screen');

  static const Key backgroundKey = ValueKey<String>('kana-reading-background');

  static const Key titleKey = ValueKey<String>('kana-reading-title');

  static const Key selectedKanaKey = ValueKey<String>(
    'kana-reading-selected-kana',
  );

  static const Key continueButtonKey = ValueKey<String>(
    'kana-reading-continue-button',
  );

  static const Key backButtonKey = ValueKey<String>('kana-reading-back-button');

  final KanaCatalog catalog;
  final KanaAudioPlayer audioPlayer;
  final ValueChanged<Kana>? onKanaSelected;
  final VoidCallback? onContinue;

  @override
  State<KanaReadingScreen> createState() {
    return _KanaReadingScreenState();
  }
}

class _KanaReadingScreenState extends State<KanaReadingScreen> {
  static const String _backgroundAssetPath =
      'assets/branding/kana_reading/kana_reading_background.png';

  static const List<Color> _buttonColors = [
    Color(0xFFF4515F),
    Color(0xFFFFB916),
    Color(0xFF29A9E8),
    Color(0xFF67C83E),
    Color(0xFF9364DA),
  ];

  static const List<double> _buttonRotations = [-5, 7, -7, 6, -5];

  static const List<Offset> _buttonPositions = [
    Offset(0.29, 0.28),
    Offset(0.70, 0.39),
    Offset(0.29, 0.53),
    Offset(0.71, 0.66),
    Offset(0.36, 0.80),
  ];

  Kana? _selectedKana;

  Future<void> _selectKana(Kana kana) async {
    setState(() {
      _selectedKana = kana;
    });

    widget.onKanaSelected?.call(kana);

    final audio = KanaAudio.fromCharacter(kana.character);

    if (audio == null) {
      return;
    }

    await widget.audioPlayer.play(audio);
  }

  Future<void> _returnToMap() async {
    await widget.audioPlayer.stop();

    if (!mounted) {
      return;
    }

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final vowels = widget.catalog.all;

    return Scaffold(
      key: KanaReadingScreen.screenKey,
      backgroundColor: const Color(0xFFB5E4FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasSize = _calculateCanvasSize(constraints.biggest);

            return Center(
              child: SizedBox(
                width: canvasSize.width,
                height: canvasSize.height,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        _backgroundAssetPath,
                        key: KanaReadingScreen.backgroundKey,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Positioned(
                      left: canvasSize.width * 0.035,
                      top: canvasSize.height * 0.025,
                      child: _BackButton(
                        size: canvasSize.width * 0.14,
                        onPressed: _returnToMap,
                      ),
                    ),
                    for (
                      var index = 0;
                      index < vowels.length && index < _buttonPositions.length;
                      index++
                    )
                      _buildKanaButton(
                        kana: vowels[index],
                        index: index,
                        canvasSize: canvasSize,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKanaButton({
    required Kana kana,
    required int index,
    required Size canvasSize,
  }) {
    final buttonSize = (canvasSize.width * 0.27).clamp(88.0, 180.0);

    final position = _buttonPositions[index];

    return Positioned(
      left: (canvasSize.width * position.dx) - (buttonSize / 2),
      top: (canvasSize.height * position.dy) - (buttonSize / 2),
      child: KanaButton(
        kana: kana,
        color: _buttonColors[index],
        rotation: _buttonRotations[index],
        size: buttonSize,
        isSelected: _selectedKana?.id == kana.id,
        selectedKey: _selectedKana?.id == kana.id
            ? KanaReadingScreen.selectedKanaKey
            : null,
        onPressed: _selectKana,
      ),
    );
  }

  Size _calculateCanvasSize(Size availableSize) {
    const aspectRatio = 2 / 3;

    var width = availableSize.width;
    var height = width / aspectRatio;

    if (height > availableSize.height) {
      height = availableSize.height;
      width = height * aspectRatio;
    }

    return Size(width, height);
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.size, required this.onPressed});

  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.clamp(48.0, 76.0);

    return Material(
      color: const Color(0xFFFFFCF5),
      elevation: 6,
      shadowColor: const Color(0x44000000),
      shape: const CircleBorder(),
      child: InkWell(
        key: KanaReadingScreen.backButtonKey,
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: effectiveSize,
          child: Icon(
            Icons.home_rounded,
            size: effectiveSize * 0.58,
            color: const Color(0xFF4399DB),
          ),
        ),
      ),
    );
  }
}
