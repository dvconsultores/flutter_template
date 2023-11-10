import 'package:flutter/material.dart';

/// Triangle painter.
class TrianglePainter extends CustomPainter {
  TrianglePainter({
    this.strokeColor = Colors.black,
    this.paintingStyle = PaintingStyle.stroke,
    this.strokeWidth = 1,
    this.getTrianglePath,
  });
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  Path Function(double x, double y)? getTrianglePath;

  static double convertRadiusToSigma(double radius) => radius * 0.57735 + 0.5;

  Path _defaultTrianglePath(double x, double y) => Path()
    ..moveTo(0, y / 2)
    ..lineTo(x, 0)
    ..lineTo(x, y)
    ..lineTo(0, y / 2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(10));

    final path = getTrianglePath != null
        ? getTrianglePath!(size.width, size.height)
        : _defaultTrianglePath(size.width, size.height);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) =>
      oldDelegate.strokeColor != strokeColor ||
      oldDelegate.paintingStyle != paintingStyle ||
      oldDelegate.strokeWidth != strokeWidth;
}
