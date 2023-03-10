import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';

class MainProvider extends ChangeNotifier {
  // ? -----------------------Navigation Provider---------------------------- //

  int indexTab = 1;
  int indexRoute = 0;
  List<CachedIndexNavigation> cachedIndexNavigation = <CachedIndexNavigation>[];

  // * Function just for main navigation tabs
  set setNavigationTab(int index) {
    cachedIndexNavigation.clear();
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

    if (indexTab == indexTabFinded) {
      cachedIndexNavigation.add(CachedIndexNavigation(
        indexTab: indexTab,
        indexRoute: indexRoute,
      ));
    } else {
      cachedIndexNavigation.clear();
    }

    indexTab = indexTabFinded;
    indexRoute = indexRouteFinded;
    notifyListeners();
  }

  // * set route back
  void setRouteBack() {
    if (cachedIndexNavigation.isEmpty) {
      indexRoute = 0;
    } else {
      indexRoute = cachedIndexNavigation.last.indexRoute;
      cachedIndexNavigation.removeLast();
    }
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

  // ? ----------------------Theme switcher Provider------------------------- //

  ThemeType appTheme = ThemeType.light;

  // * switch theme
  set switchTheme(ThemeType newTheme) {
    appTheme = newTheme;
    notifyListeners();
  }

  // ? ---------------------------------------------------------------------- //

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
