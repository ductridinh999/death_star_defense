import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Death Star Defense'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield,
                size: 100,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 16),
              Text(
                'Death Star Defense',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Defend the Death Star!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final buttons = [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/levels');
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Game'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16, height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Death Star Defense',
                          children: [
                            const Text(
                              'A tower-defense style game where you protect '
                              'the Death Star from incoming rebel ships.\n\n'
                              'Click or tap on the rebel ships to destroy them before '
                              'they reach the Death Star. Survive for 30 seconds '
                              'without losing all your health to win the level.',
                            ),
                          ],
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Instruction'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ];

                  if (constraints.maxWidth > 600) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buttons,
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: buttons,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
