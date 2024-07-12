import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ScrollAnimatedOptions {
  const ScrollAnimatedOptions(
    this.offset,
    this.scrollDirection,
  );
  final double offset;
  final ScrollAnimatedDirection scrollDirection;
}

enum ScrollAnimatedDirection {
  leading,
  trailling;
}

class ScrollAnimatedBuilder extends StatefulWidget {
  const ScrollAnimatedBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.child,
  });
  final ScrollController controller;
  final Widget Function(
          BuildContext context, Widget? child, ScrollAnimatedOptions options)
      builder;
  final Widget? child;

  @override
  State<ScrollAnimatedBuilder> createState() => _ScrollAnimatedWidgetState();
}

class _ScrollAnimatedWidgetState extends State<ScrollAnimatedBuilder> {
  double lastOffsetProcessed = 0.0;

  late StreamSubscription keyboardSubscription;

  @override
  void initState() {
    keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((visible) {
      EasyDebounce.debounce("setState", Durations.short1, () {
        if (!mounted) return;
        widget.controller.jumpTo(lastOffsetProcessed);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: widget.controller,
      builder: (context, snapshot) {
        final offset = widget.controller.offset,
            scrollDirection = offset < lastOffsetProcessed
                ? ScrollAnimatedDirection.leading
                : ScrollAnimatedDirection.trailling;

        lastOffsetProcessed = offset;

        return widget.builder(
          context,
          widget.child,
          ScrollAnimatedOptions(offset, scrollDirection),
        );
      });
}
