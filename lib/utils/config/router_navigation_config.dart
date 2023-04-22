import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen_two.dart';
import 'package:flutter_detextre4/features/user/ui/screens/user_screen.dart';
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
}

// ? setup your custome routes
/// Navigator router configuration class from app.
enum RouterNavigatorPages {
  userRoute(name: "User", icon: Icon(Icons.person), routes: [
    RouterNavigatorModel(
      routeName: RouterNavigatorNames.user,
      routePage: UserScreen(),
    ),
  ]),
  homeRoute(name: "Home", icon: Icon(Icons.home), routes: [
    RouterNavigatorModel(
      routeName: RouterNavigatorNames.home,
      routePage: HomeScreen(),
    ),
  ]),
  searchRoute(name: "Search", icon: Icon(Icons.search), routes: [
    RouterNavigatorModel(
      routeName: RouterNavigatorNames.search,
      routePage: SearchScreen(),
    ),
    RouterNavigatorModel(
      routeName: RouterNavigatorNames.searchTwo,
      routePage: SearchScreenTwo(),
    ),
  ]);

  const RouterNavigatorPages({
    required this.routes,
    required this.icon,
    required this.name,
  });
  final List<RouterNavigatorModel> routes;
  final Icon icon;
  final String name;
}

// * ---------------------- Router navigator methods ------------------------ //

class RouterNavigator {
  static MainProvider get _getMainProvider =>
      Provider.of<MainProvider>(globalNavigatorKey.currentContext!,
          listen: false);

  /// All routes registered in app.
  static List<RouterNavigatorPages> get routes => RouterNavigatorPages.values;

  /// Current `indexTab`.
  static int get indexTab => _getMainProvider.indexTab;

  /// Current `indexRoute`.
  static int get indexRoute => _getMainProvider.indexRoute;

  /// Current name of the route.
  static String get currentName =>
      routes[indexTab].routes[indexRoute].routeName.name;

  /// Current widget page of the route.
  static Widget get currentPage =>
      routes[indexTab].routes[indexRoute].routePage;

  /// `List` of navigated routes storage in cache.
  static List<RouterNavigatorModel> get cachedNavigation =>
      List.unmodifiable(_getMainProvider.cachedIndexNavigation
          .map((e) => routes[e.indexTab].routes[e.indexRoute]));

  /// Push any route using router navigator from app.
  ///
  /// if widget is not founded into [RouterNavigatorPages] will pushed using
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

class RouterNavigatorModel {
  const RouterNavigatorModel({
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
