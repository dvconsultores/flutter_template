// * Themes app
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

///? A Class to get some weigth of current font families.
/// use like `FontFamily.lato("400")`
class FontFamily {
  static final _conversion = {
    "100": "extra_light",
    "200": "semi_light",
    "300": "light",
    "400": "regular",
    "500": "medium",
    "600": "semi_bold",
    "700": "bold",
    "800": "extra_bold",
    "900": "black",
  };

  static String lato(String value) => 'Lato_${_conversion[value] ?? value}';

  static String luckiestGuy(String value) =>
      'luckiestGuy_${_conversion[value] ?? value}';
}

/// Themes configuration class from app.
class ThemeApp {
  ThemeApp([this.context]);
  final BuildContext? context;

  SystemUiOverlayStyle get systemUiOverlayStyle => switch (theme) {
        Brightness.light => const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemStatusBarContrastEnforced: true,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        Brightness.dark => const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemStatusBarContrastEnforced: true,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
      };

  static T _getExtension<T>(Map<Object, ThemeExtension<dynamic>> extensions) =>
      extensions[T] as T;

  static ThemeData get lightTheme {
    final extensions = <Object, ThemeExtension<dynamic>>{
          ThemeDataColorExtension: const ThemeDataColorExtension(
            brightness: Colors.white,
            text: Color(0xFF4E444B),
            label: Color(0xFF777680),
            title: Color(0xFF4E444B),
            accent: Colors.red,
            success: Colors.green,
            warning: Color(0xFFFFDD00),
          ),
          ThemeDataStyleExtension: const ThemeDataStyleExtension(
            customText: TextStyle(),
          )
        },
        colorScheme = const ColorScheme.light(
          surface: Color(0xFFF9F9F9),
          primary: Color(0xff001689),
          secondary: Color(0xFFFF5100),
          tertiary: Color(0xFFF7E388),
          error: Color(0xFFFF5100),
          outline: Color(0xFF4E444B),
          brightness: Brightness.light,
        ),
        textTheme = TextTheme(
          // display
          displayLarge: GoogleFonts.luckiestGuy().copyWith(
            fontSize: 30,
            color: _getExtension<ThemeDataColorExtension>(extensions).title!,
            height: 1.1,
          ),
          displayMedium: GoogleFonts.luckiestGuy().copyWith(
            fontSize: 28,
            color: _getExtension<ThemeDataColorExtension>(extensions).title!,
            height: 1.1,
          ),
          displaySmall: GoogleFonts.luckiestGuy().copyWith(
            fontSize: 26,
            color: _getExtension<ThemeDataColorExtension>(extensions).title!,
            height: 1.1,
          ),
          // title
          titleLarge: TextStyle(
            fontSize: 24,
            color: _getExtension<ThemeDataColorExtension>(extensions).title!,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            height: 1.1,
          ),
          titleMedium: TextStyle(
            fontSize: 22,
            color: _getExtension<ThemeDataColorExtension>(extensions).title!,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            height: 1.1,
          ),
          titleSmall: TextStyle(
            fontSize: 20,
            color: _getExtension<ThemeDataColorExtension>(extensions).title!,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            height: 1.1,
          ),
          // label
          labelLarge: TextStyle(
            fontSize: 20,
            color: _getExtension<ThemeDataColorExtension>(extensions).label!,
            height: 1.1,
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            color: _getExtension<ThemeDataColorExtension>(extensions).label!,
            height: 1.1,
          ),
          labelSmall: TextStyle(
            color: _getExtension<ThemeDataColorExtension>(extensions).label!,
            fontSize: 16,
            height: 1.1,
          ),
          // body
          bodyLarge: TextStyle(
            fontSize: 18,
            color: _getExtension<ThemeDataColorExtension>(extensions).text!,
            height: 1.1,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: _getExtension<ThemeDataColorExtension>(extensions).text!,
            height: 1.1,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: _getExtension<ThemeDataColorExtension>(extensions).text!,
            height: 1.1,
          ),
        );

    return ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      useMaterial3: false,
      brightness: Brightness.light,
      // values config
      visualDensity: VisualDensity.compact,

      // color config
      primaryColor: colorScheme.primary,
      focusColor: const Color(0xFF3B4279),
      disabledColor: const Color.fromARGB(255, 209, 175, 172),
      cardColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xfffafafa),
      colorScheme: colorScheme,
      extensions: extensions.values,

