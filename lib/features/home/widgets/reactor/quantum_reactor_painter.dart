import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'reactor_controller.dart';

class QuantumReactorPainter extends CustomPainter {
  final double rotation;
  final double pulse;
  final ReactorState state;

  QuantumReactorPainter({
    required this.rotation,
    required this.pulse,
    required this.state,
  });

  double get intensity {
    switch (state) {
      case ReactorState.idle:
        return 0.72;
      case ReactorState.listening:
        return 1.0;
      case ReactorState.thinking:
        return 1.25;
      case ReactorState.speaking:
        return 1.05;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2;

    _drawAmbientGlow(canvas, c, r);
    _drawOuterMechanicalSystem(canvas, c, r);
    _drawOuterSegments(canvas, c, r);
    _drawTechnicalTracks(canvas, c, r);
    _drawRadialMechanisms(canvas, c, r);
    _drawEnergyArcs(canvas, c, r);
    _drawInnerReactor(canvas, c, r);
    _drawHexShield(canvas, c, r);
    _drawEnergyFilaments(canvas, c, r);
    _drawPlasmaCore(canvas, c, r);
    _drawCoreRays(canvas, c, r);
    _drawNodes(canvas, c, r);
  }

  void _drawAmbientGlow(Canvas canvas, Offset c, double r) {
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF7B2CFF).withOpacity(0.22 * intensity),
          const Color(0xFF244CFF).withOpacity(0.12 * intensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: c, radius: r));

