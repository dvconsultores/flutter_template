import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_screen.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:go_router/go_router.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout(
    this.state,
    this.child,
    this.currentRoute, {
    super.key,
    this.swipeNavigate = false,
  });
  final GoRouterState state;
  final Widget child;
  final GoRoute? currentRoute;
  final bool swipeNavigate;

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  final initializationService = MainProvider.read().initializationService;

  ScaffoldState? scaffoldState;
  void setScaffoldState(BuildContext? context) {
    if (context == null) return scaffoldState = null;
    scaffoldState ??= Scaffold.of(context);
  }

  @override
  void initState() {
    initializationService.inAppService.initBothInAppServices(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    void handlerTapItem(String routeName) {
      context.goNamed(routeName);
    }

    return NavigationScreen(
      state: widget.state,
      items: items,
      currentRoute: widget.currentRoute,
      handlerTapItem: handlerTapItem,
      setScaffoldState: setScaffoldState,
      swipeNavigate: widget.swipeNavigate,
      child: widget.child,
    );
  }
}
