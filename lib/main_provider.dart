import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/models/profile_model.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/custom_ticker_provider.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';

class MainProvider extends ChangeNotifier {
  // ? ---------------------------Collections-------------------------------- //
  //

  // ? -------------------------Global variables----------------------------- //
  bool appStarted = false;

  get setAppStarted {
    if (appStarted) return;

    appStarted = true;
    notifyListeners();
  }

  ProfileModel? profile;

  set setProfile(ProfileModel value) {
    profile = value;
    notifyListeners();
  }

  get clearProfile => profile = null;
  bool stopProcess = false;
  set setStopProcess(bool value) {
    stopProcess = value;
    notifyListeners();
  }

  bool returnAuthError = false;
  set setReturnAuthError(bool value) {
    returnAuthError = value;
    notifyListeners();
  }

  // ? ----------------------Bottom Navigation Bar Provider--------------------------- //
  final bottomNavigationBarController = AnimationController(
    vsync: CustomTickerProvider(),
    duration: Durations.short3,
  );
  void showBottomNavigationBar() => bottomNavigationBarController.forward();
  void hideBottomNavigationBar() => bottomNavigationBarController.reverse();

  // ? ------------------------Snackbar Provider----------------------------- //
  final List<Flushbar> snackbars = [];

  set addSnackbar(Flushbar flushbar) {
    snackbars.add(flushbar);
    notifyListeners();
  }

  void get clearSnackbars {
    for (final element in snackbars) {
      element.dismiss();
    }

    snackbars.clear();
    notifyListeners();
  }

  void get removeLastSnackbar {
    snackbars.last.dismiss();
    snackbars.removeLast();
    notifyListeners();
  }

  void get removeFirstSnackbar {
    snackbars.first.dismiss();
    snackbars.removeAt(0);
    notifyListeners();
  }

  // ? ----------------------Theme switcher Provider------------------------- //
  /// Current app theme.
  ThemeType appTheme = ThemeType.values.firstWhereOrNull((element) =>
          element.name == HiveData.read(HiveDataCollection.theme)) ??
      ThemeType.light;

  /// Setter to switch the current app theme from [ThemeType] value.
  set switchTheme(ThemeType newTheme) {
    appTheme = newTheme;
    HiveData.write(HiveDataCollection.theme, newTheme.name);
    notifyListeners();
  }

  // ? ----------------------Localization translate-------------------------- //
  /// Current locale.
  Locale locale = Locale(HiveData.read(HiveDataCollection.language) ??
      LanguageList.deviceLanguage.name);

  /// change current locale.
  set changeLocale(LanguageList value) {
    locale = Locale(value.name);
    HiveData.write(HiveDataCollection.language, value.name);
    notifyListeners();
  }

  // ? ---------------------------------------------------------------------- //

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
