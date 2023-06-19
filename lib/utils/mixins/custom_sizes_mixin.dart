import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';

mixin CustomSizesMixin {
  final Size size = MediaQuery.of(globalNavigatorKey.currentContext!).size;
}
