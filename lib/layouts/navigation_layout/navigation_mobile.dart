import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_layout.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/widgets/defaults/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class NavigationMobile extends StatelessWidget {
  const NavigationMobile(
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
    final inherited =
        context.getInheritedWidgetOfExactType<NavigationInherited>()!;

    return Scaffold(
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: router.indexShellRoute,
        onTap: (index) =>
            context.goNamed(inherited.items.entries.elementAt(index).key),
        items: router.shellRoutes
            .map((element) => inherited.items[(element as GoRoute).name]!)
            .toList(),
      ),

      //? Render pages
      body: GestureDetector(
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
        child: child,
      ),
    );
  }
}
