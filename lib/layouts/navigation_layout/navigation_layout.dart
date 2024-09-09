import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_desktop.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_mobile.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

class NavigationLayout extends StatelessWidget {
  const NavigationLayout(
    this.state,
    this.child, {
    super.key,
    this.swipeNavigate = false,
  });
  final GoRouterState state;
  final Widget child;
  final bool swipeNavigate;

  @override
  Widget build(BuildContext context) {
    if (router.indexShellRoute == -1) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final items = {
      "profile": const BottomNavigationBarItem(
        label: "",
        tooltip: "Profile",
        icon: Icon(Icons.person),
      ),
      "home": const BottomNavigationBarItem(
        label: "",
        tooltip: "Home",
        icon: Icon(Icons.home),
      ),
      "search": const BottomNavigationBarItem(
        label: "",
        tooltip: "Search",
        icon: Icon(Icons.search),
      ),
    };

    return NavigationInherited(
      items: items,
      child: ResponsiveLayout(
        desktop: (context, constraints) => NavigationDesktop(
          constraints,
          swipeNavigate: swipeNavigate,
          child: child,
        ),
        tablet: (context, constraints) => NavigationMobile(
          constraints,
          swipeNavigate: swipeNavigate,
          child: child,
        ),
      ),
    );
  }
}

class NavigationInherited extends InheritedWidget {
  const NavigationInherited({
    super.key,
    required super.child,
    required this.items,
  });
  final Map<String, BottomNavigationBarItem> items;

  @override
  bool updateShouldNotify(NavigationInherited oldWidget) =>
      items != oldWidget.items;
}
