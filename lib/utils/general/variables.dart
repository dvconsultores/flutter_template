import 'package:flutter/material.dart';

/// Used to storage a collection of global constant variables.
mixin Variables {
  // * fetching
  static const requestTiming = 10;

  // * Sizing
  static const mSize = Size(360, 690);
  static const paddingScaffold = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  );

  static const double gapXLow = 2,
      gapLow = 4,
      gapMedium = 8,
      gapLarge = 12,
      gapXLarge = 16,
      gapMax = 20;
  static const double radius50 = 50,
      radius30 = 30,
      radius15 = 15,
      radius10 = 10;

  // * others
  static const boxShadow1 = BoxShadow(
        color: Color.fromRGBO(172, 194, 212, 1),
        spreadRadius: 3,
        blurRadius: 9,
        offset: Offset(0, 3),
      ),
      boxShadow2 = BoxShadow(
        color: Color.fromRGBO(172, 194, 212, 1),
        spreadRadius: 0,
        blurRadius: 6,
        offset: Offset(0, 3),
      );
}
