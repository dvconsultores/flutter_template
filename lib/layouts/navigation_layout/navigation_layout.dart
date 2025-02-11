import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_screen.dart';
import 'package:flutter_detextre4/utils/services/initialization_service.dart';
import 'package:flutter_detextre4/utils/services/reminder_service.dart';
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

class _NavigationLayoutState extends State<NavigationLayout>
    with WidgetsBindingObserver {
  late final InitializationService initializationService;

  ScaffoldState? scaffoldState;
  void setScaffoldState(BuildContext? context) {
    if (context == null) return scaffoldState = null;
    scaffoldState ??= Scaffold.of(context);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      ReminderService.validate();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    initializationService = InitializationService(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
