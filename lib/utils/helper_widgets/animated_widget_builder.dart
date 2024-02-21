import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedWidgetBuilder extends StatefulWidget {
  const AnimatedWidgetBuilder({
    super.key,
    this.animation,
    this.animationBehavior = AnimationBehavior.normal,
    this.debugLabel,
    required this.duration,
    this.lowerBound = 0.0,
    this.reverseDuration,
    this.upperBound = 1.0,
    this.value,
    required this.builder,
    this.type = const TypeAnimatedOnce(),
    this.child,
  });
  final AnimationController? animation;
  final AnimationBehavior animationBehavior;
  final String? debugLabel;
  final Duration duration;
  final double lowerBound;
  final Duration? reverseDuration;
  final double upperBound;
  final double? value;
  final Widget Function(
      BuildContext context, Widget? child, AnimationController parent) builder;
  final TypeAnimated type;
  final Widget? child;

  @override
  State<AnimatedWidgetBuilder> createState() => _AnimatedWidgetBuilderState();
}

class _AnimatedWidgetBuilderState extends State<AnimatedWidgetBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      animationBehavior: widget.animationBehavior,
      debugLabel: widget.debugLabel,
      duration: widget.duration,
      lowerBound: widget.lowerBound,
      reverseDuration: widget.reverseDuration,
      upperBound: widget.upperBound,
      value: widget.value,
    );

    switch (widget.type) {
      case const TypeAnimatedOnce():
        animation.forward(from: (widget.type as TypeAnimatedOnce).from);
        break;
      case TypeAnimatedLoop():
        {
          final loop = widget.type as TypeAnimatedLoop;
          animation.loop(
            count: loop.count,
            max: loop.max,
            min: loop.max,
            period: loop.period,
            reverse: loop.reverse,
          );
        }
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  AnimationController get getAnimation => widget.animation ?? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: getAnimation,
      builder: (context, child) => widget.builder(context, child, getAnimation),
      child: widget.child,
    );
  }
}

abstract class TypeAnimated {
  const TypeAnimated();
}

class TypeAnimatedOnce extends TypeAnimated {
  const TypeAnimatedOnce({this.from});
  final double? from;
}

class TypeAnimatedLoop extends TypeAnimated {
  const TypeAnimatedLoop({
    this.count,
    this.reverse = false,
    this.min,
    this.max,
    this.period,
  });

  final int? count;
  final bool reverse;
  final double? min;
  final double? max;
  final Duration? period;
}
