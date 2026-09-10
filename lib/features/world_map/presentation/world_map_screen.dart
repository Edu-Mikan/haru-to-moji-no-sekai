import 'package:flutter/material.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key, this.onOpenFirstStop});

  static const Key screenKey = ValueKey<String>('world-map-screen');

  static const Key mapPlaceholderKey = ValueKey<String>(
    'world-map-placeholder',
  );

  static const Key firstStopButtonKey = ValueKey<String>(
    'world-map-first-stop-button',
  );

  final VoidCallback? onOpenFirstStop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('El mundo de はる'), centerTitle: true),
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
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 2,
                          child: DecoratedBox(
                            key: mapPlaceholderKey,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.map_rounded,
                                size: 112,
                                color: Theme.of(context).colorScheme.primary,
                                semanticLabel:
                                    'Mapa provisional del mundo de はる',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          key: firstStopButtonKey,
                          onPressed: onOpenFirstStop,
                          icon: const Icon(Icons.location_on_rounded),
                          label: const Text('Primera parada'),
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
