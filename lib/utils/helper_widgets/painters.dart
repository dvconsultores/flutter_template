import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

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

/// Star.
class StarPainter {
  Offset? position;
  Color? color;
  double value;
  late Offset speed;
  final Color initialColor;
  late double angle;

  StarPainter({
    required this.initialColor,
  }) : value = 0.0;

  static const _minOpacity = 0.1;
  static const _maxOpacity = 1.0;

  void _init(Rect rect) {
    position = rect.center;
    value = 0.0;
    final random = math.Random();
    angle = random.nextDouble() * math.pi * 3;
    speed = Offset(math.cos(angle), math.sin(angle));
    const minSpeedScale = 20;
    const maxSpeedScale = 35;
    final speedScale = minSpeedScale +
        random.nextInt(maxSpeedScale - minSpeedScale).toDouble();
    speed = speed.scale(
      speedScale,
      speedScale,
    );
    final t = speedScale / maxSpeedScale;
    final opacity = _minOpacity + (_maxOpacity - _minOpacity) * t;
    color = initialColor.withOpacity(opacity);
  }

  draw(Canvas canvas, Rect rect) {
    if (position == null) {
      _init(rect);
    }

    value++;
    final startPosition = Offset(position!.dx, position!.dy);
    final endPosition = position! + (speed * (value * 0.3));
    position = speed + position!;
    final paint = Paint()..color = color!;

    final startShiftAngle = angle + (math.pi / 2);
    final startShift =
        Offset(math.cos(startShiftAngle), math.sin(startShiftAngle));
    final shiftedStartPosition =
        startPosition + (startShift * (0.75 + value * 0.01));

    final endShiftAngle = angle + (math.pi / 2);
    final endShift = Offset(math.cos(endShiftAngle), math.sin(endShiftAngle));
    final shiftedEndPosition = endPosition + (endShift * (1.5 + value * 0.01));

    final path = Path()
      ..moveTo(startPosition.dx, startPosition.dy)
      ..lineTo(startPosition.dx, startPosition.dy)
      ..lineTo(shiftedStartPosition.dx, shiftedStartPosition.dy)
      ..lineTo(shiftedEndPosition.dx, shiftedEndPosition.dy)
      ..lineTo(endPosition.dx, endPosition.dy);

    if (!rect.contains(startPosition)) {
      _init(rect);
    }

    canvas.drawPath(path, paint);
  }
}

/// Sky.
class SkyPainter extends CustomPainter {
  final List<StarPainter> stars;
  final Color color;

  SkyPainter({
    required this.stars,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    canvas.drawRect(rect, Paint()..color = color);

    for (final star in stars) {
      star.draw(canvas, rect);
    }
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      var rect = Offset.zero & size;

      return [
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Lightspeed animation.',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRepaint(SkyPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(SkyPainter oldDelegate) => false;
}

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
