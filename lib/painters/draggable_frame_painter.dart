import 'package:flutter/material.dart';

class DraggableFramePainter extends CustomPainter {
  const DraggableFramePainter({
    this.bgColor,
    this.color,
  });
  final Color? bgColor;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = bgColor ?? Colors.blue,
        bgRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(0),
        );

    canvas.drawRRect(bgRect, bgPaint);

    final linePaint = Paint()..color = color ?? Colors.white,
        width = 32.0,
        height = 4.0,
        lineRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width / 2 - width / 2,
            size.height / 2,
            width,
            height,
          ),
          const Radius.circular(100),
        );

    canvas.drawRRect(lineRect, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
