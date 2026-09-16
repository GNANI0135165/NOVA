import 'dart:math';
import 'package:flutter/material.dart';

class PlasmaCore extends StatelessWidget {
  final double size;
  final Animation<double> pulse;

  const PlasmaCore({
    super.key,
    required this.size,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) {
        final scale = pulse.value;

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: size * 2.0,
            height: size * 2.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ─────────────────────────────────
                // AMBIENT PLASMA FIELD
                // ─────────────────────────────────

                Container(
                  width: size * 1.9,
                  height: size * 1.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8A4DFF).withOpacity(.32),
                        const Color(0xFF285DFF).withOpacity(.20),
                        const Color(0xFF00C8FF).withOpacity(.10),
                        Colors.transparent,
                      ],
                      stops: const [
                        0.0,
                        0.35,
                        0.65,
                        1.0,
                      ],
                    ),
                  ),
                ),

                // ─────────────────────────────────
                // HEXAGONAL ENERGY SHIELD
                // ─────────────────────────────────

                CustomPaint(
                  size: Size.square(size * 1.65),
                  painter: _HexShieldPainter(
                    pulse: pulse.value,
                  ),
                ),

                // ─────────────────────────────────
                // INNER ENERGY RINGS
                // ─────────────────────────────────

                CustomPaint(
                  size: Size.square(size * 1.35),
                  painter: _EnergyShellPainter(
                    pulse: pulse.value,
                  ),
                ),

                // ─────────────────────────────────
                // PLASMA SPHERE
                // ─────────────────────────────────

                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFE8CFFF),
                        Color(0xFF9D5CFF),
                        Color(0xFF5730D8),
                        Color(0xFF163FA8),
                      ],
                      stops: [
                        0.0,
                        0.16,
                        0.42,
                        0.72,
                        1.0,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8A4DFF)
                            .withOpacity(.65),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: const Color(0xFF00C8FF)
                            .withOpacity(.35),
                        blurRadius: 65,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                ),

                // ─────────────────────────────────
                // HOT CORE
                // ─────────────────────────────────

                Container(
                  width: size * .28,
                  height: size * .28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(.9),
                        blurRadius: 18,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: const Color(0xFFB56CFF)
                            .withOpacity(.8),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),

                // ─────────────────────────────────
                // CORE CROSS ENERGY
                // ─────────────────────────────────

                CustomPaint(
                  size: Size.square(size * 1.2),
                  painter: _CoreEnergyPainter(
                    pulse: pulse.value,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════
// HEXAGON SHIELD
// ═══════════════════════════════════════════════

class _HexShieldPainter extends CustomPainter {
  final double pulse;

  _HexShieldPainter({
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * .43;

    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * pi / 3;

      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color(0xFF8A4DFF)
          .withOpacity(.35)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0xFFB67AFF)
          .withOpacity(.85);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);

    // Inner hexagon.
    final innerPath = Path();
    final innerRadius = radius * .72;

    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * pi / 3;

      final point = Offset(
        center.dx + cos(angle) * innerRadius,
        center.dy + sin(angle) * innerRadius,
      );

      if (i == 0) {
        innerPath.moveTo(point.dx, point.dy);
      } else {
        innerPath.lineTo(point.dx, point.dy);
      }
    }

    innerPath.close();

    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF00C8FF)
          .withOpacity(.55);

    canvas.drawPath(innerPath, innerPaint);

    // Hex vertices.
    final vertexPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(.9);

    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * pi / 3;

      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      canvas.drawCircle(point, 2.5, vertexPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HexShieldPainter oldDelegate) {
    return oldDelegate.pulse != pulse;
  }
}

// ═══════════════════════════════════════════════
// ENERGY SHELL
// ═══════════════════════════════════════════════

class _EnergyShellPainter extends CustomPainter {
  final double pulse;

  _EnergyShellPainter({
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF00C8FF)
          .withOpacity(.28)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF00C8FF)
          .withOpacity(.55);

    final radius = size.width * .36;

    // Broken energy arcs.
    for (int i = 0; i < 8; i++) {
      final start = i * pi / 4;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        start,
        .23,
        false,
        glow,
      );

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        start,
        .23,
        false,
        line,
      );
    }

    // Tiny radial energy connectors.
    final connectorPaint = Paint()
      ..strokeWidth = 1
      ..color = const Color(0xFF8A4DFF)
          .withOpacity(.65);

    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;

      final r1 = radius * .72;
      final r2 = radius * .95;

      canvas.drawLine(
        Offset(
          center.dx + cos(angle) * r1,
          center.dy + sin(angle) * r1,
        ),
        Offset(
          center.dx + cos(angle) * r2,
          center.dy + sin(angle) * r2,
        ),
        connectorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyShellPainter oldDelegate) {
    return oldDelegate.pulse != pulse;
  }
}

// ═══════════════════════════════════════════════
// CORE ENERGY CROSS
// ═══════════════════════════════════════════════

class _CoreEnergyPainter extends CustomPainter {
  final double pulse;

  _CoreEnergyPainter({
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final paint = Paint()
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(.7);

    final length = size.width * .42;

    canvas.drawLine(
      Offset(center.dx - length, center.dy),
      Offset(center.dx + length, center.dy),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - length),
      Offset(center.dx, center.dy + length),
      paint,
    );

    final dotPaint = Paint()
      ..color = const Color(0xFF00C8FF)
          .withOpacity(.9);

    canvas.drawCircle(
      Offset(center.dx - length, center.dy),
      2,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(center.dx + length, center.dy),
      2,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy - length),
      2,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy + length),
      2,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CoreEnergyPainter oldDelegate) {
    return oldDelegate.pulse != pulse;
  }
}