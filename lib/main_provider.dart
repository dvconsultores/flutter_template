import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';

class MainProvider extends ChangeNotifier {
  // * Navigation
  int indexTab = 1;

  set setNavigationIndex(int index) {
    indexTab = index;
    notifyListeners();
  }

  // ------------------------------------------------------------------------ //

  // * Theme switcher
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
