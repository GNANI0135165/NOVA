import 'dart:math';
import 'package:flutter/material.dart';

class ReactorRing extends StatelessWidget {
  final double size;
  final Animation<double> rotation;
  final double strokeWidth;
  final Color color;

  const ReactorRing({
    super.key,
    required this.size,
    required this.rotation,
    required this.strokeWidth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotation,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotation.value * 2 * pi,
          child: CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  _RingPainter({
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    final pattern = <double>[
      .42,
      .16,
      .30,
      .10,
      .55,
      .18,
      .22,
      .12,
      .38,
      .14,
      .28,
      .16,
    ];

    double angle = 0;

    for (int i = 0; i < pattern.length; i++) {
      final sweep = pattern[i];

      glow.color = color.withOpacity(.22);

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        angle,
        sweep,
        false,
        glow,
      );

      paint.color = color;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        angle,
        sweep,
        false,
        paint,
      );

      angle += sweep + .14;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}