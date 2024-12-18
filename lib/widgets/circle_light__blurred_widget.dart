import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/painters/circle_painter.dart';

class CircleLightBlurredWidget extends StatelessWidget {
  const CircleLightBlurredWidget({
    super.key,
    required this.size,
    this.color,
    this.blur = 100,
  });
  final double size;
  final Color? color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: CustomPaint(
        size: Size(size, size),
        painter: CirclePainter(color: color),
      ),
    );
  }
}
