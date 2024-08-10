import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/widgets/defaults/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation(
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
    final mainProvider = context.read<MainProvider>();

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

    return Scaffold(
      bottomNavigationBar: mainProvider.bottomNavigationBar
          ? AppBottomNavigationBar(
              currentIndex: router.indexShellRoute,
              onTap: (index) =>
                  context.goNamed(items.entries.elementAt(index).key),
              items: router.shellRoutes
                  .map((element) => items[(element as GoRoute).name]!)
                  .toList(),
            )
          : null,

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
