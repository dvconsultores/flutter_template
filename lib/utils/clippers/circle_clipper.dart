import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper({
    this.offset,
    required this.radius,
  });
  final Offset? offset;
  final double radius;

  @override
  Path getClip(Size size) => Path()
    ..addOval(Rect.fromCircle(
      center: offset ?? Offset(size.width / 2, size.height / 2),
      radius: radius,
    ));

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
