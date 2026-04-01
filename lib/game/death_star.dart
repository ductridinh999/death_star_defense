import 'dart:ui';

import 'package:flame/components.dart';

class DeathStar extends PositionComponent {
  DeathStar()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 0),
          size: Vector2(200, 200),
        );

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;

    final bodyPaint = Paint()..color = const Color(0xFF9E9E9E);
    canvas.drawCircle(center, radius, bodyPaint);

    final trenchPaint = Paint()
      ..color = const Color(0xFF616161)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.15,
      3.43,
      false,
      trenchPaint,
    );

    final dishCenter = Offset(center.dx + radius * 0.25, center.dy - radius * 0.25);
    final dishRadius = radius * 0.30;
    final dishPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawCircle(dishCenter, dishRadius, dishPaint);

    final indentPaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(dishCenter, dishRadius * 0.45, indentPaint);

    final detailPaint = Paint()
      ..color = const Color(0xFF757575)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (final fraction in [0.3, 0.7]) {
      final y = size.y * fraction;
      final dy = (y - center.dy).abs();
      if (dy < radius) {
        final chordHalf = _sqrt(radius * radius - dy * dy);
        canvas.drawLine(
          Offset(center.dx - chordHalf, y),
          Offset(center.dx + chordHalf, y),
          detailPaint,
        );
      }
    }
  }

  static double _sqrt(double value) {
    if (value <= 0) return 0;
    double x = value;
    for (int i = 0; i < 10; i++) {
      x = (x + value / x) / 2;
    }
    return x;
  }
}

