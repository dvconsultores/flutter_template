import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterDetextre4/main.dart';
import 'package:flutterDetextre4/main_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

// * Responsive sizes
/// A list of sizes from device screen resolution
enum ScreenSizes {
  mobile(600),
  tablet(880),
  desktop(2000),
  tv(4000);

  const ScreenSizes(this.value);
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

// * Themes app
///? A Collection of app themes.
enum ThemeType {
  light,
  dark;
}

/// Themes configuration class from app.
mixin AppThemes {
  static final _themes = <ThemeType, ThemeData>{
    // ? ligth
    ThemeType.light: ThemeData.light().copyWith(
      textTheme: GoogleFonts.latoTextTheme(),
      primaryColor: Colors.amber,
      focusColor: const Color.fromARGB(255, 255, 17, 0),
      disabledColor: const Color.fromARGB(255, 209, 175, 172),
      colorScheme: const ColorScheme.light(
        primary: Colors.amber,
        secondary: Colors.red,
        tertiary: Colors.deepPurpleAccent,
        error: Colors.red,
      ),
      extensions: <ThemeExtension<dynamic>>[
        const ThemeDataExtension(
          text: Colors.black,
          accent: Colors.red,
          success: Colors.green,
        ),
      ],
    ),
    // ? dark
    ThemeType.dark: ThemeData(
      textTheme: GoogleFonts.latoTextTheme(),
      primaryColor: Colors.pink,
      focusColor: const Color.fromARGB(255, 0, 32, 215),
      disabledColor: const Color.fromARGB(255, 138, 146, 191),
      colorScheme: const ColorScheme.light(
        primary: Colors.pink,
        secondary: Colors.red,
        tertiary: Colors.deepPurpleAccent,
        error: Colors.red,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        ThemeDataExtension(
          text: Colors.white,
          accent: Colors.indigo,
          success: Colors.green,
        ),
      ],
    ),
  };

  ///* Getter to current theme name.
  static ThemeType get theme =>
      globalNavigatorKey.currentContext!.watch<MainProvider>().appTheme;

  ///* Getter to current theme data.
  static ThemeData themeData(BuildContext context) =>
      _themes[context.watch<MainProvider>().appTheme]!;

  ///* Getter to current theme assets directory.
  static String assetsPrefix(BuildContext context) =>
      'assets/themes/${context.watch<MainProvider>().appTheme.name}';
}

/// ? A Collection of diverse languages.
enum LanguageList {
  en(locale: 'english', lcidString: 'en_US'),
  es(locale: 'español', lcidString: 'es_ES'),
  pt(locale: 'português', lcidString: 'pt_BR'),
  fr(locale: 'français', lcidString: 'fr_FR'),
  de(locale: 'deutsch', lcidString: 'de_DE'),
  it(locale: 'italiano', lcidString: 'it_IT'),
  ru(locale: 'pусский', lcidString: 'ru'),
  ja(locale: '日本語', lcidString: 'ja'),
  ko(locale: '한국어', lcidString: 'ko'),
  zh(locale: '中文', lcidString: 'zh_CN'),
  ar(locale: 'العربية', lcidString: 'ar_SA'),
  hi(locale: 'हिंदी', lcidString: 'hi'),
  vi(locale: 'tiếng Việt', lcidString: 'vi'),
  th(locale: 'ภาษาไทย', lcidString: 'th'),
  tr(locale: 'türkçe', lcidString: 'tr'),
  nl(locale: 'nederlands', lcidString: 'nl_NL');

  const LanguageList({
    required this.locale,
    required this.lcidString,
  });
  final String locale;
  final String lcidString;

  static LanguageList deviceLanguage() {
    return LanguageList.values.firstWhereOrNull(
            (element) => Platform.localeName.contains(element.name)) ??
        LanguageList.en;
  }
}

mixin AppLocale {
  /// Get current locale.
  static Locale get locale =>
      globalNavigatorKey.currentContext!.read<MainProvider>().locale;

  /// A global function to change current language.
  static void changeLanguage(LanguageList value) =>
      globalNavigatorKey.currentContext!.read<MainProvider>().changeLocale =
          value;
}

// ? Theme data extension
@immutable
class ThemeDataExtension extends ThemeExtension<ThemeDataExtension> {
  const ThemeDataExtension({
    this.text,
    this.accent,
    this.success,
  });

  final Color? text;
  final Color? accent;
  final Color? success;

  @override
  ThemeDataExtension copyWith({
    Color? text,
    Color? accent,
    Color? success,
  }) {
    return ThemeDataExtension(
      text: text ?? this.text,
      accent: accent ?? this.accent,
      success: success ?? this.success,
    );
  }

  @override
  ThemeDataExtension lerp(ThemeDataExtension? other, double t) {
    if (other is! ThemeDataExtension) return this;

    return ThemeDataExtension(
      text: Color.lerp(text, other.text, t),
      accent: Color.lerp(accent, other.accent, t),
      success: Color.lerp(success, other.success, t),
    );
  }

  @override
  String toString() =>
      'ThemeDataExtension(text: $text, accent: $accent, success: $success)';
}
