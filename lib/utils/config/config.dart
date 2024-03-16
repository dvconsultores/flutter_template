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
    thousandsSeparator: ',',
  ),
  es(
    value: 'español',
    lcidString: 'es_ES',
    locale: Locale("es"),
    decimalSeparator: ',',
    thousandsSeparator: '.',
  ),
  pt(
    value: 'português',
    lcidString: 'pt_BR',
    locale: Locale("pt"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  fr(
    value: 'français',
    lcidString: 'fr_FR',
    locale: Locale("fr"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  de(
    value: 'deutsch',
    lcidString: 'de_DE',
    locale: Locale("de"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  it(
    value: 'italiano',
    lcidString: 'it_IT',
    locale: Locale("it"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  ru(
    value: 'pусский',
    lcidString: 'ru',
    locale: Locale("ru"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  ja(
    value: '日本語',
    lcidString: 'ja',
    locale: Locale("ja"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  ko(
    value: '한국어',
    lcidString: 'ko',
    locale: Locale("ko"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  zh(
    value: '中文',
    lcidString: 'zh_CN',
    locale: Locale("zh"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  ar(
    value: 'العربية',
    lcidString: 'ar_SA',
    locale: Locale("ar"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  hi(
    value: 'हिंदी',
    lcidString: 'hi',
    locale: Locale("hi"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  vi(
    value: 'tiếng Việt',
    lcidString: 'vi',
    locale: Locale("vi"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  th(
    value: 'ภาษาไทย',
    lcidString: 'th',
    locale: Locale("th"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  tr(
    value: 'türkçe',
    lcidString: 'tr',
    locale: Locale("tr"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  ),
  nl(
    value: 'nederlands',
    lcidString: 'nl_NL',
    locale: Locale("nl"),
    decimalSeparator: '.',
    thousandsSeparator: ',',
  );

  const LanguageList({
    required this.value,
    required this.lcidString,
    required this.locale,
    required this.decimalSeparator,
    required this.thousandsSeparator,
  });
  final String value;
  final String lcidString;
  final Locale locale;
  final String decimalSeparator;
  final String thousandsSeparator;

  static LanguageList get deviceLanguage =>
      LanguageList.values.firstWhereOrNull((element) =>
          !kIsWeb ? io.Platform.localeName.contains(element.name) : false) ??
      LanguageList.en;

  static LanguageList get localeLanguage => LanguageList.values.firstWhere(
      (element) => AppLocale.locale.languageCode.contains(element.name));

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
