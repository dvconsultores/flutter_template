import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior();

  // Configuration to web scroll on touch
  static final _dragDevices = {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
  };

  static final _multitouchDragStrategy =
      MultitouchDragStrategy.averageBoundaryPointers;

  static ScrollBehavior of(BuildContext context) =>
      ScrollConfiguration.of(context).copyWith(
        dragDevices: kIsWeb ? _dragDevices : null,
        multitouchDragStrategy: _multitouchDragStrategy,
      );

  static ScrollBehavior ofDefault() => ScrollBehavior().copyWith(
        dragDevices: kIsWeb ? _dragDevices : null,
        multitouchDragStrategy: _multitouchDragStrategy,
      );

  static ScrollBehavior ofMaterial() => MaterialScrollBehavior().copyWith(
        dragDevices: kIsWeb ? _dragDevices : null,
        multitouchDragStrategy: _multitouchDragStrategy,
      );

  static ScrollBehavior ofCupertino() => CupertinoScrollBehavior().copyWith(
        dragDevices: kIsWeb ? _dragDevices : null,
        multitouchDragStrategy: _multitouchDragStrategy,
      );
}
