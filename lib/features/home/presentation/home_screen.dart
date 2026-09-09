import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onStart});

  static const String heroAssetPath = 'assets/branding/home/home_hero.png';

  static const Key heroImageKey = ValueKey<String>('home-hero-image');
  static const Key startButtonKey = ValueKey<String>('home-start-button');

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _HomeContent(
                    availableHeight: constraints.maxHeight,
                    onStart: onStart,
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

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.availableHeight, required this.onStart});

  final double availableHeight;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final maximumImageHeight = (availableHeight - 136).clamp(220.0, 720.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maximumImageHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              HomeScreen.heroAssetPath,
              key: HomeScreen.heroImageKey,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              semanticLabel: 'はると文字の世界の紹介イラスト',
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          key: HomeScreen.startButtonKey,
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Empezar'),
        ),
      ],
    );
  }
}
