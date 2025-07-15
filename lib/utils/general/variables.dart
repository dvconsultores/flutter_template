import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/services/local_data/env_service.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

/// Used to storage a collection of global constant Vars.
mixin Vars {
  static final isProduction = env.environment == "production";

  // * fetching
  /// int -> 20
  static const requestTiming = 20;

  // * values
  /// int -> 3
  static const maxDecimals = 3;

  /// Duration -> 1500
  static const skeletonDuration = Duration(milliseconds: 1500);

  // * Sizing
  /// Size -> Size(360, 690)
  static const mobileSize = Size(360, 690);

  /// Size -> Size(1512, 720)
  static const desktopSize = Size(1512, 720);

  static Size getDesignSize(BuildContext context) =>
      context.width.isMobile ? Vars.mobileSize : Vars.desktopSize;

  static double scalerFactor(
    BuildContext context, {
    double? minRange,
    double? maxRange,
    double? minValue,
    double? maxValue,
  }) =>
      context.width.screenWidth.clampMapRanged(
        minRange: minRange ?? context.width.tablet,
        maxRange: maxRange ?? context.width.desktop,
        minValue: minValue ?? .8,
        maxValue: maxValue ?? 1,
      );

  /// width -> 1000
  static const double desktopScaffoldMaxWidth = 1000;

  /// height -> 75.0
  static const bottomNavbarHeight = 75.0;

  /// height -> 45
  static const double buttonHeight = 45;

  /// Padding ->
  /// EdgeInsets.symmetric(
  ///   vertical: 16,
  ///   horizontal: 24,
  /// );
  static const paddingScaffold = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  );

  /// gap -> 2
  static const double gapXLow = 2;

  /// gap -> 4
  static const double gapLow = 4;

  /// gap -> 8
  static const double gapNormal = 8;

  /// gap -> 10
  static const double gapMedium = 10;

  /// gap -> 12
  static const double gapLarge = 12;

  /// gap -> 16
  static const double gapXLarge = 16;

  /// gap -> 20
  static const double gapMax = 20;

  static const double radius50 = 50,
      radius45 = 45,
      radius40 = 40,
      radius35 = 35,
      radius30 = 30,
      radius25 = 25,
      radius20 = 20,
      radius15 = 15,
      radius12 = 12,
      radius10 = 10,
      radius8 = 8;

  // gradient
  static LinearGradient getGradient(BuildContext context) => LinearGradient(
          transform: const GradientRotation(-30),
          tileMode: TileMode.mirror,
          colors: [
            ThemeApp.of(context).colors.tertiary.withAlpha(51),
            ThemeApp.of(context).colors.primary.withAlpha(77),
            ThemeApp.of(context).colors.tertiary.withAlpha(51),
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

  /// height -> 42
  static const double minInputHeight = 42;

  /// height -> 50
  static const double maxInputHeight = 50;

  // RegExps
  static final nicknameRegExp = RegExp(r'^[a-zA-ZñÑ0-9_-]{5,12}$'),
      emailRegExp = RegExp(r'^[a-zA-Z\-\_0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+'),
      passwordRegExp = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%&*-.]).{6,}$');
  static RegExp phoneRegExp({
    int minLength = 11,
    int maxLength = 13,
    int lengthAreaCode = 3,
  }) =>
      RegExp(r'^[\+]?[(]?[0-9]{' +
          lengthAreaCode.toString() +
          r'}[)]?[-\s\.]?[0-9]{' +
          (minLength - lengthAreaCode).toString() +
          r',' +
          (maxLength - lengthAreaCode).toString() +
          r'}$');
}
