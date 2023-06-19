import 'package:flutter/material.dart';

Animation<double> _animation(BuildContext context) =>
    ModalRoute.of(context)!.animation!;

class CustomTransitionWrapper extends StatelessWidget {
  const CustomTransitionWrapper({
    super.key,
    required this.child,
    this.animation,
  });
  final Widget child;
  final Animation<double>? animation;

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

  static Widget rotate({
    required Widget child,
    Animation<double>? animation,
  }) =>
      _RotateTransition(
        animation: animation,
        child: child,
      );
}

class _RotateTransition extends StatelessWidget {
  const _RotateTransition({
    required this.child,
    this.animation,
  });
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