    canvas.drawCircle(c, r, glow);
  }

  void _drawOuterMechanicalSystem(Canvas canvas, Offset c, double r) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF8B7DFF).withOpacity(0.35 * intensity);

    for (final radius in [
      r * .94,
      r * .90,
      r * .84,
      r * .78,
    ]) {
      canvas.drawCircle(c, radius, paint);
    }

    final fine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7
      ..color = const Color(0xFF39D9FF).withOpacity(.28);

    for (final radius in [
      r * .97,
      r * .87,
      r * .73,
    ]) {
      canvas.drawCircle(c, radius, fine);
    }
  }

  void _drawOuterSegments(Canvas canvas, Offset c, double r) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = r * .035
      ..color = const Color(0xFF7754FF).withOpacity(.8 * intensity);

    const count = 48;
    final radius = r * .865;

    for (int i = 0; i < count; i++) {
      final start =
          rotation * 2 * math.pi + i * 2 * math.pi / count + .035;

      final sweep = i % 5 == 0 ? .075 : .105;

      canvas.drawArc(
        Rect.fromCircle(center: c, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }

    final cyan = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .012
      ..color = const Color(0xFF00D9FF).withOpacity(.75 * intensity);

    for (int i = 0; i < 24; i++) {
      if (i % 3 == 0) {
        final a = -rotation * 2 * math.pi +
            i * 2 * math.pi / 24;

        canvas.drawArc(
          Rect.fromCircle(center: c, radius: r * .79),
          a,
          .09,
          false,
          cyan,
        );
      }
    }
  }

  void _drawTechnicalTracks(Canvas canvas, Offset c, double r) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFB7AFFF).withOpacity(.5);

    for (int i = 0; i < 72; i++) {
      final a = rotation * math.pi * 2 +
          i * math.pi * 2 / 72;

      final inner = r * .69;
      final outer = i % 4 == 0 ? r * .77 : r * .735;

      final p1 = Offset(
        c.dx + math.cos(a) * inner,
        c.dy + math.sin(a) * inner,
      );

      final p2 = Offset(
        c.dx + math.cos(a) * outer,
        c.dy + math.sin(a) * outer,
      );

      canvas.drawLine(p1, p2, paint);
    }

    final cyan = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFF00E5FF).withOpacity(.65);

    for (int i = 0; i < 12; i++) {
      final a = -rotation * 2 * math.pi +
          i * math.pi * 2 / 12;

      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * .62),
        a,
        .22,
        false,
        cyan,
      );
    }
  }

  void _drawRadialMechanisms(Canvas canvas, Offset c, double r) {
    final mech = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF9185FF).withOpacity(.7);

    for (int i = 0; i < 16; i++) {
      final a = -rotation * 2 * math.pi +
          i * math.pi * 2 / 16;

      final inner = r * .72;
      final outer = r * .91;

      final p1 = Offset(
        c.dx + math.cos(a) * inner,
        c.dy + math.sin(a) * inner,
      );

      final p2 = Offset(
        c.dx + math.cos(a) * outer,
        c.dy + math.sin(a) * outer,
      );

      canvas.drawLine(p1, p2, mech);

      final node = Offset(
        c.dx + math.cos(a) * r * .91,
        c.dy + math.sin(a) * r * .91,
      );

      canvas.drawCircle(node, r * .012, mech);
    }
  }

  void _drawEnergyArcs(Canvas canvas, Offset c, double r) {
    final purple = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .018
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFA855FF).withOpacity(.9 * intensity);

    final cyan = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .012
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF00E5FF).withOpacity(.85 * intensity);

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * .57),
      rotation * 3,
      math.pi * .62,
      false,
      purple,
    );

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * .53),
      -rotation * 4 + math.pi,
      math.pi * .42,
      false,
      cyan,
    );

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * .48),
      rotation * 5 + 1,
      math.pi * .28,
      false,
      purple,
    );
  }

  void _drawInnerReactor(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF4DCCFF).withOpacity(.6);

    for (final radius in [
      r * .60,
      r * .55,
      r * .46,
    ]) {
      canvas.drawCircle(c, radius, p);
    }

    final purple = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = const Color(0xFF9A4DFF).withOpacity(.8);

    for (int i = 0; i < 8; i++) {
      final a = rotation * 2 * math.pi +
          i * math.pi / 4;

      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * .42),
        a,
        .20,
        false,
        purple,
      );
    }
  }

  void _drawHexShield(Canvas canvas, Offset c, double r) {
    final path = Path();

    final radius = r * .39;

    for (int i = 0; i < 6; i++) {
      final a = rotation * .25 +
          i * math.pi / 3 -
          math.pi / 2;

      final p = Offset(
        c.dx + math.cos(a) * radius,
        c.dy + math.sin(a) * radius,
      );

      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    path.close();

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .035
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..color = const Color(0xFF6B35FF).withOpacity(.55);

    canvas.drawPath(path, glow);

    final shield = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .012
      ..color = const Color(0xFFB36BFF).withOpacity(.9);

    canvas.drawPath(path, shield);

    final cyan = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .006
      ..color = const Color(0xFF00E5FF).withOpacity(.8);

    canvas.drawPath(
      _hexPath(c, r * .32, rotation * -.35),
      cyan,
    );
  }

  Path _hexPath(Offset c, double radius, double angle) {
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final a = angle + i * math.pi / 3 - math.pi / 2;

      final p = Offset(
        c.dx + math.cos(a) * radius,
        c.dy + math.sin(a) * radius,
      );

      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    path.close();
    return path;
  }

  void _drawEnergyFilaments(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF9D5CFF).withOpacity(.65);

    for (int i = 0; i < 10; i++) {
      final a = rotation * 2 + i * math.pi * 2 / 10;

      final path = Path();

      for (int j = 0; j < 5; j++) {
        final rr = r * (.17 + j * .045);
        final aa = a + math.sin(j * 3 + rotation * 4) * .15;

        final point = Offset(
          c.dx + math.cos(aa) * rr,
          c.dy + math.sin(aa) * rr,
        );

        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }

      canvas.drawPath(path, p);
    }
  }

  void _drawPlasmaCore(Canvas canvas, Offset c, double r) {
    final coreRadius = r * .19 * (1 + pulse * .04);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(.95),
          const Color(0xFFB95CFF).withOpacity(.9),
          const Color(0xFF742DFF).withOpacity(.55),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: c,
          radius: coreRadius * 2.4,
        ),
      );

    canvas.drawCircle(c, coreRadius * 2.4, glow);

    final plasma = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          const Color(0xFFE0B8FF),
          const Color(0xFF9A45FF),
          const Color(0xFF4518A8),
        ],
      ).createShader(
        Rect.fromCircle(
          center: c,
          radius: coreRadius,
        ),
      );

    canvas.drawCircle(c, coreRadius, plasma);

    final hot = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Colors.white.withOpacity(.9),
          const Color(0xFFB96CFF).withOpacity(.1),
        ],
      ).createShader(
        Rect.fromCircle(
          center: c,
          radius: coreRadius * .65,
        ),
      );

    canvas.drawCircle(c, coreRadius * .65, hot);

    final center = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(c, coreRadius * .25, center);
  }

  void _drawCoreRays(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..strokeWidth = 1.5
      ..color = const Color(0xFF8D55FF).withOpacity(.65 * intensity);

    for (int i = 0; i < 24; i++) {
      final a = rotation * 5 + i * math.pi * 2 / 24;

      final inner = r * .20;
      final outer = r * (.27 + (i % 3) * .025);

      canvas.drawLine(
        Offset(
          c.dx + math.cos(a) * inner,
          c.dy + math.sin(a) * inner,
        ),
        Offset(
          c.dx + math.cos(a) * outer,
          c.dy + math.sin(a) * outer,
        ),
        p,
      );
    }
  }

  void _drawNodes(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(.9 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    for (int i = 0; i < 12; i++) {
      final a = rotation * 2 +
          i * math.pi * 2 / 12;

      canvas.drawCircle(
        Offset(
          c.dx + math.cos(a) * r * .63,
          c.dy + math.sin(a) * r * .63,
        ),
        r * .012,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant QuantumReactorPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.pulse != pulse ||
        oldDelegate.state != state;
  }
}
