import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';

class CirclePainter extends CustomPainter {
  const CirclePainter({this.color});
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      math.min(size.width, size.height) / 2,
      Paint()..color = color ?? ThemeApp.of(null).colors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) => true;
}
