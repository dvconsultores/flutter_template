import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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

// * Themes app
///? A Collection of app themes.
enum ThemeType {
  light,
  dark;
}

/// Themes configuration class from app.
class ThemeApp {
  static final _themes = <ThemeType, ThemeData>{
    // ? ligth
    ThemeType.light: ThemeData.light().copyWith(
      textTheme: GoogleFonts.latoTextTheme().merge(ThemeData.light().textTheme),
      primaryColor: Colors.amber,
      focusColor: const Color.fromARGB(255, 255, 17, 0),
      disabledColor: const Color.fromARGB(255, 209, 175, 172),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 231, 225, 225),
      ),
      colorScheme: const ColorScheme.light(
        background: Colors.white,
        primary: Colors.amber,
        secondary: Colors.red,
        tertiary: Colors.deepPurpleAccent,
        error: Colors.red,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        ThemeDataColorExtension(
          text: Colors.black,
          accent: Colors.red,
          success: Colors.green,
        ),
        ThemeDataStyleExtension(
          customText: TextStyle(),
        ),
      ],
    ),

    // ? dark
    ThemeType.dark: ThemeData.dark().copyWith(
      textTheme: GoogleFonts.latoTextTheme().merge(ThemeData.dark().textTheme),
      primaryColor: Colors.pink,
      focusColor: const Color.fromARGB(255, 0, 32, 215),
      disabledColor: const Color.fromARGB(255, 138, 146, 191),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 39, 37, 37),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.pink,
        secondary: Colors.red,
        tertiary: Colors.deepPurpleAccent,
        error: Colors.red,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        ThemeDataColorExtension(
          text: Colors.white,
          accent: Colors.indigo,
          success: Colors.green,
        ),
        ThemeDataStyleExtension(
          customText: TextStyle(),
        ),
      ],
    ),
  };

  ///* Getter to current theme name.
  static ThemeType get theme =>
      globalNavigatorKey.currentContext!.watch<MainProvider>().appTheme;

  ///* Getter to current theme assets directory `assets/themes/${theme}`.
  static String assetsPrefix(BuildContext? context) =>
      'assets/themes/${(context ?? globalNavigatorKey.currentContext!).watch<MainProvider>().appTheme.name}';

  ///* Getter to current themeData.
  static ThemeData of(BuildContext? context) =>
      _themes[(context ?? globalNavigatorKey.currentContext!)
          .watch<MainProvider>()
          .appTheme]!;

  ///* Switch between themeData.
  static void switchTheme(BuildContext? context, ThemeType themeType) =>
      (context ?? globalNavigatorKey.currentContext!)
          .read<MainProvider>()
          .switchTheme = themeType;

  ///* Getter to all custom colors registered in themeData.
  static ColorsApp colors(BuildContext? context) {
    final themeData = Theme.of(context ?? globalNavigatorKey.currentContext!);

    return ColorsApp(
      background: themeData.colorScheme.background,
      primary: themeData.colorScheme.primary,
      secondary: themeData.colorScheme.secondary,
      tertiary: themeData.colorScheme.tertiary,
      error: themeData.colorScheme.error,
      focusColor: themeData.focusColor,
      disabledColor: themeData.disabledColor,
      text: themeData.extension<ThemeDataColorExtension>()!.text!,
      accent: themeData.extension<ThemeDataColorExtension>()!.accent!,
      success: themeData.extension<ThemeDataColorExtension>()!.success!,
    );
  }

  ///* Getter to all custom styles registered in themeData.
  static ThemeDataStyleExtension styles(BuildContext? context) {
    final themeData = Theme.of(context ?? globalNavigatorKey.currentContext!);

    return ThemeDataStyleExtension(
      customText: themeData.extension<ThemeDataStyleExtension>()!.customText,
    );
  }
}

///? Collection of all custom colors registered in themeData
class ColorsApp {
  const ColorsApp({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.focusColor,
    required this.disabledColor,
    required this.text,
    required this.accent,
    required this.success,
  });
  final Color background;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color focusColor;
  final Color disabledColor;
  final Color text;
  final Color accent;
  final Color success;
}

// ? Theme data color extension
@immutable
class ThemeDataColorExtension extends ThemeExtension<ThemeDataColorExtension> {
  const ThemeDataColorExtension({
    this.text,
    this.accent,
    this.success,
  });
  final Color? text;
  final Color? accent;
  final Color? success;

  @override
  ThemeDataColorExtension copyWith({
    Color? text,
    Color? accent,
    Color? success,
  }) {
    return ThemeDataColorExtension(
      text: text ?? this.text,
      accent: accent ?? this.accent,
      success: success ?? this.success,
    );
  }

  @override
  ThemeDataColorExtension lerp(ThemeDataColorExtension? other, double t) {
    if (other is! ThemeDataColorExtension) return this;

    return ThemeDataColorExtension(
      text: Color.lerp(text, other.text, t),
      accent: Color.lerp(accent, other.accent, t),
      success: Color.lerp(success, other.success, t),
    );
  }

  @override
  String toString() =>
      'ThemeDataColorExtension(text: $text, accent: $accent, success: $success)';
}

// ? Theme data style extension
@immutable
class ThemeDataStyleExtension extends ThemeExtension<ThemeDataStyleExtension> {
  const ThemeDataStyleExtension({
    required this.customText,
  });
  final TextStyle customText;

  @override
  ThemeDataStyleExtension copyWith({
    TextStyle? customText,
  }) {
    return ThemeDataStyleExtension(
      customText: customText ?? this.customText,
    );
  }

  @override
  ThemeDataStyleExtension lerp(ThemeDataStyleExtension? other, double t) {
    if (other is! ThemeDataStyleExtension) return this;

    return const ThemeDataStyleExtension(
      customText: TextStyle(),
    );
  }

  @override
  String toString() => 'ThemeDataStyleExtension(customText: $customText)';
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
          !kIsWeb ? Platform.localeName.contains(element.name) : false) ??
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
