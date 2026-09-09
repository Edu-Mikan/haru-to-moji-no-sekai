import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onStart});

  static const Key titleKey = ValueKey<String>('home-title');
  static const Key heroPlaceholderKey = ValueKey<String>(
    'home-hero-placeholder',
  );
  static const Key startButtonKey = ValueKey<String>('home-start-button');

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: isWide
                      ? _WideHomeContent(onStart: onStart)
                      : _CompactHomeContent(onStart: onStart),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompactHomeContent extends StatelessWidget {
  const _CompactHomeContent({required this.onStart});

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _HomeHeroPlaceholder(),
        const SizedBox(height: 32),
        const _HomeTitle(),
        const SizedBox(height: 32),
        _StartButton(onPressed: onStart),
      ],
    );
  }
}

class _WideHomeContent extends StatelessWidget {
  const _WideHomeContent({required this.onStart});

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 3, child: _HomeHeroPlaceholder()),
        const SizedBox(width: 48),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _HomeTitle(),
              const SizedBox(height: 32),
              _StartButton(onPressed: onStart),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeHeroPlaceholder extends StatelessWidget {
  const _HomeHeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: HomeScreen.heroPlaceholderKey,
      aspectRatio: 4 / 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.landscape_rounded,
          size: 96,
          color: Theme.of(context).colorScheme.primary,
          semanticLabel: 'Imagen de presentación provisional',
        ),
      ),
    );
  }
}

class _HomeTitle extends StatelessWidget {
  const _HomeTitle();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        'はるともじのせかい',
        key: HomeScreen.titleKey,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: HomeScreen.startButtonKey,
      onPressed: onPressed,
      icon: const Icon(Icons.play_arrow_rounded),
      label: const Text('Empezar'),
    );
  }
}
