import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'death_star.dart';
import 'rebel_ship.dart';

class DefenseGame extends FlameGame with TapCallbacks {
  final int currentLevel;
  final void Function({required bool won}) onGameEnd;

  DefenseGame({
    required this.currentLevel,
    required this.onGameEnd,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 800,
            height: 800,
          ),
        );

  int health = 3;
  int score = 0;
  bool isGameOver = false;

  static const double _winTime = 30.0;
  double _elapsedTime = 0;

  late TextComponent _healthText;
  late TextComponent _scoreText;
  late TextComponent _timerText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    world.add(DeathStar());
    world.add(_createSpawner());

    _healthText = TextComponent(
      text: 'Health: $health',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    _scoreText = TextComponent(
      text: 'Eliminated: $score',
      position: Vector2(20, 52),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    _timerText = TextComponent(
      text: 'Time: ${_winTime.toInt()}s',
      position: Vector2(20, 84),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.amberAccent,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    camera.viewport.add(_healthText);
    camera.viewport.add(_scoreText);
    camera.viewport.add(_timerText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    _elapsedTime += dt;
    final remaining = (_winTime - _elapsedTime).ceil().clamp(0, _winTime.toInt());
    _timerText.text = 'Time: ${remaining}s';

    if (_elapsedTime >= _winTime) {
      _endGame(won: true);
    }
  }

  void takeDamage() {
    if (isGameOver) return;
    if (health > 0) {
      health--;
      _healthText.text = 'Health: $health';
      if (health <= 0) {
        _endGame(won: false);
      }
    }
  }

  void addScore() {
    score++;
    _scoreText.text = 'Eliminated: $score';
  }

  void _endGame({required bool won}) {
    isGameOver = true;
    pauseEngine();
    onGameEnd(won: won);
  }

  ShipSpawner _createSpawner() {
    switch (currentLevel) {
      case 1:
        return ShipSpawner(
          spawnInterval: 2.0,
          shipSpeed: 60,
          shipStyle: ShipStyle.redTriangle,
        );
      case 2:
        return ShipSpawner(
          spawnInterval: 1.2,
          shipSpeed: 100,
          shipStyle: ShipStyle.redRect,
        );
      case 3:
      default:
        return ShipSpawner(
          spawnInterval: 0.8,
          shipSpeed: 140,
          shipStyle: ShipStyle.redTriangle3,
        );
    }
  }
}
