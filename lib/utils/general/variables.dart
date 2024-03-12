import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';

/// Used to storage a collection of global constant Vars.
mixin Vars {
  // * fetching
  static const requestTiming = 10;

  // * values
  static const maxDecimals = 3;

  // * Sizing
  static const mSize = Size(360, 690);

  static const bottomNavbarHeight = 75.0;

  static double getBodyHeight(
    BuildContext context, {
    double headerHeight = 0,
    double other = 0,
  }) {
    final media = MediaQuery.of(context);
    return media.size.height - (headerHeight + media.viewPadding.top + other);
  }

  static const paddingScaffold = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  );

  static const double gapXLow = 2,
      gapLow = 4,
      gapNormal = 8,
      gapMedium = 10,
      gapLarge = 12,
      gapXLarge = 16,
      gapMax = 20;

  static const double radius50 = 50,
      radius40 = 40,
      radius30 = 30,
      radius20 = 20,
      radius15 = 15,
      radius12 = 12,
      radius10 = 10;

  // gradient
  static LinearGradient getGradient(BuildContext context) => LinearGradient(
          transform: const GradientRotation(-30),
          tileMode: TileMode.mirror,
          colors: [
            ThemeApp.colors(context).tertiary.withOpacity(.2),
            ThemeApp.colors(context).primary.withOpacity(.3),
            ThemeApp.colors(context).tertiary.withOpacity(.2),
          ]);

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
      ),
      boxShadow3 = BoxShadow(
        offset: Offset(-1, 6),
        blurRadius: 3,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.2),
      ),
      boxShadow4 = BoxShadow(
        offset: Offset(0, 3),
        blurRadius: 9,
        spreadRadius: -3,
        color: Color(0xffE15517),
      );

  static const double minInputHeight = 42, maxInputHeight = 50;

  // RegExps
  static final nicknameRegExp = RegExp(r'^[a-zA-ZñÑ0-9_-]{5,12}$'),
      emailRegExp = RegExp(r'^[a-zA-Z\-\_0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+'),
      passwordRegExp = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%&*-]).{6,}$');
}
