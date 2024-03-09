import 'package:flutter/material.dart';

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
