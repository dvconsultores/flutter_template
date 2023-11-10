// * Themes app
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

///? A Collection of app themes.
enum ThemeType {
  light,
  dark;
}

///? A Mixin to getter some weigth of current font families.
/// use like `FontFamily.lato("400")`
mixin FontFamily {
  static final _conversion = {
    "400": "regular",
  };

  static String lato(String value) => 'Lato_${_conversion[value] ?? value}';
}

/// Themes configuration class from app.
class ThemeApp {
  static Map<ThemeType, ThemeData> get _themes {
    final ligthTheme = ThemeData.light();
    final darkTheme = ThemeData.dark();

    return {
      // ? ligth
      ThemeType.light: ligthTheme.copyWith(
        // text config
        textTheme: GoogleFonts.latoTextTheme(ligthTheme.textTheme.copyWith(
          bodyMedium: ligthTheme.textTheme.bodyLarge?.copyWith(fontSize: 16),
        )),

        // color config
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
      ThemeType.dark: darkTheme.copyWith(
        // text config
        textTheme: GoogleFonts.latoTextTheme(darkTheme.textTheme.copyWith(
          bodyMedium: ligthTheme.textTheme.bodyLarge?.copyWith(fontSize: 16),
        )),

        // color config
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
  }

  ///* Getter to current theme name.
  static ThemeType get theme =>
      globalNavigatorKey.currentContext!.watch<MainProvider>().appTheme;

  ///* Getter to current theme assets directory `assets/themes/${theme}`.
  static String assetsPrefix(BuildContext? context) =>
      'assets/themes/${(context ?? globalNavigatorKey.currentContext!).watch<MainProvider>().appTheme.name}';

  ///* Getter to current themeData.
  static ThemeData of(BuildContext? context) {
    final ctx = context ?? globalNavigatorKey.currentContext!;
    return _themes[ctx.watch<MainProvider>().appTheme]!;
  }

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
