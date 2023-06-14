import 'package:flutter/material.dart';
import 'package:flutterDetextre4/main.dart';

mixin ScreenSizeMixin {
  final Size screenSize =
      MediaQuery.of(globalNavigatorKey.currentContext!).size;

  final double screenWidth =
      MediaQuery.of(globalNavigatorKey.currentContext!).size.width;

  final double screenHeight =
      MediaQuery.of(globalNavigatorKey.currentContext!).size.height;

  double screenSpaceBetween(double value, {vertical = true}) => vertical
      ? MediaQuery.of(globalNavigatorKey.currentContext!).size.height * value
      : MediaQuery.of(globalNavigatorKey.currentContext!).size.width * value;
}
