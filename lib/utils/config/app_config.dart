import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// * Themes app
///? A Collection of app themes.
enum ThemeType {
  light,
  dark;
}

/// Themes configuration class from app.
class AppThemes {
  static final themes = <ThemeType, ThemeData>{
    ThemeType.light: ThemeData(
      textTheme: GoogleFonts.latoTextTheme(),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.amber,
        accentColor: Colors.red,
        cardColor: Colors.deepPurpleAccent,
      ),
    ),
    ThemeType.dark: ThemeData(
      textTheme: GoogleFonts.latoTextTheme(),
      primarySwatch: Colors.blue,
    ),
  };

  ///* Getter to current theme.
  static ThemeData getTheme(BuildContext context) =>
      themes[context.watch<MainProvider>().appTheme]!;

  ///* Getter to current theme assets directory.
  static String getAssetsTheme(BuildContext context) =>
      'assets/themes/${context.watch<MainProvider>().appTheme.name}';
}

// * Colors app
///? Collection of colors from app.
enum ColorType {
  primary,
  secondary,
  accent,
  active,
  disabled,
  success,
  error;
}

/// Colors configuration class from app.
class AppColors {
  static final colors = <ThemeType, Map<ColorType, Color>>{
    ThemeType.light: {
      ColorType.primary: Colors.indigo,
      ColorType.secondary: Colors.pink,
      ColorType.accent: Colors.red,
      ColorType.active: const Color.fromARGB(255, 255, 17, 0),
      ColorType.disabled: const Color.fromARGB(255, 209, 175, 172),
      ColorType.success: Colors.green,
      ColorType.error: Colors.red,
    },
    ThemeType.dark: {
      ColorType.primary: Colors.pink,
      ColorType.secondary: Colors.red,
      ColorType.accent: Colors.indigo,
      ColorType.active: const Color.fromARGB(255, 0, 32, 215),
      ColorType.disabled: const Color.fromARGB(255, 138, 146, 191),
      ColorType.success: Colors.green,
      ColorType.error: Colors.red,
    },
  };

  ///* Getter to colors based on current theme.
  static Color getColor(BuildContext context, ColorType color) {
    final theme = context.watch<MainProvider>().appTheme;
    return colors[theme]![color]!;
  }
}
