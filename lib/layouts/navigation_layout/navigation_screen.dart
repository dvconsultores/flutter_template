import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_layout.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/widgets/defaults/bottom_navigation_bar.dart';
import 'package:flutter_detextre4/widgets/defaults/drawer.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({
    super.key,
    required this.child,
    this.swipeNavigate = false,
  });
  final Widget child;
  final bool swipeNavigate;

  @override
  Widget build(BuildContext context) {
    final inherited =
        context.getInheritedWidgetOfExactType<NavigationInherited>()!;

    return GestureDetector(
      onHorizontalDragUpdate: swipeNavigate
          ? (details) {
              // Note: Sensitivity is integer used when you don't want to mess up vertical drag
              int sensitivity = 8;

              // Right Swipe
              if (details.delta.dx > sensitivity) {
                final index = router.indexShellRoute == 0
                    ? 0
                    : router.indexShellRoute - 1;
                final previousRoute =
                    router.shellRoutes.elementAtOrNull(index) as GoRoute?;

                if (previousRoute != null) router.go((previousRoute).path);

                // Left Swipe
              } else if (details.delta.dx < -sensitivity) {
                final nextRoute = router.shellRoutes
                    .elementAtOrNull(router.indexShellRoute + 1) as GoRoute?;

                if (nextRoute != null) router.go((nextRoute).path);
              }
            }
          : null,
      child: Material(
        color: Colors.transparent,
        child: Scaffold(
          body: child,
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: Text(
              inherited.items.entries
                  .elementAt(router.indexShellRoute)
                  .key
                  .toCapitalize(),
            ),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: router.indexShellRoute,
            onTap: (index) =>
                router.goNamed(inherited.items.entries.elementAt(index).key),
            items: inherited.items.values.toList(),
          ),
        ),
      ),
    );
  }
}
