import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/search/ui/screens/list_screen.dart';
import 'package:flutter_detextre4/routes/search/ui/screens/search_screen.dart';
import 'package:flutter_detextre4/routes/search/ui/screens/search_screen_two.dart';
import 'package:flutter_detextre4/routes/user/ui/screens/user_screen.dart';
import 'package:flutter_detextre4/home_screen.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:provider/provider.dart';

// * ----------------------- Router navigator config ------------------------ //
///? Collection of allowed routes from app.
///
/// ? here can setup your custome route names.
enum RouterNavigatorNames {
  user,
  home,
  search,
  searchTwo,
  list,
}

// ? setup your custome routes
/// Navigator router configuration class from app.
enum RouterNavigatorRoutes {
  userRoute(name: "User", icon: Icon(Icons.person), pages: [
    RouterNavigatorPages(
      routeName: RouterNavigatorNames.user,
      routePage: UserScreen(),
    ),
  ]),
  homeRoute(name: "Home", icon: Icon(Icons.home), pages: [
    RouterNavigatorPages(
      routeName: RouterNavigatorNames.home,
      routePage: HomeScreen(),
    ),
  ]),
  searchRoute(name: "Search", icon: Icon(Icons.search), pages: [
    RouterNavigatorPages(
      routeName: RouterNavigatorNames.search,
      routePage: SearchScreen(),
    ),
    RouterNavigatorPages(
      routeName: RouterNavigatorNames.searchTwo,
      routePage: SearchScreenTwo(),
    ),
    RouterNavigatorPages(
      routeName: RouterNavigatorNames.list,
      routePage: ListScreen(),
    ),
  ]);

  const RouterNavigatorRoutes({
    required this.pages,
    required this.icon,
    required this.name,
  });
  final List<RouterNavigatorPages> pages;
  final Icon icon;
  final String name;
}

// * ---------------------- Router navigator methods ------------------------ //

class RouterNavigator {
  static MainProvider get _getMainProvider =>
      Provider.of<MainProvider>(globalNavigatorKey.currentContext!,
          listen: false);

  /// All routes registered in app.
  static List<RouterNavigatorRoutes> get routes => RouterNavigatorRoutes.values;

  /// Current `indexTab`.
  static int get indexTab => _getMainProvider.indexTab;

  /// Current `indexRoute`.
  static int get indexRoute => _getMainProvider.indexRoute;

  /// Current name of the route page.
  static String get currentName =>
      routes[indexTab].pages[indexRoute].routeName.name;

  /// Current widget page of the route.
  static Widget get currentPage => routes[indexTab].pages[indexRoute].routePage;

  /// Current route name.
  static String get currentRoute => routes[indexTab].name;

  /// `List` of navigated pages storage in cache.
  static List<RouterNavigatorPages> get cachedNavigation =>
      List.unmodifiable(_getMainProvider.cachedIndexNavigation
          .map((e) => routes[e.indexTab].pages[e.indexRoute]));

  /// Push any route using router navigator from app.
  ///
  /// if widget is not founded into [RouterNavigatorRoutes] will pushed using
  /// `push` method from `Navigator`.
  static void push(Widget page) => _getMainProvider.setCurrentNavigation = page;

  /// Push any route using router navigator from app.
  static void pushNamed(RouterNavigatorNames name) =>
      _getMainProvider.setCurrentNavigationByName = name;

  /// Go back based on router navigator cache.
  static void pop() => _getMainProvider.setRouterBack();

  /// Go back based on quantity provided.
  static void popBy(int index) => _getMainProvider.setRouterBackBy = index;

  /// Go to the first route from the current router navigator cache.
  static void popUntilFirst() => _getMainProvider.setRouterBackUntilFirst();
}

// * ---------------------- Router navigator models ------------------------- //

class RouterNavigatorPages {
  const RouterNavigatorPages({
    required this.routeName,
    required this.routePage,
  });
  final RouterNavigatorNames routeName;
  final Widget routePage;
}

class CachedIndexNavigation {
  const CachedIndexNavigation({
    required this.indexTab,
    required this.indexRoute,
  });
  final int indexTab;
  final int indexRoute;
}
