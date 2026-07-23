  import 'dart:math';
import 'package:flutter/material.dart';

class QuantumBackground extends StatefulWidget {
  const QuantumBackground({super.key});

  @override
  State<QuantumBackground> createState() => _QuantumBackgroundState();
}

class _QuantumBackgroundState extends State<QuantumBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _QuantumPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _QuantumPainter extends CustomPainter {
  final double t;

  _QuantumPainter(this.t);

  final Random random = Random(7);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff05060D),
          Color(0xff090B18),
          Color(0xff04040A),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      bg,
    );

    final center = Offset(
      size.width / 2,
      size.height * .38,
    );

    // Purple Nebula
    final purple = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xff8A4DFF).withOpacity(.25 + t * .10),
          const Color(0xff3E1B9A).withOpacity(.10),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: 320,
        ),
      );

    canvas.drawCircle(center, 320, purple);

    // Blue Core Glow
    final blue = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xff00C8FF).withOpacity(.22),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: 170,
        ),
      );

    canvas.drawCircle(center, 170, blue);

    // Animated Stars
    final starPaint = Paint()..color = Colors.white;

    for (int i = 0; i < 220; i++) {
      final x = (i * 71.0) % size.width;

      final y =
          ((i * 137.0) + (t * 50 * (i % 5))) %
              size.height;

      final r = (i % 3 + 1) * .55;

      canvas.drawCircle(
        Offset(x, y),
        r,
        starPaint..color = Colors.white.withOpacity(.15 + (i % 5) * .15),
      );
    }

    // Floating Energy Particles
    final particle = Paint()
      ..color = const Color(0xff6AE7FF);

    for (int i = 0; i < 45; i++) {
      final angle =
          (i * 8) + (t * pi * 2);

      final radius =
          140 + (i % 5) * 18;

      final dx =
          center.dx +
          cos(angle) * radius;

      final dy =
          center.dy +
          sin(angle) * radius;

      canvas.drawCircle(
        Offset(dx, dy),
        1.5,
        particle..color =
            const Color(0xff6AE7FF)
                .withOpacity(.35),
      );
    }

    // Bottom Fog
    final fog = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xff3A2D7A)
              .withOpacity(.18),
          const Color(0xff000000),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          size.height * .6,
          size.width,
          size.height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * .55,
        size.width,
        size.height,
      ),
      fog,
    );
  }

  @override
  bool shouldRepaint(
      covariant _QuantumPainter oldDelegate) {
    return true;
  }
}