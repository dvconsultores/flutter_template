import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/models/profile_model.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';
import 'package:provider/provider.dart';

class MainProvider extends ChangeNotifier {
  static MainProvider read([BuildContext? context]) =>
      (context ?? ContextUtility.context!).read<MainProvider>();
  static MainProvider watch([BuildContext? context]) =>
      (context ?? ContextUtility.context!).watch<MainProvider>();

  // ? ---------------------------Collections-------------------------------- //
  //

  // ? -------------------------Global variables----------------------------- //
  bool appStarted = false;
  void get setAppStarted {
    if (appStarted) return;

    appStarted = true;
    notifyListeners();
  }

  ProfileModel? profile;
  get clearProfile => profile = null;
  set setProfile(ProfileModel value) {
    profile = value;
    notifyListeners();
  }

  bool preventModal = false;
  set setPreventModal(bool value) {
    preventModal = value;
    notifyListeners();
  }

  bool returnDioAuthError = false;
  set setReturnDioAuthError(bool value) {
    returnDioAuthError = value;
    notifyListeners();
  }

  BuildContext? currentNavContext;
  set setCurrentNavContext(BuildContext? context) {
    currentNavContext = context;
  }

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
  ThemeMode appTheme = ThemeMode.values.firstWhereOrNull((element) =>
          element.name == HiveData.read(HiveDataCollection.theme)) ??
      ThemeMode.system;

  /// Setter to switch the current app theme from [ThemeType] value.
  set switchTheme(ThemeMode newTheme) {
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
