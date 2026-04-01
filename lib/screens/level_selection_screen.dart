import 'package:flutter/material.dart';
import '../utils/progress_manager.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _highestUnlocked = 1;
  bool _loading = true;

  static const int totalLevels = 3;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final level = await ProgressManager.getHighestUnlockedLevel();
    setState(() {
      _highestUnlocked = level;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose a Level',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: List.generate(totalLevels, (index) {
                        final level = index + 1;
                        final isUnlocked = level <= _highestUnlocked;

                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: isUnlocked
                                ? () async {
                                    await Navigator.pushNamed(
                                      context,
                                      '/game',
                                      arguments: {'level': level},
                                    );
                                    _loadProgress();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isUnlocked ? Icons.lock_open : Icons.lock,
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Level $level',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
