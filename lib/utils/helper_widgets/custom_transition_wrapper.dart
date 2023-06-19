import 'package:flutter/material.dart';

class CustomTransitionWrapper extends StatelessWidget {
  const CustomTransitionWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget rotate({required Widget child}) =>
      _RotateTransition(child: child);
}

class _RotateTransition extends StatelessWidget {
  const _RotateTransition({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
}
