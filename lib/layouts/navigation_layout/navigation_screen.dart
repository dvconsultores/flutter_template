import 'package:flutter/material.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({
    super.key,
    required this.child,
    this.swipeNavigate = false,
    required this.items,
  });
  final Widget child;
  final bool swipeNavigate;
  final Map<String, BottomNavigationBarItem> items;

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
