import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper({
    this.offset,
    required this.radius,
  });
  final Offset? offset;
  final double radius;

  Offset center(Size size) => Offset(size.width / 2, size.height / 2);

  @override
  Path getClip(Size size) => Path()
    ..addOval(
      Rect.fromCircle(center: offset ?? center(size), radius: radius),
    );

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
