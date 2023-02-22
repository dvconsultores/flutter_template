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
  static int? indexRoutePrevious;
  static int navigationRouteCounterHelper = 0;

  // ? Function just for main navigation tabs
  set setNavigationTab(int index) {
    indexTab = index;
    indexRoute = 0;
    notifyListeners();
  }

  set setCurrentNavigation(NavigationRoutesPath path) {
    final int indexTabFinded = NavigationRoutes.values.indexWhere((element) {
      final mapElement = element.routes
          .firstWhereOrNull((element) => element.containsValue(path));
      if (mapElement == null) {
        return false;
      }

      return mapElement.values.contains(path);
    });
    final int indexRouteFinded = NavigationRoutes.values[indexTabFinded].routes
        .indexWhere((element) => element.containsValue(path));

    if (navigationRouteCounterHelper > 0) {
      indexRoutePrevious = indexRoute;
    }

    indexTab = indexTabFinded;
    indexRoute = indexRouteFinded;
    navigationRouteCounterHelper++;
    notifyListeners();
  }

  set setRouteBackBy(int index) {
    if (indexRoute - index < 0) {
      throw Exception("Cant go back!");
    }

    indexRoute -= index;
    notifyListeners();
  }

  void setRouteBackUntilFirst() {
    indexRoute = 0;
    notifyListeners();
  }

  // ? first try
  // set setCurrentNavigation(NavigationRoutesPath path) {
  //   final int indexTabFinded =
  //       NavigationRoutes.values.indexWhere((element) => element.routes
  //           .singleWhere(
  //             (element) => element.containsValue(path),
  //             orElse: () => NavigationRoutes.homeRoute.routes.first,
  //           )
  //           .values
  //           .contains(path));
  //   final int indexRouteFinded = NavigationRoutes.values[indexTabFinded].routes
  //       .indexWhere((element) => element.containsValue(path));

  //   indexTab = indexTabFinded;
  //   indexRoute = indexRouteFinded;
  //   notifyListeners();
  // }

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
