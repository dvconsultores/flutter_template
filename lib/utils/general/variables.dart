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
}
