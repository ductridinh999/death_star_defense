import 'package:flutter/material.dart';
import '../utils/progress_manager.dart';

class ResultScreen extends StatelessWidget {
  final bool won;
  final int level;

  const ResultScreen({super.key, required this.won, required this.level});

  @override
  Widget build(BuildContext context) {
    if (won) {
      ProgressManager.saveHighestUnlockedLevel(level + 1);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 100,
                color: won ? Colors.amber : Colors.redAccent,
              ),
              const SizedBox(height: 24),
              Text(
                won ? 'Victory!' : 'Defeat!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: won ? Colors.green : Colors.red,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                won
                    ? 'You defended level $level successfully!'
                    : 'The rebels broke through on level $level.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/levels');
                },
                icon: const Icon(Icons.list),
                label: const Text('Back to Levels'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
