import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/model/language_list.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:flutter_detextre4/utils/local_data/hive_data.dart';

class MainProvider extends ChangeNotifier {
  // ? ----------------------Localization translate-------------------------- //
  Locale locale = Locale(HiveData.read(HiveDataCollection.language) ??
      LanguageList.deviceLanguage().lcidString);

  set changeLocale(LanguageList value) {
    HiveData.write(HiveDataCollection.language, value.lcidString);
    locale = Locale(value.lcidString);
    notifyListeners();
  }

  // ? -----------------------Navigation Provider---------------------------- //

  int indexTab = 1;
  int indexRoute = 0;
  List<CachedIndexNavigation> cachedIndexNavigation = <CachedIndexNavigation>[];

  /// * Function just for main navigation tabs
  set setNavigationTab(int index) {
    cachedIndexNavigation.clear();
    indexTab = index;
    indexRoute = 0;
    notifyListeners();
  }

  /// * Set current navigation
  set setCurrentNavigation(Widget page) {
    final int indexTabFinded =
        RouterNavigatorPages.values.indexWhere((element) {
      final navigationRouteFinded = element.routes.firstWhereOrNull(
          (element) => element.routePage.toString() == page.toString());
      if (navigationRouteFinded == null) return false;

      return navigationRouteFinded.routePage.toString() == page.toString();
    });

    if (indexTabFinded == -1) {
      Navigator.of(globalNavigatorKey.currentContext!)
          .push(MaterialPageRoute(builder: (context) => page));
      return;
    }

    final int indexRouteFinded =
        RouterNavigatorPages.values[indexTabFinded].routes.indexWhere(
            (element) => element.routePage.toString() == page.toString());

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

  /// * Set current navigation by name
  set setCurrentNavigationByName(RouterNavigatorNames name) {
    final int indexTabFinded =
        RouterNavigatorPages.values.indexWhere((element) {
      final navigationRouteFinded = element.routes
          .firstWhereOrNull((element) => element.routeName == name);
      if (navigationRouteFinded == null) {
        return false;
      }

      return navigationRouteFinded.routeName == name;
    });
    final int indexRouteFinded = RouterNavigatorPages
        .values[indexTabFinded].routes
        .indexWhere((element) => element.routeName == name);

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

  /// * Set route back
  void setRouterBack() {
    if (cachedIndexNavigation.isEmpty) {
      indexRoute = 0;
    } else {
      indexRoute = cachedIndexNavigation.last.indexRoute;
      cachedIndexNavigation.removeLast();
    }
    notifyListeners();
  }

  /// * Set route back by
  set setRouterBackBy(int index) {
    if (indexRoute - index < 0) {
      throw Exception("Can't go back!");
    }

    indexRoute -= index;
    notifyListeners();
  }

  /// * Set route back until first
  void setRouterBackUntilFirst() {
    indexRoute = 0;
    notifyListeners();
  }

  // ? ----------------------Theme switcher Provider------------------------- //
  /// Current app theme.
  ThemeType appTheme = ThemeType.light;

  /// Setter to switch the current app theme from [ThemeType] value.
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
