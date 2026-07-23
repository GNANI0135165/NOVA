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
      builder: (context, child) {
        return CustomPaint(
          size: Size.square(size),
          painter: _OrbitPainter(animation.value),
        );
      },
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;

  _OrbitPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const count = 4;

    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i + (progress * 2 * pi);

      final x = center.dx + cos(angle) * (size.width * 0.36);
      final y = center.dy + sin(angle) * (size.width * 0.36);

      canvas.drawCircle(
        Offset(x, y),
        3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}