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

/// ? A Collection of diverse languages.
enum LanguageList {
  en(
    value: 'english',
    lcidString: 'en_US',
    locale: Locale("en"),
    decimalSeparator: '.',
  ),
  es(
    value: 'español',
    lcidString: 'es_ES',
    locale: Locale("es"),
    decimalSeparator: ',',
  ),
  pt(
    value: 'português',
    lcidString: 'pt_BR',
    locale: Locale("pt"),
    decimalSeparator: '.',
  ),
  fr(
    value: 'français',
    lcidString: 'fr_FR',
    locale: Locale("fr"),
    decimalSeparator: '.',
  ),
  de(
    value: 'deutsch',
    lcidString: 'de_DE',
    locale: Locale("de"),
    decimalSeparator: '.',
  ),
  it(
    value: 'italiano',
    lcidString: 'it_IT',
    locale: Locale("it"),
    decimalSeparator: '.',
  ),
  ru(
    value: 'pусский',
    lcidString: 'ru',
    locale: Locale("ru"),
    decimalSeparator: '.',
  ),
  ja(
    value: '日本語',
    lcidString: 'ja',
    locale: Locale("ja"),
    decimalSeparator: '.',
  ),
  ko(
    value: '한국어',
    lcidString: 'ko',
    locale: Locale("ko"),
    decimalSeparator: '.',
  ),
  zh(
    value: '中文',
    lcidString: 'zh_CN',
    locale: Locale("zh"),
    decimalSeparator: '.',
  ),
  ar(
    value: 'العربية',
    lcidString: 'ar_SA',
    locale: Locale("ar"),
    decimalSeparator: '.',
  ),
  hi(
    value: 'हिंदी',
    lcidString: 'hi',
    locale: Locale("hi"),
    decimalSeparator: '.',
  ),
  vi(
    value: 'tiếng Việt',
    lcidString: 'vi',
    locale: Locale("vi"),
    decimalSeparator: '.',
  ),
  th(
    value: 'ภาษาไทย',
    lcidString: 'th',
    locale: Locale("th"),
    decimalSeparator: '.',
  ),
  tr(
    value: 'türkçe',
    lcidString: 'tr',
    locale: Locale("tr"),
    decimalSeparator: '.',
  ),
  nl(
    value: 'nederlands',
    lcidString: 'nl_NL',
    locale: Locale("nl"),
    decimalSeparator: '.',
  );

  const LanguageList({
    required this.value,
    required this.lcidString,
    required this.locale,
    required this.decimalSeparator,
  });
  final String value;
  final String lcidString;
  final Locale locale;
  final String decimalSeparator;

  static LanguageList get deviceLanguage =>
      LanguageList.values.firstWhereOrNull((element) =>
          !kIsWeb ? io.Platform.localeName.contains(element.name) : false) ??
      LanguageList.en;

  static LanguageList get(String? locale) =>
      LanguageList.values.singleWhereOrNull(
        (element) =>
            element.lcidString == locale ||
            element.locale.toLanguageTag() == locale,
      ) ??
      deviceLanguage;
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
