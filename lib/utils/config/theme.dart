// * Themes app
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
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
    "100": "extra_light",
    "200": "semi_light",
    "300": "light",
    "400": "normal",
    "500": "medium",
    "600": "semi_bold",
    "700": "bold",
    "800": "extra_bold",
    "900": "black",
  };

  static String lato(String value) => 'Lato_${_conversion[value] ?? value}';
}

/// Themes configuration class from app.
class ThemeApp {
  static SystemUiOverlayStyle get systemUiOverlayStyle =>
      theme == ThemeType.light
          ? const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              systemStatusBarContrastEnforced: true,
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              systemStatusBarContrastEnforced: true,
              systemNavigationBarIconBrightness: Brightness.dark,
            );

  static Map<ThemeType, ThemeData> get _themes {
    final ligthTheme = ThemeData.light(useMaterial3: false);
    final darkTheme = ThemeData.dark(useMaterial3: false);

    return {
      // ? ligth
      ThemeType.light: ligthTheme.copyWith(
        // text config
        textTheme: GoogleFonts.latoTextTheme(ligthTheme.textTheme.copyWith(
          bodyMedium: ligthTheme.textTheme.bodyLarge?.copyWith(fontSize: 16),
        )),
        visualDensity: VisualDensity.compact,

        // color config
        primaryColor: Colors.amber,
        focusColor: const Color.fromARGB(255, 255, 17, 0),
        disabledColor: const Color.fromARGB(255, 209, 175, 172),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 231, 225, 225),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          outlineBorder: BorderSide(color: Color(0xFF46464F)),
        ),
        scaffoldBackgroundColor: const Color(0xfffafafa),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: Colors.red,
          color: Colors.amber,
        ),
        colorScheme: const ColorScheme.light(
          background: Color(0xFFF9F9F9),
          primary: Colors.amber,
          secondary: Colors.red,
          tertiary: Colors.deepPurpleAccent,
          error: Colors.red,
          outline: Colors.black,
        ),
        extensions: const <ThemeExtension<dynamic>>[
          ThemeDataColorExtension(
            text: Colors.black,
            accent: Colors.red,
            success: Colors.green,
            warning: Color.fromARGB(255, 233, 198, 2),
            label: Color.fromARGB(255, 129, 127, 129),
          ),
          ThemeDataStyleExtension(
            customText: TextStyle(),
          ),
        ],
      ),

      // ? dark
      ThemeType.dark: darkTheme.copyWith(),
    };
  }

  ///* Getter to current theme name.
  static ThemeType get theme =>
      ContextUtility.context?.watch<MainProvider>().appTheme ?? ThemeType.light;

  ///* Getter to current theme assets directory `assets/themes/${theme}`.
  static String assetsPrefix(BuildContext? context) =>
      'assets/themes/${(context ?? ContextUtility.context!).watch<MainProvider>().appTheme.name}';

  ///* Getter to current themeData.
  static ThemeData of(BuildContext? context) {
    final ctx = context ?? ContextUtility.context!;
    return _themes[ctx.watch<MainProvider>().appTheme]!;
  }

  ///* Switch between themeData.
  static void switchTheme(BuildContext? context, ThemeType themeType) =>
      (context ?? ContextUtility.context!).read<MainProvider>().switchTheme =
          themeType;

  ///* Getter to all custom colors registered in themeData.
  static ColorsApp colors(BuildContext? context) {
    final themeData = Theme.of(context ?? ContextUtility.context!);

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
      warning: themeData.extension<ThemeDataColorExtension>()!.warning!,
      label: themeData.extension<ThemeDataColorExtension>()!.label!,
    );
  }

  ///* Getter to all custom styles registered in themeData.
  static ThemeDataStyleExtension styles(BuildContext? context) {
    final themeData = Theme.of(context ?? ContextUtility.context!);

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
    required this.warning,
    required this.label,
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
  final Color warning;
  final Color label;
}

// ? Theme data color extension
@immutable
class ThemeDataColorExtension extends ThemeExtension<ThemeDataColorExtension> {
  const ThemeDataColorExtension({
    this.text,
    this.accent,
    this.success,
    this.warning,
    this.label,
  });
  final Color? text;
  final Color? accent;
  final Color? success;
  final Color? warning;
  final Color? label;

  @override
  ThemeDataColorExtension copyWith({
    Color? text,
    Color? accent,
    Color? success,
    Color? warning,
    Color? label,
  }) {
    return ThemeDataColorExtension(
      text: text ?? this.text,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      label: label ?? this.label,
    );
  }

  @override
  ThemeDataColorExtension lerp(ThemeDataColorExtension? other, double t) {
    if (other is! ThemeDataColorExtension) return this;

    return ThemeDataColorExtension(
      text: Color.lerp(text, other.text, t),
      accent: Color.lerp(accent, other.accent, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      label: Color.lerp(label, other.label, t),
    );
  }

  @override
  String toString() =>
      'ThemeDataColorExtension(text: $text, accent: $accent, success: $success, warning: $warning, label: $label)';
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
