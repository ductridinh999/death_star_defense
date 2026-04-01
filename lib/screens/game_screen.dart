import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/defense_game.dart';

class GameScreen extends StatefulWidget {
  final int level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final DefenseGame _game;

  @override
  void initState() {
    super.initState();
    _game = DefenseGame(
      currentLevel: widget.level,
      onGameEnd: _handleGameEnd,
    );
  }

  void _handleGameEnd({required bool won}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: {'won': won, 'level': widget.level},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level}'),
        centerTitle: true,
      ),
      body: GameWidget(game: _game),
    );
  }
}
