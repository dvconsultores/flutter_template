import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';

class MainProvider extends ChangeNotifier {
  // * Global context key
  final globalScaffoldKey = GlobalKey<ScaffoldState>();
  final globalNavigatorKey = GlobalKey<NavigatorState>();

  // ------------------------------------------------------------------------ //

  // * Navigation Provider
  int indexTab = 1;
  int indexRoute = 0;
  // static int? indexRoutePrevious; // ? under testing
  // static int navigationRouteCounterHelper = 0;  // ? under testing

  // ? Function just for main navigation tabs
  set setNavigationTab(int index) {
    indexTab = index;
    indexRoute = 0;
    notifyListeners();
  }

  // * set currentNavigation
  set setCurrentNavigation(NavigationRoutesName name) {
    final int indexTabFinded = NavigationRoutes.values.indexWhere((element) {
      final navigationRouteFinded =
          element.routes.firstWhereOrNull((element) => element.name == name);
      if (navigationRouteFinded == null) {
        return false;
      }

      return navigationRouteFinded.name == name;
    });
    final int indexRouteFinded = NavigationRoutes.values[indexTabFinded].routes
        .indexWhere((element) => element.name == name);

    indexTab = indexTabFinded;
    indexRoute = indexRouteFinded;
    notifyListeners();
  }

  // * set route back by
  set setRouteBackBy(int index) {
    if (indexRoute - index < 0) {
      throw Exception("Can't go back!");
    }

    indexRoute -= index;
    notifyListeners();
  }

  // * set route back until first
  void setRouteBackUntilFirst() {
    indexRoute = 0;
    notifyListeners();
  }

  // ------------------------------------------------------------------------ //

  // * Theme switcher Provider
  ThemeType appTheme = ThemeType.light;

  set switchTheme(ThemeType newTheme) {
    appTheme = newTheme;
    notifyListeners();
  }

  // ------------------------------------------------------------------------ //

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
