import 'package:flutter/material.dart';

class ScrollAnimationOptions {
  const ScrollAnimationOptions(
    this.offset,
    this.scrollDirection,
  );
  final double offset;
  final ScrollAnimationDirection scrollDirection;
}

enum ScrollAnimationDirection {
  leading,
  trailling;
}

class ScrollAnimationBuilder extends StatefulWidget {
  const ScrollAnimationBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });
  final ScrollController controller;
  final Widget Function(BuildContext context, ScrollAnimationOptions options)
      builder;

  @override
  State<ScrollAnimationBuilder> createState() => _ScrollAnimationWidgetState();
}

class _ScrollAnimationWidgetState extends State<ScrollAnimationBuilder> {
  double lastOffsetProcessed = 0.0;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: widget.controller,
      builder: (context, snapshot) {
        final offset = widget.controller.offset,
            scrollDirection = offset < lastOffsetProcessed
                ? ScrollAnimationDirection.leading
                : ScrollAnimationDirection.trailling;

        lastOffsetProcessed = offset;

        return widget.builder(
            context, ScrollAnimationOptions(offset, scrollDirection));
      });
}
