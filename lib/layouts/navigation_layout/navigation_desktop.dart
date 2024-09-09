import 'package:flutter/material.dart';

class NavigationDesktop extends StatelessWidget {
  const NavigationDesktop(
    this.constraints, {
    super.key,
    required this.child,
    this.swipeNavigate = false,
  });
  final BoxConstraints constraints;
  final Widget child;
  final bool swipeNavigate;

  @override
  Widget build(BuildContext context) {
    // final inherited =
    //     context.getInheritedWidgetOfExactType<NavigationInherited>()!;

    return Material(
      color: Colors.transparent,
      child: child,
    );
  }
}
