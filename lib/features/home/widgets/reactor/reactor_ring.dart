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
      builder: (_, __) {
        return Transform.rotate(
          angle: rotation.value * 2 * pi,
          child: CustomPaint(
            size: Size.square(size),
            painter: _QuantumRingPainter(
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class _QuantumRingPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  const _QuantumRingPainter({
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // ─────────────────────────────────────────────
    // 1. OUTER ENERGY GLOW
    // ─────────────────────────────────────────────

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 7
      ..color = color.withOpacity(0.16)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      );

    canvas.drawCircle(
      center,
      radius - strokeWidth * 0.5,
      glow,
    );

    // ─────────────────────────────────────────────
    // 2. THIN TECHNICAL TRACKS
    // ─────────────────────────────────────────────

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color.withOpacity(0.45);

    canvas.drawCircle(
      center,
      radius - 5,
      trackPaint,
    );

    canvas.drawCircle(
      center,
      radius - 13,
      trackPaint,
    );

    canvas.drawCircle(
      center,
      radius + 5,
      trackPaint,
    );

    // ─────────────────────────────────────────────
    // 3. MAIN SEGMENTED RING
    // ─────────────────────────────────────────────

    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = strokeWidth
      ..color = color;

    final segmentGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = strokeWidth + 5
      ..color = color.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        6,
      );

    const segments = 72;
    final gap = 0.035;

    for (int i = 0; i < segments; i++) {
      final start = (2 * pi / segments) * i;

      double sweep;

      // Different mechanical segment sizes.
      if (i % 11 == 0) {
        sweep = 0.095;
      } else if (i % 7 == 0) {
        sweep = 0.065;
      } else if (i % 3 == 0) {
        sweep = 0.045;
      } else {
        sweep = 0.025;
      }

      sweep -= gap;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - strokeWidth * 0.5,
        ),
        start,
        sweep,
        false,
        segmentGlow,
      );

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - strokeWidth * 0.5,
        ),
        start,
        sweep,
        false,
        segmentPaint,
      );
    }

    // ─────────────────────────────────────────────
    // 4. RADIAL MECHANICAL MARKERS
    // ─────────────────────────────────────────────

    final markerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square
      ..color = color.withOpacity(0.8);

    const markers = 24;

    for (int i = 0; i < markers; i++) {
      final angle = (2 * pi / markers) * i;

      final outerRadius = radius + 4;
      final innerRadius = i % 3 == 0
          ? radius - 18
          : radius - 10;

      final outer = Offset(
        center.dx + cos(angle) * outerRadius,
        center.dy + sin(angle) * outerRadius,
      );

      final inner = Offset(
        center.dx + cos(angle) * innerRadius,
        center.dy + sin(angle) * innerRadius,
      );

      canvas.drawLine(
        inner,
        outer,
        markerPaint,
      );
    }

    // ─────────────────────────────────────────────
    // 5. LONG TECHNICAL TICKS
    // ─────────────────────────────────────────────

    final tickPaint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square
      ..color = color.withOpacity(0.9);

    const ticks = 12;

    for (int i = 0; i < ticks; i++) {
      final angle = (2 * pi / ticks) * i;

      final r1 = radius - 27;
      final r2 = radius - 9;

      final p1 = Offset(
        center.dx + cos(angle) * r1,
        center.dy + sin(angle) * r1,
      );

      final p2 = Offset(
        center.dx + cos(angle) * r2,
        center.dy + sin(angle) * r2,
      );

      canvas.drawLine(
        p1,
        p2,
        tickPaint,
      );
    }

    // ─────────────────────────────────────────────
    // 6. SMALL INNER CIRCUIT MARKS
    // ─────────────────────────────────────────────

    final circuitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color.withOpacity(0.7);

    const circuits = 36;

    for (int i = 0; i < circuits; i++) {
      if (i % 2 != 0) continue;

      final angle = (2 * pi / circuits) * i;

      final r = radius - 25;

      final p = Offset(
        center.dx + cos(angle) * r,
        center.dy + sin(angle) * r,
      );

      canvas.drawCircle(
        p,
        i % 6 == 0 ? 3 : 1.5,
        circuitPaint,
      );
    }

    // ─────────────────────────────────────────────
    // 7. ENERGY BREAKS
    // ─────────────────────────────────────────────

    final energyPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.8
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.85);

    const energyPositions = [
      0.15,
      1.8,
      3.25,
      4.7,
      5.55,
    ];

    for (final angle in energyPositions) {
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - strokeWidth * 0.5,
        ),
        angle,
        0.07,
        false,
        energyPaint,
      );
    }

    // ─────────────────────────────────────────────
    // 8. CENTER GUIDE RING
    // ─────────────────────────────────────────────

    final innerGuide = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color.withOpacity(0.35);

    canvas.drawCircle(
      center,
      radius * 0.72,
      innerGuide,
    );
  }

  @override
  bool shouldRepaint(covariant _QuantumRingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}