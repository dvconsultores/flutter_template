import 'dart:math' as math;

import 'package:flutter/material.dart';

///! Just whowCase widget
class SmileFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Draw the body
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color.fromARGB(255, 247, 172, 59),
    );

    // Draw the mouth
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(center.dx, center.dy), height: 110, width: 120),
      .3,
      2.5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round,
    );

    // Draw the eyes
    canvas.drawCircle(
      Offset(center.dx - radius / 3, center.dy - radius / 3),
      18,
      Paint(),
    );
    canvas.drawCircle(
      Offset(center.dx + radius / 3, center.dy - radius / 3),
      18,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant SmileFacePainter oldDelegate) => true;
}
