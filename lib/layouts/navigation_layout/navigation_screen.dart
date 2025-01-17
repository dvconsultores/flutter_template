import 'package:double_back_to_exit/double_back_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/widgets/defaults/bottom_navigation_bar.dart';
import 'package:flutter_detextre4/widgets/defaults/drawer.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({
    super.key,
    required this.child,
    this.swipeNavigate = false,
    required this.state,
    required this.items,
    required this.currentRoute,
    required this.handlerTapItem,
    required this.setScaffoldState,
  });
  final Widget child;
  final bool swipeNavigate;
  final GoRouterState state;
  final Map<String, BottomNavigationBarItem> items;
  final GoRoute? currentRoute;
  final void Function(String routeName) handlerTapItem;
  final void Function(BuildContext context) setScaffoldState;

  @override
  Widget build(BuildContext context) {
    final isHome = currentRoute?.name == 'home';

    return GestureDetector(
      onHorizontalDragUpdate: swipeNavigate
          ? (details) {
              // Note: Sensitivity is integer used when you don't want to mess up vertical drag
              int sensitivity = 8;

              final navigationItems = items.keys.toList();

              // Right Swipe
              if (details.delta.dx > sensitivity) {
                final index = navigationItems.indexOf(currentRoute?.name ?? '');
                if (index > 0) context.goNamed(navigationItems[index - 1]);

                // Left Swipe
              } else if (details.delta.dx < -sensitivity) {
                final index = navigationItems.indexOf(currentRoute?.name ?? '');

                if (index < navigationItems.length) {
                  context.goNamed(navigationItems[index + 1]);
                }
              }
            }
          : null,
      child: DoubleBackToExit(
        mode: isHome ? DoubleBackMode.doublePop : DoubleBackMode.pop,
        snackBarMessage: "Press again to leave",
        onWillPop: () {
          if (context.canPop()) {
            context.pop();
          } else if (!isHome) {
            context.goNamed("home");
          }
        },
        child: Material(
          color: Colors.transparent,
          child: Scaffold(
            body: child,
            drawer: const AppDrawer(),
            appBar: AppBar(
              title: Text(currentRoute?.name?.toCapitalize() ?? ''),
            ),
            bottomNavigationBar: Builder(builder: (context) {
              setScaffoldState(context);

              return AppBottomNavigationBar(
                routeName: currentRoute?.name,
                onTap: (routeName) => handlerTapItem(routeName),
                items: items,
              );
            }),
          ),
        ),
      ),
    );
  }
}
