import 'dart:math';
import 'package:flutter/material.dart';

class QuantumBackground extends StatefulWidget {
  const QuantumBackground({super.key});

  @override
  State<QuantumBackground> createState() => _QuantumBackgroundState();
}

class _QuantumBackgroundState extends State<QuantumBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;

  @override
  void initState() {
    super.initState();

    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          return CustomPaint(
            painter: _QuantumBackgroundPainter(
              animation.value,
            ),
          );
        },
      ),
    );
  }
}

class _QuantumBackgroundPainter extends CustomPainter {
  final double t;

  _QuantumBackgroundPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ─────────────────────────────────────────────
    // DEEP SPACE BACKGROUND
    // ─────────────────────────────────────────────

    final background = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -0.05),
        radius: 1.15,
        colors: [
          Color(0xFF08091B),
          Color(0xFF03040D),
          Color(0xFF010208),
        ],
        stops: [
          0.0,
          0.55,
          1.0,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, background);

    final center = Offset(
      size.width * .5,
      size.height * .42,
    );

    // ─────────────────────────────────────────────
    // LARGE ATMOSPHERIC PURPLE FIELD
    // ─────────────────────────────────────────────

    final purpleGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF5932D8).withOpacity(.16),
          const Color(0xFF302080).withOpacity(.08),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: size.width * .45,
        ),
      );

    canvas.drawCircle(
      center,
      size.width * .45,
      purpleGlow,
    );

    // ─────────────────────────────────────────────
    // CYAN ATMOSPHERIC FIELD
    // ─────────────────────────────────────────────

    final cyanGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF006A9C).withOpacity(.08),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            center.dx,
            center.dy + 40,
          ),
          radius: size.width * .38,
        ),
      );

    canvas.drawCircle(
      Offset(
        center.dx,
        center.dy + 40,
      ),
      size.width * .38,
      cyanGlow,
    );

    // ─────────────────────────────────────────────
    // STAR FIELD
    // ─────────────────────────────────────────────

    final random = Random(92831);

    for (int i = 0; i < 180; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      final radius =
          .35 + random.nextDouble() * 1.35;

      final twinkle =
          .35 +
          ((sin(
                    t * pi * 2 *
                        (1.0 + random.nextDouble() * 2.0) +
                    i,
                  ) +
                  1) /
              2) *
              .55;

      final paint = Paint()
        ..color = Colors.white.withOpacity(twinkle);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    // ─────────────────────────────────────────────
    // BLUE / PURPLE PARTICLES
    // ─────────────────────────────────────────────

    for (int i = 0; i < 55; i++) {
      final angle = random.nextDouble() * pi * 2;
      final distance =
          size.width * (.18 + random.nextDouble() * .38);

      final x =
          center.dx +
          cos(angle + t * pi * .15) * distance;

      final y =
          center.dy +
          sin(angle + t * pi * .15) * distance;

      final paint = Paint()
        ..color = (i.isEven
                ? const Color(0xFF5A9CFF)
                : const Color(0xFF9B63FF))
            .withOpacity(
          .18 + random.nextDouble() * .38,
        );

      canvas.drawCircle(
        Offset(x, y),
        .5 + random.nextDouble() * 1.2,
        paint,
      );
    }

    // ─────────────────────────────────────────────
    // VERY SUBTLE TECHNICAL GRID
    // ─────────────────────────────────────────────

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = const Color(0xFF5360A0).withOpacity(.035);

    const gridSize = 80.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // ─────────────────────────────────────────────
    // FADING RADIAL LINES BEHIND CORE
    // ─────────────────────────────────────────────

    final radialPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7
      ..color = const Color(0xFF8A4DFF).withOpacity(.035);

    final maxRadius = size.width * .65;

    for (int i = 0; i < 12; i++) {
      final angle =
          i * pi / 6 + t * pi * .03;

      final start = Offset(
        center.dx + cos(angle) * 130,
        center.dy + sin(angle) * 130,
      );

      final end = Offset(
        center.dx + cos(angle) * maxRadius,
        center.dy + sin(angle) * maxRadius,
      );

      canvas.drawLine(
        start,
        end,
        radialPaint,
      );
    }

    // ─────────────────────────────────────────────
    // VIGNETTE
    // ─────────────────────────────────────────────

    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          Colors.black.withOpacity(.42),
        ],
        stops: const [
          0.35,
          0.68,
          1.0,
        ],
      ).createShader(rect);

    canvas.drawRect(
      rect,
      vignette,
    );
  }

  @override
  bool shouldRepaint(
    covariant _QuantumBackgroundPainter oldDelegate,
  ) {
    return oldDelegate.t != t;
  }
}