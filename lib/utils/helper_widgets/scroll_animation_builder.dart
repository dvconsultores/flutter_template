import 'dart:async';

import 'package:flutter/material.dart';

class ScrollAnimationBuilder<T> extends StatefulWidget {
  const ScrollAnimationBuilder({
    super.key,
    required this.controller,
    required this.builder,
    required this.onListen,
    this.threshold = 10,
  });
  final ScrollController controller;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      builder;
  final T Function(double offset) onListen;
  final double threshold;

  @override
  State<ScrollAnimationBuilder> createState() =>
      _ScrollAnimationWidgetState<T>();
}

class _ScrollAnimationWidgetState<T> extends State<ScrollAnimationBuilder<T>> {
  final animStreamController = StreamController<T>();
  double lastOffsetProcessed = 0.0;

  void listenerScroll() {
    final offset = widget.controller.offset;
    if ((offset - lastOffsetProcessed).abs() < widget.threshold) return;
    lastOffsetProcessed = offset;

    animStreamController.add(widget.onListen(offset));
  }

  @override
  void initState() {
    widget.controller.addListener(listenerScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: animStreamController.stream,
      builder: widget.builder,
    );
  }
}
