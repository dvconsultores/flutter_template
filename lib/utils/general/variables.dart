import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/services/local_data/env_service.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

/// Used to storage a collection of global constant Vars.
mixin Vars {
  static final isProduction = env.environment == "production";

  // * fetching
  static const requestTiming = 20;

  // * values
  static const maxDecimals = 3;
  static const skeletonDuration = Duration(milliseconds: 1500);

  // * Sizing
  static const mobileSize = Size(360, 690), desktopSize = Size(1512, 720);
  static Size getDesignSize(BuildContext context) =>
      context.width.isMobile ? Vars.mobileSize : Vars.desktopSize;

  static const bottomNavbarHeight = 75.0;

  static const double buttonHeight = 45;

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
            ThemeApp.of(context).colors.tertiary.withOpacity(.2),
            ThemeApp.of(context).colors.primary.withOpacity(.3),
            ThemeApp.of(context).colors.tertiary.withOpacity(.2),
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
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%&*-.]).{6,}$'),
      phoneRegExp = RegExp(
          r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)');
}
