import 'dart:async';

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

  static const Key titleKey = ValueKey<String>('kana-reading-title');

  static const Key selectedKanaKey = ValueKey<String>(
    'kana-reading-selected-kana',
  );

  static const Key continueButtonKey = ValueKey<String>(
    'kana-reading-continue-button',
  );

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
  static const List<Color> _buttonColors = [
    Color(0xFFF45B86),
    Color(0xFF41B95C),
    Color(0xFF31AEE8),
    Color(0xFFFFA726),
    Color(0xFF8E63D9),
  ];

  Kana? _selectedKana;

  @override
  void dispose() {
    unawaited(widget.audioPlayer.dispose());
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final vowels = widget.catalog.all;

    return Scaffold(
      key: KanaReadingScreen.screenKey,
      appBar: AppBar(title: const Text('Las vocales'), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pulsa una vocal para escucharla',
                          key: KanaReadingScreen.titleKey,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            for (var index = 0; index < vowels.length; index++)
                              KanaButton(
                                kana: vowels[index],
                                color:
                                    _buttonColors[index % _buttonColors.length],
                                onPressed: _selectKana,
                              ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _selectedKana == null
                              ? const SizedBox(height: 72)
                              : Text(
                                  _selectedKana!.character,
                                  key: KanaReadingScreen.selectedKanaKey,
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          key: KanaReadingScreen.continueButtonKey,
                          onPressed: widget.onContinue,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Continuar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
