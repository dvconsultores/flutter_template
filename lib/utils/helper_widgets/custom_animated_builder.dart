import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MultipleAnimatedBuilder extends StatefulWidget {
  const MultipleAnimatedBuilder({
    super.key,
    required this.animationSettings,
    required this.builder,
    this.child,
  });
  final List<CustomAnimationSettings> animationSettings;
  final Widget Function(
          BuildContext context, Widget? child, List<AnimationController> parent)
      builder;
  final Widget? child;

  @override
  State<MultipleAnimatedBuilder> createState() => _MultipleWidgetBuilderState();
}

class _MultipleWidgetBuilderState extends State<MultipleAnimatedBuilder>
    with TickerProviderStateMixin {
  final List<AnimationController> animations = [];

  @override
  void initState() {
    for (final animationSetting in widget.animationSettings) {
      animations.add(AnimationController(
        vsync: this,
        animationBehavior: animationSetting.animationBehavior,
        debugLabel: animationSetting.debugLabel,
        duration: animationSetting.duration,
        lowerBound: animationSetting.lowerBound,
        reverseDuration: animationSetting.reverseDuration,
        upperBound: animationSetting.upperBound,
        value: animationSetting.value,
      ));

      final animation =
          animations[widget.animationSettings.indexOf(animationSetting)];

      switch (animationSetting.type) {
        case const TypeAnimatedOnce():
          animation.forward(
              from: (animationSetting.type as TypeAnimatedOnce).from);
          break;
        case TypeAnimatedLoop():
          {
            final loop = animationSetting.type as TypeAnimatedLoop;
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
    }

    super.initState();
  }

  @override
  void dispose() {
    for (final animation in animations) {
      animation.dispose();
    }
    super.dispose();
  }

  List<AnimationController> get getAnimations => widget.animationSettings
      .mapIndexed((i, e) => e.animation ?? animations[i])
      .toList();

  @override
  Widget build(BuildContext context) {
    Widget renderWidget() {
      Widget? lastWidget;

      for (var animation in getAnimations) {
        lastWidget = AnimatedBuilder(
          animation: animation,
          builder: (context, child) =>
              widget.builder(context, child, getAnimations),
          child: lastWidget ?? widget.child,
        );
      }

      return lastWidget!;
    }

    return renderWidget();
  }
}

class SingleAnimatedBuilder extends StatefulWidget {
  const SingleAnimatedBuilder({
    super.key,
    required this.animationSettings,
    required this.builder,
    this.child,
  });
  final CustomAnimationSettings animationSettings;
  final Widget Function(
      BuildContext context, Widget? child, AnimationController parent) builder;
  final Widget? child;

  @override
  State<SingleAnimatedBuilder> createState() => _AnimatedWidgetBuilderState();
}

class _AnimatedWidgetBuilderState extends State<SingleAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      animationBehavior: widget.animationSettings.animationBehavior,
      debugLabel: widget.animationSettings.debugLabel,
      duration: widget.animationSettings.duration,
      lowerBound: widget.animationSettings.lowerBound,
      reverseDuration: widget.animationSettings.reverseDuration,
      upperBound: widget.animationSettings.upperBound,
      value: widget.animationSettings.value,
    );

    switch (widget.animationSettings.type) {
      case const TypeAnimatedOnce():
        animation.forward(
            from: (widget.animationSettings.type as TypeAnimatedOnce).from);
        break;
      case TypeAnimatedLoop():
        {
          final loop = widget.animationSettings.type as TypeAnimatedLoop;
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

  AnimationController get getAnimation =>
      widget.animationSettings.animation ?? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: getAnimation,
      builder: (context, child) => widget.builder(context, child, getAnimation),
      child: widget.child,
    );
  }
}

class CustomAnimationSettings {
  CustomAnimationSettings({
    this.animation,
    this.animationBehavior = AnimationBehavior.normal,
    this.debugLabel,
    required this.duration,
    this.lowerBound = 0.0,
    this.reverseDuration,
    this.upperBound = 1.0,
    this.value,
    this.type = const TypeAnimatedOnce(),
  });
  final AnimationController? animation;
  final AnimationBehavior animationBehavior;
  final String? debugLabel;
  final Duration duration;
  final double lowerBound;
  final Duration? reverseDuration;
  final double upperBound;
  final double? value;
  final TypeAnimated type;
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
