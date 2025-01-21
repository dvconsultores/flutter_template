import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior();

  static final _dragDevices = {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
  };

  static final _multitouchDragStrategy =
      MultitouchDragStrategy.averageBoundaryPointers;

  static ScrollBehavior of(BuildContext context) =>
      ScrollConfiguration.of(context).copyWith(
        dragDevices: _dragDevices,
        multitouchDragStrategy: _multitouchDragStrategy,
      );

  static ScrollBehavior ofDefault() => ScrollBehavior().copyWith(
        dragDevices: _dragDevices,
        multitouchDragStrategy: _multitouchDragStrategy,
      );

  static ScrollBehavior ofMaterial() => MaterialScrollBehavior().copyWith(
        dragDevices: _dragDevices,
        multitouchDragStrategy: _multitouchDragStrategy,
      );

  static ScrollBehavior ofCupertino() => CupertinoScrollBehavior().copyWith(
        dragDevices: _dragDevices,
        multitouchDragStrategy: _multitouchDragStrategy,
      );
}
