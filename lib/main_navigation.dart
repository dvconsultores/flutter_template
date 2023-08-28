import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter_detextre4/widgets/drawer.dart';
import 'package:flutter_detextre4/widgets/scaffold.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/helper_widgets/double_back_to_close_widget.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:go_router/go_router.dart';

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
      return const ScaffoldBody(body: SizedBox.shrink());
    }

    final currentSubRoute = router.subShellRoutes
        ?.any((element) => (element as GoRoute).path.contains(state.location));

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

    return AppScaffold(
      padding: const EdgeInsets.all(0),
      drawer: currentSubRoute != null ? const AppDrawer() : null,
      appBar: AppBar(
        leading: currentSubRoute == null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              )
            : null,
        title: Text((router.shellRoute as GoRoute?)?.name ?? ""),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: router.indexShellRoute,
        onTap: (index) =>
            context.goNamed((router.shellRoutes[index] as GoRoute).name!),
        items: router.shellRoutes
            .map((element) => BottomNavigationBarItem(
                  label: "",
                  tooltip: (element as GoRoute).name?.toCapitalize(),
                  icon: getIcon(element.name),
                ))
            .toList(),
      ),

      //? Render pages
      child: _Body(
        swipeNavigate: swipeNavigate,
        state: state,
        child: child,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.swipeNavigate,
    required this.state,
    required this.child,
  });

  final bool swipeNavigate;
  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
      child: state.location == "/"
          ? DoubleBackToCloseWidget(
              snackBarMessage: "Press again to leave",
              child: child,
            )
          : WillPopCustom(
              onWillPop: () {
                context.go("/");
                return false;
              },
              child: child,
            ),
    );
  }
}
