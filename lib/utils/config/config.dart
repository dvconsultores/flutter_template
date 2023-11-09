import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

/// * A collection about application name formats
enum AppName {
  camelcase('flutterDetextre4'),
  kedabcase('flutter-detextre4'),
  snakecase('flutter_detextre4'),
  capitalize('Flutter Detextre4');

  const AppName(this.value);
  final String value;
}

// * Responsive sizes
/// A list of sizes from device screen resolution
enum ScreenSize {
  mobile(600),
  tablet(880),
  desktop(2000),
  tv(4000);

  const ScreenSize(this.value);
  final int value;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile.value;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet.value;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width < desktop.value;
  static bool isTV(BuildContext context) =>
      MediaQuery.of(context).size.width < tv.value;
}

/// ? A Collection of diverse languages.
enum LanguageList {
  en(value: 'english', lcidString: 'en_US', locale: Locale("en")),
  es(value: 'español', lcidString: 'es_ES', locale: Locale("es")),
  pt(value: 'português', lcidString: 'pt_BR', locale: Locale("pt")),
  fr(value: 'français', lcidString: 'fr_FR', locale: Locale("fr")),
  de(value: 'deutsch', lcidString: 'de_DE', locale: Locale("de")),
  it(value: 'italiano', lcidString: 'it_IT', locale: Locale("it")),
  ru(value: 'pусский', lcidString: 'ru', locale: Locale("ru")),
  ja(value: '日本語', lcidString: 'ja', locale: Locale("ja")),
  ko(value: '한국어', lcidString: 'ko', locale: Locale("ko")),
  zh(value: '中文', lcidString: 'zh_CN', locale: Locale("zh")),
  ar(value: 'العربية', lcidString: 'ar_SA', locale: Locale("ar")),
  hi(value: 'हिंदी', lcidString: 'hi', locale: Locale("hi")),
  vi(value: 'tiếng Việt', lcidString: 'vi', locale: Locale("vi")),
  th(value: 'ภาษาไทย', lcidString: 'th', locale: Locale("th")),
  tr(value: 'türkçe', lcidString: 'tr', locale: Locale("tr")),
  nl(value: 'nederlands', lcidString: 'nl_NL', locale: Locale("nl"));

  const LanguageList({
    required this.value,
    required this.lcidString,
    required this.locale,
  });
  final String value;
  final String lcidString;
  final Locale locale;

  static LanguageList deviceLanguage() =>
      LanguageList.values.firstWhereOrNull((element) =>
          !kIsWeb ? io.Platform.localeName.contains(element.name) : false) ??
      LanguageList.en;
}

class AppLocale {
  /// Get current locale.
  static Locale get locale =>
      globalNavigatorKey.currentContext!.read<MainProvider>().locale;

  /// A global function to change current language.
  static void changeLanguage(LanguageList value) =>
      globalNavigatorKey.currentContext!.read<MainProvider>().changeLocale =
          value;
}
