import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// * themes app
enum ThemeType {
  light,
  dark;
}

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

  static ThemeData getTheme(BuildContext context) =>
      themes[context.watch<MainProvider>().appTheme]!;

  static String getAssetsTheme(BuildContext context) =>
      'assets/themes/${context.watch<MainProvider>().appTheme.name}';
}

// * colors app
enum ColorType {
  primary,
  secondary,
  accent,
  active,
  disabled;
}

class AppColors {
  static final colors = <ThemeType, Map<ColorType, Color>>{
    ThemeType.light: {
      ColorType.primary: Colors.indigo,
      ColorType.secondary: Colors.pink,
      ColorType.accent: Colors.red,
      ColorType.active: const Color.fromARGB(255, 255, 17, 0),
      ColorType.disabled: const Color.fromARGB(255, 209, 175, 172),
    },
    ThemeType.dark: {
      ColorType.primary: Colors.pink,
      ColorType.secondary: Colors.red,
      ColorType.accent: Colors.indigo,
      ColorType.active: const Color.fromARGB(255, 0, 32, 215),
      ColorType.disabled: const Color.fromARGB(255, 138, 146, 191),
    },
  };

  static Color getColor(BuildContext context, ColorType color) {
    final theme = context.watch<MainProvider>().appTheme;
    return colors[theme]![color]!;
  }
}
