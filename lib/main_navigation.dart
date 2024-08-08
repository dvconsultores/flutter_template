import 'package:double_back_to_exit/double_back_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/defaults/bottom_navigation_bar.dart';

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
    if (router.indexShellRoute == -1) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: router.indexShellRoute,
        onTap: (index) =>
            context.goNamed((router.shellRoutes[index] as GoRoute).name!),
        items: router.shellRoutes.map((element) {
          Icon getIcon(String? value) {
            switch (value) {
              case "profile":
                return const Icon(Icons.person);
              case "home":
                return const Icon(Icons.home);
              case "search":
              default:
                return const Icon(Icons.search);
            }
          }

          return BottomNavigationBarItem(
            label: "",
            tooltip: (element as GoRoute).name?.toCapitalize(),
            icon: getIcon(element.name),
          );
        }).toList(),
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
        child: state.location == "/"
            ? DoubleBackToExit(
                snackBarMessage: "Press again to leave", child: child)
            : WillPopCustom(
                onWillPop: () {
                  context.goNamed("home");
                  return false;
                },
                child: child,
              ),
      ),
    );
  }
}
