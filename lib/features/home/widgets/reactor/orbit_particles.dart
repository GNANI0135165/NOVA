import 'dart:math';
import 'package:flutter/material.dart';

class OrbitParticles extends StatelessWidget {
  final double size;
  final Animation<double> animation;

  const OrbitParticles({
    super.key,
    required this.size,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          size: Size.square(size),
          painter: _QuantumParticlePainter(
            animation.value,
          ),
        );
      },
    );
  }
}

class _QuantumParticlePainter extends CustomPainter {
  final double t;

  _QuantumParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    // Fixed deterministic particle positions.
    final random = Random(731);

    // ─────────────────────────────────────────────
    // 1. OUTER STAR / ENERGY PARTICLES
    // ─────────────────────────────────────────────

    for (int i = 0; i < 70; i++) {
      final angle = random.nextDouble() * pi * 2;
      final radius =
          size.width * (.36 + random.nextDouble() * .15);

      final speed =
          .25 + random.nextDouble() * .8;

      final currentAngle =
          angle + t * pi * 2 * speed;

      final x = center.dx + cos(currentAngle) * radius;
      final y = center.dy + sin(currentAngle) * radius;

      final particleSize =
          .7 + random.nextDouble() * 1.8;

      final opacity =
          .25 + random.nextDouble() * .65;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
    }

    // ─────────────────────────────────────────────
    // 2. CYAN ORBIT PARTICLES
    // ─────────────────────────────────────────────

    for (int i = 0; i < 28; i++) {
      final angle =
          (pi * 2 / 28) * i + t * pi * 2 * .7;

      final radius =
          size.width * (.39 + (i % 4) * .008);

      final position = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      final paint = Paint()
        ..color = const Color(0xFF00C8FF)
            .withOpacity(.65);

      canvas.drawCircle(
        position,
        i % 5 == 0 ? 2.6 : 1.3,
        paint,
      );
    }

    // ─────────────────────────────────────────────
    // 3. PURPLE ORBIT PARTICLES
    // ─────────────────────────────────────────────

    for (int i = 0; i < 24; i++) {
      final angle =
          (pi * 2 / 24) * i - t * pi * 2 * .45;

      final radius =
          size.width * (.45 + (i % 3) * .006);

      final position = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      final paint = Paint()
        ..color = const Color(0xFF9B5CFF)
            .withOpacity(.8);

      canvas.drawCircle(
        position,
        i % 4 == 0 ? 2.2 : 1.1,
        paint,
      );
    }

    // ─────────────────────────────────────────────
    // 4. FAST ENERGY STREAKS
    // ─────────────────────────────────────────────

    final streakPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF7B5CFF)
          .withOpacity(.65);

    for (int i = 0; i < 10; i++) {
      final angle =
          (pi * 2 / 10) * i + t * pi * 2;

      final r1 = size.width * .43;
      final r2 = r1 + 8;

      final p1 = Offset(
        center.dx + cos(angle) * r1,
        center.dy + sin(angle) * r1,
      );

      final p2 = Offset(
        center.dx + cos(angle) * r2,
        center.dy + sin(angle) * r2,
      );

      canvas.drawLine(p1, p2, streakPaint);
    }

    // ─────────────────────────────────────────────
    // 5. INNER FLOATING PARTICLES
    // ─────────────────────────────────────────────

    for (int i = 0; i < 20; i++) {
      final angle =
          random.nextDouble() * pi * 2 +
          t * pi * 2 * .3;

      final radius =
          size.width * (.22 + random.nextDouble() * .12);

      final position = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      final paint = Paint()
        ..color = Colors.white.withOpacity(.55);

      canvas.drawCircle(
        position,
        .8 + random.nextDouble() * 1.2,
        paint,
      );
    }

    // ─────────────────────────────────────────────
    // 6. CARDINAL ENERGY NODES
    // ─────────────────────────────────────────────

    final nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFB98CFF);

    for (int i = 0; i < 8; i++) {
      final angle =
          i * pi / 4 + t * pi * 2 * .25;

      final radius = size.width * .42;

      final position = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      canvas.drawCircle(
        position,
        2.4,
        nodePaint,
      );

      // Small glow around node.
      final glow = Paint()
        ..color = const Color(0xFF8A4DFF)
            .withOpacity(.3)
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          5,
        );

      canvas.drawCircle(
        position,
        5,
        glow,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _QuantumParticlePainter oldDelegate,
  ) {
    return oldDelegate.t != t;
  }
}