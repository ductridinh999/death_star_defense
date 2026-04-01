import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'defense_game.dart';

enum ShipStyle { redTriangle, redRect, redTriangle3 }

class RebelShip extends PositionComponent
    with TapCallbacks, HasGameReference<DefenseGame> {

  final double speed;
  final ShipStyle style;
  static const double _deathStarRadius = 100.0;

  RebelShip({
    required Vector2 startPosition,
    this.speed = 80,
    this.style = ShipStyle.redTriangle,
  }) : super(
          position: startPosition,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) return;

    final direction = -position.normalized();
    position.add(direction * speed * dt);

    if (position.length < _deathStarRadius) {
      game.takeDamage();
      removeFromParent();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (game.isGameOver) return;
    game.addScore();
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    switch (style) {
      case ShipStyle.redRect:
        _renderRedRect(canvas);
        break;
      case ShipStyle.redTriangle:
      case ShipStyle.redTriangle3:
        _renderRedTriangle(canvas);
        break;
    }
  }

  void _renderRedTriangle(Canvas canvas) {
    final angle = atan2(-position.y, -position.x);

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(angle);

    final path = Path()
      ..moveTo(20, 0)
      ..lineTo(-12, -14)
      ..lineTo(-6, 0)
      ..lineTo(-12, 14)
      ..close();

    final bodyPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawPath(path, bodyPaint);

    final outlinePaint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, outlinePaint);

    final cockpitPaint = Paint()..color = const Color(0xFFFFCDD2);
    canvas.drawCircle(const Offset(2, 0), 4, cockpitPaint);

    canvas.restore();
  }

  void _renderRedRect(Canvas canvas) {
    final angle = atan2(-position.y, -position.x);

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(angle);

    final bodyRect = Rect.fromCenter(
      center: Offset.zero,
      width: 32,
      height: 18,
    );
    final bodyPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawRect(bodyRect, bodyPaint);

    final outlinePaint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(bodyRect, outlinePaint);

    final wingPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawRect(
      const Rect.fromLTWH(-10, -16, 8, 8),
      wingPaint,
    );
    canvas.drawRect(
      const Rect.fromLTWH(-10, 8, 8, 8),
      wingPaint,
    );

    final cockpitPaint = Paint()..color = const Color(0xFFFFCDD2);
    canvas.drawCircle(const Offset(4, 0), 3.5, cockpitPaint);

    canvas.restore();
  }
}

class ShipSpawner extends TimerComponent
    with HasGameReference<DefenseGame> {
  static final Random _random = Random();
  static const double _halfWorld = 400.0;

  final double shipSpeed;
  final ShipStyle shipStyle;

  ShipSpawner({
    required double spawnInterval,
    required this.shipSpeed,
    required this.shipStyle,
  }) : super(
          period: spawnInterval,
          repeat: true,
        );

  @override
  void onTick() {
    if (game.isGameOver) return;

    final edge = _random.nextInt(4);
    late final Vector2 spawnPos;
    final along = _random.nextDouble() * _halfWorld * 2 - _halfWorld;

    switch (edge) {
      case 0:
        spawnPos = Vector2(along, -_halfWorld);
        break;
      case 1:
        spawnPos = Vector2(_halfWorld, along);
        break;
      case 2:
        spawnPos = Vector2(along, _halfWorld);
        break;
      case 3:
        spawnPos = Vector2(-_halfWorld, along);
        break;
    }

    game.world.add(RebelShip(
      startPosition: spawnPos,
      speed: shipSpeed,
      style: shipStyle,
    ));
  }
}