      // dividerTheme
      dividerTheme: const DividerThemeData(color: Color(0xFF4E444B)),
      // appBarTheme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xfffafafa),
        titleTextStyle: textTheme.bodyLarge,
        iconTheme: const IconThemeData(),
      ),
      // bottomNavigationBarTheme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(235, 224, 221, 221),
      ),
      // dialogTheme
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFFF9F9F9),
        titleTextStyle: textTheme.bodyLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      // bottomSheetTheme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      // datePickerTheme
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: const Color(0xff001689),
        headerForegroundColor: Colors.white,
        dayForegroundColor: const WidgetStatePropertyAll(Color(0xFF535256)),
        weekdayStyle: const TextStyle(color: Color(0xFF001689)),
        dayStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
        cancelButtonStyle: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      // timePickerTheme
      timePickerTheme: TimePickerThemeData(
        cancelButtonStyle: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      // inputDecorationTheme
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        outlineBorder: BorderSide(color: Color(0xFF46464F)),
      ),
      // progressIndicatorTheme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        circularTrackColor: Colors.red,
        color: Color(0xff001689),
      ),

      // textTheme
      textTheme: textTheme,
    );
  }

  static ThemeData get darkTheme {
    final extensions = <Object, ThemeExtension<dynamic>>{
          ThemeDataColorExtension: const ThemeDataColorExtension(
            brightness: Colors.black,
            text: Color(0xFF4E444B),
            label: Color(0xFF777680),
            title: Color(0xFF4E444B),
            accent: Colors.red,
            success: Colors.green,
            warning: Color(0xFFFFDD00),
          ),
          ThemeDataStyleExtension: const ThemeDataStyleExtension(
            customText: TextStyle(),
          )
        },
        colorScheme = const ColorScheme.dark(
          brightness: Brightness.dark,
        ),
        textTheme = const TextTheme();

    return ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      useMaterial3: false,
      brightness: Brightness.dark,
      // values config
      visualDensity: VisualDensity.compact,

      // color config
      primaryColor: colorScheme.primary,
      focusColor: const Color(0xFF3B4279),
      disabledColor: const Color.fromARGB(255, 209, 175, 172),
      cardColor: Colors.black,
      scaffoldBackgroundColor: Colors.black26,
      colorScheme: colorScheme,
      extensions: extensions.values,

      // bottomNavigationBarTheme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 17, 17, 17),
      ),

      // textTheme
      textTheme: textTheme,
    );
  }

  ///* Getter to [ThemeApp] instance
  static ThemeApp of(BuildContext? context) =>
      ThemeApp(context ?? ContextUtility.context);

  ///* Getter to current theme name.
  Brightness get theme => Theme.of(context!).brightness;

  ///* Getter to current [ThemeData].
  ThemeData get themeData => Theme.of(context!);

  ///* Getter to current theme assets directory `assets/themes/${theme}/` + path provided.
  String getAsset(String path) {
    final brightness = MediaQuery.of(context!).platformBrightness;

    return 'assets/themes/${brightness.name}/$path';
  }

  ///* Switch between themeData.
  void switchTheme(ThemeMode themeType) =>
      context!.read<MainProvider>().switchTheme = themeType;

  ///* Getter to current [TextTheme]
  TextTheme get textTheme => Theme.of(context!).textTheme;

  ///* Getter to all custom colors registered in themeData.
  ColorsApp get colors {
    final themeData = Theme.of(context!);

    return ColorsApp(
      surface: themeData.colorScheme.surface,
      primary: themeData.colorScheme.primary,
      secondary: themeData.colorScheme.secondary,
      tertiary: themeData.colorScheme.tertiary,
      error: themeData.colorScheme.error,
      focusColor: themeData.focusColor,
      disabledColor: themeData.disabledColor,
      brightness: themeData.extension<ThemeDataColorExtension>()!.brightness!,
      text: themeData.extension<ThemeDataColorExtension>()!.text!,
      label: themeData.extension<ThemeDataColorExtension>()!.label!,
      title: themeData.extension<ThemeDataColorExtension>()!.title!,
      accent: themeData.extension<ThemeDataColorExtension>()!.accent!,
      success: themeData.extension<ThemeDataColorExtension>()!.success!,
      warning: themeData.extension<ThemeDataColorExtension>()!.warning!,
    );
  }

  ///* Getter to all custom styles registered in themeData.
  ThemeDataStyleExtension get styles {
    final themeData = Theme.of(context!);

    return ThemeDataStyleExtension(
      customText: themeData.extension<ThemeDataStyleExtension>()!.customText,
    );
  }
}

///? Collection of all custom colors registered in themeData
class ColorsApp {
  const ColorsApp({
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.focusColor,
    required this.disabledColor,
    required this.brightness,
    required this.text,
    required this.label,
    required this.title,
    required this.accent,
    required this.success,
    required this.warning,
  });
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color focusColor;
  final Color disabledColor;
  final Color brightness;
  final Color text;
  final Color label;
  final Color title;
  final Color accent;
  final Color success;
  final Color warning;

  Map<String, dynamic> toJson() => {
        "surface": surface,
        "primary": primary,
        "secondary": secondary,
        "tertiary": tertiary,
        "error": error,
        "focusColor": focusColor,
        "disabledColor": disabledColor,
        "brightness": brightness,
        "text": text,
        "label": label,
        "title": title,
        "accent": accent,
        "success": success,
        "warning": warning,
      };
}

// ? Theme data color extension
@immutable
class ThemeDataColorExtension extends ThemeExtension<ThemeDataColorExtension> {
  const ThemeDataColorExtension({
    this.brightness,
    this.text,
    this.label,
    this.title,
    this.accent,
    this.success,
    this.warning,
  });
  final Color? brightness;
  final Color? text;
  final Color? label;
  final Color? title;
  final Color? accent;
  final Color? success;
  final Color? warning;

  @override
  ThemeDataColorExtension copyWith({
    Color? brightness,
    Color? text,
    Color? label,
    Color? title,
    Color? accent,
    Color? success,
    Color? warning,
  }) {
    return ThemeDataColorExtension(
      brightness: brightness ?? this.brightness,
      text: text ?? this.text,
      label: label ?? this.label,
      title: title ?? this.title,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  ThemeDataColorExtension lerp(ThemeDataColorExtension? other, double t) {
    if (other is! ThemeDataColorExtension) return this;

    return ThemeDataColorExtension(
      brightness: Color.lerp(brightness, other.brightness, t),
      text: Color.lerp(text, other.text, t),
      label: Color.lerp(label, other.label, t),
      title: Color.lerp(title, other.title, t),
      accent: Color.lerp(accent, other.accent, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
    );
  }

  @override
  String toString() =>
      'ThemeDataColorExtension(brightness: $brightness, text: $text, label: $label, title: $title, accent: $accent, success: $success, warning: $warning)';
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
