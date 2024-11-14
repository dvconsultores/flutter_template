import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_screen.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:go_router/go_router.dart';

class NavigationLayout extends StatefulWidget {
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
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  ScaffoldState? scaffoldState;
  void setScaffoldState(BuildContext context) =>
      scaffoldState ??= Scaffold.of(context);

  @override
  Widget build(BuildContext context) {
    if (routerConfig.router.indexShellRoute == -1) {
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

    void handlerTapItem(BuildContext context, int index) =>
        routerConfig.router.goNamed(items.entries.elementAt(index).key);

    return NavigationInherited(
      state: widget.state,
      items: items,
      currentIndex: routerConfig.router.indexShellRoute,
      handlerTapItem: handlerTapItem,
      setScaffoldState: setScaffoldState,
      child: NavigationScreen(
        swipeNavigate: widget.swipeNavigate,
        child: widget.child,
      ),
    );
  }
}

class NavigationInherited extends InheritedWidget {
  const NavigationInherited({
    super.key,
    required this.state,
    required super.child,
    required this.items,
    required this.currentIndex,
    required this.handlerTapItem,
    required this.setScaffoldState,
  });
  final GoRouterState state;
  final Map<String, BottomNavigationBarItem> items;
  final int currentIndex;
  final void Function(BuildContext context, int index) handlerTapItem;
  final void Function(BuildContext context) setScaffoldState;

  @override
  bool updateShouldNotify(NavigationInherited oldWidget) => true;
}
