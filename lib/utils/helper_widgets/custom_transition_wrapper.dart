import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/clippers/circle_clipper.dart';

Animation<double> _animation(BuildContext context) =>
    ModalRoute.of(context)!.animation!;

class CustomTransitionWrapper extends StatelessWidget {
  const CustomTransitionWrapper({
    super.key,
    required this.child,
    this.animation,
    this.secondaryAnimation,
  });
  final Widget child;
  final Animation<double>? animation;
  final Animation<double>? secondaryAnimation;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation ?? _animation(context),
      curve: Curves.easeInOut,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: FadeTransition(
        opacity: curvedAnimation,
        child: child,
      ),
    );
  }

  static Widget rotate({required Widget child, Animation<double>? animation}) =>
      _RotateTransition(animation: animation, child: child);

  static Widget circleFade({
    required Widget child,
    Duration? duration,
    Offset? offset,
    required double radiusBegin,
    required double radiusEnd,
    double opacityBegin = .6,
    double opacityEnd = 1,
    Animation<double>? animation,
  }) =>
      _CircleFade(
        duration: duration,
        offset: offset,
        radiusBegin: radiusBegin,
        radiusEnd: radiusEnd,
        opacityBegin: opacityBegin,
        opacityEnd: opacityEnd,
        animation: animation,
        child: child,
      );

  static Widget fall({
    required Widget child,
    required Widget currentWidget,
    required Animation<double> animation,
  }) =>
      _FallTransition(
        animation: animation,
        currentWidget: currentWidget,
        child: child,
      );
}

class _RotateTransition extends StatelessWidget {
  const _RotateTransition({required this.child, this.animation});
  final Widget child;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation ?? _animation(context),
          curve: Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
}

class _CircleFade extends StatelessWidget {
  const _CircleFade({
    required this.child,
    required this.duration,
    required this.offset,
    required this.radiusBegin,
    required this.radiusEnd,
    required this.animation,
    required this.opacityBegin,
    required this.opacityEnd,
  });
  final Widget child;
  final Duration? duration;
  final Offset? offset;
  final double radiusBegin;
  final double radiusEnd;
  final double opacityBegin;
  final double opacityEnd;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    final animated = animation ?? _animation(context);

    return AnimatedBuilder(
      animation: animated,
      builder: (context, child) {
        final Animation<double> curvedAnimation = Tween<double>(
          begin: radiusBegin,
          end: radiusEnd,
        ).animate(CurvedAnimation(
          parent: animated,
          curve: Curves.fastLinearToSlowEaseIn,
        ));

        final Animation<double> opacityAnimation = Tween<double>(
          begin: opacityBegin,
          end: opacityEnd,
        ).animate(CurvedAnimation(
          parent: animated,
          curve: Curves.fastLinearToSlowEaseIn,
        ));

        return ClipPath(
          clipper: CircleClipper(offset: offset, radius: curvedAnimation.value),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _FallTransition extends StatelessWidget {
  const _FallTransition({
    required this.child,
    required this.animation,
    required this.currentWidget,
  });

  final Widget child;
  final Animation<double> animation;
  final Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    final begin = const Offset(0.0, 0.0),
        end = const Offset(0.0, 1.0),
        curve = Curves.easeInOutCubic,
        tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
      child: Stack(children: [
        SlideTransition(
          position: animation.drive(tween),
          child: currentWidget,
        ),
        SlideTransition(
          position: Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
              .animate(animation),
          child: child,
        ),
      ]),
    );
  }
}
