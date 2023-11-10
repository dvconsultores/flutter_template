import 'package:flutter/material.dart';

class ShadowInputBorder extends OutlineInputBorder {
  const ShadowInputBorder({
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(40)),
    gapPadding = 4.0,
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 1,
    this.elevation = 10,
  }) : super(
          borderSide: BorderSide.none,
          borderRadius: borderRadius,
          gapPadding: gapPadding,
        );

  final double elevation;
  final Color color;
  final Color borderColor;
  final double borderWidth;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);

    // shadow path
    Path shadowPath = Path();
    shadowPath.addRRect(center);
    canvas.drawShadow(shadowPath, Colors.black, elevation, false);

    // body painter
    final bodyPaint = Paint();
    bodyPaint
      ..strokeWidth = 0
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(center, bodyPaint);

    // border painter
    final borderPaint = Paint()
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(center, borderPaint);
  }
}
