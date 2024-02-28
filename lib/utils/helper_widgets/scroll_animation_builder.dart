import 'package:flutter/material.dart';

class ScrollAnimationBuilder extends StatefulWidget {
  const ScrollAnimationBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.threshold = 5,
  });
  final ScrollController controller;
  final Widget Function(
    BuildContext context,
    ScrollAnimationOptions options,
  ) builder;
  final double threshold;

  @override
  State<ScrollAnimationBuilder> createState() => _ScrollAnimationWidgetState();
}

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

class _ScrollAnimationWidgetState extends State<ScrollAnimationBuilder> {
  double lastOffsetProcessed = 0.0;

  double offset = 0;
  var scrollDirection = ScrollAnimationDirection.leading;

  void listenerScroll() {
    offset = widget.controller.offset;
    if ((offset - lastOffsetProcessed).abs() < widget.threshold) return;

    scrollDirection = offset < lastOffsetProcessed
        ? ScrollAnimationDirection.leading
        : ScrollAnimationDirection.trailling;

    lastOffsetProcessed = offset;
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(listenerScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listenerScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, ScrollAnimationOptions(offset, scrollDirection));
}

class ScrollAnimationBuilderV2<T> extends StatefulWidget {
  const ScrollAnimationBuilderV2({
    super.key,
    required this.controller,
    this.initialValue,
    required this.builder,
    required this.onListen,
    this.threshold = 5,
  });
  final ScrollController controller;
  final List<T>? initialValue;
  final Widget Function(BuildContext context, List<T>? snapshot) builder;
  final List<T> Function(ScrollAnimationOptions) onListen;
  final double threshold;

  @override
  State<ScrollAnimationBuilderV2> createState() =>
      _ScrollAnimationWidgetStateV2<T>();
}

class _ScrollAnimationWidgetStateV2<T>
    extends State<ScrollAnimationBuilderV2<T>> {
  double lastOffsetProcessed = 0.0;

  List<T>? values;

  void listenerScroll() {
    final offset = widget.controller.offset;
    if ((offset - lastOffsetProcessed).abs() < widget.threshold) return;

    final scrollDirection = offset < lastOffsetProcessed
        ? ScrollAnimationDirection.leading
        : ScrollAnimationDirection.trailling;

    lastOffsetProcessed = offset;

    values = widget.onListen(ScrollAnimationOptions(offset, scrollDirection));
    setState(() {});
  }

  @override
  void initState() {
    values = widget.initialValue;
    widget.controller.addListener(listenerScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listenerScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, values);
}
