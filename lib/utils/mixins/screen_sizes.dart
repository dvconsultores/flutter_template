import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';

mixin ScreenSizes {
  final Size screenSize =
      MediaQuery.of(globalNavigatorKey.currentContext!).size;

  final double screenWidth =
      MediaQuery.of(globalNavigatorKey.currentContext!).size.width;

  final double screenHeight =
      MediaQuery.of(globalNavigatorKey.currentContext!).size.height;

  double screenSpaceBetween(double value) =>
      MediaQuery.of(globalNavigatorKey.currentContext!).size.height * value;
}