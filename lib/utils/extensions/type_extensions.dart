import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:csv/csv.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

abstract class DefaultModel<T> {
  Iterable get values;
  T copyWith();
  Map<String, dynamic> toJson();
}

// ? AssetBundle extension
extension AssetBundleExtension on AssetBundle {
  /// Read JSON asset file
  Future<T> readJson<T>(String path) async =>
      jsonDecode(await rootBundle.loadString(path)) as T;
}

// ? Dynamic extension
extension DynamicExtension on dynamic {
  /// Shortcut to convert type of any value
  T as<T>() => this as T;

  /// Getter to know if value is not `null`.
  bool get isExist => this != null;

  /// Getter to know if value is `null`.
  bool get isNotExist => this == null;
}

// ? Bool extension
extension BoolExtension on bool {
  /// Used to invoke function like terniary operation in case recieve `true` expression.
  dynamic inCase(dynamic returnedValue) {
    if (this) {
      return returnedValue is Function ? returnedValue() : returnedValue;
    }
  }

  /// Used to invoke function like terniary operation in case recieve `false` expression.
  dynamic ifNot(dynamic returnedValue) {
    if (!this) {
      return returnedValue is Function ? returnedValue() : returnedValue;
    }
  }
}

// ? DateTime extension
extension DateTimeExtension on DateTime {
  /// Return a string representing [date] formatted according to our locale and internal format.
  String formatTime({
    String? pattern = 'dd/MM/yyyy HH:mm',
    bool toLocal = false,
    String? locale,
  }) =>
      toLocal
          ? DateFormat(pattern, locale).format(this.toLocal())
          : DateFormat(pattern, locale).format(this);
}

// ? File extension
extension FileExtension on io.File {
  String parseToBase64() => base64Encode(readAsBytesSync());
}

// ? Duration extension
extension DurationExtension on Duration {
  String formatToClock({
    bool showHours = true,
    bool showSeconds = true,
    bool militaryTime = false,
  }) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60)),
        twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    int hours = inHours;

    if (!militaryTime && hours > 12) hours = hours - 12;

    return "${showHours ? '${twoDigits(hours)}:' : ''}$twoDigitMinutes${showSeconds ? ':$twoDigitSeconds' : ''}";
  }

  String formatToString({int units = 3, String locale = 'es'}) {
    int years = inDays ~/ 365,
        months = (inDays % 365) ~/ 30,
        days = (inDays % 365) % 30,
        hours = inHours.remainder(24),
        minutes = inMinutes.remainder(60),
        seconds = inSeconds.remainder(60);

    List<String> parts = [];

    // Function to get the name of the unit based on locale
    getUnitName(String unit, int value) => switch (locale) {
          'es' => switch (unit) {
              'year' => value == 1 ? 'año' : 'años',
              'month' => value == 1 ? 'mes' : 'meses',
              'day' => value == 1 ? 'día' : 'días',
              'hour' => 'h',
              'minute' => 'min',
              'second' => 'seg',
              _ => unit,
            },
          String() => switch (unit) {
              'year' => value == 1 ? 'year' : 'years',
              'month' => value == 1 ? 'month' : 'months',
              'day' => value == 1 ? 'day' : 'days',
              'hour' => 'h',
              'minute' => 'min',
              'second' => 'sec',
              _ => unit,
            },
        };

    // Add years
    if (years > 0 && units >= 1) {
      parts.add("$years ${getUnitName('year', years)}");
      units--;
    }

    // Add months
    if (months > 0 && units >= 1) {
      parts.add("$months ${getUnitName('month', months)}");
      units--;
    }

    // Add days
    if (days > 0 && units >= 1) {
      parts.add("$days ${getUnitName('day', days)}");
      units--;
    }

    // Add hours
    if (hours > 0 && units >= 1) {
      parts.add("$hours${getUnitName('hour', hours)}");
      units--;
    }

    // Add minutes
    if (minutes > 0 && units >= 1) {
      parts.add("$minutes${getUnitName('minute', minutes)}");
      units--;
    }

    // Add seconds
    if (seconds > 0 && units >= 1) {
      parts.add("$seconds${getUnitName('second', seconds)}");
    }

    return parts.join(" ");
  }
}

// ? list extension
extension ListExtension<T> on List<T> {
  /// Extension for the List class that allows pagination of list elements.
  ///
  /// This method divides the list into pages of a specified size and returns
  /// a list of lists, where each sublist represents a page.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// List<int> items = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// List<List<int>> pages = items.paginate(3);
  /// // pages = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  /// ```
  ///
  /// @param itemsPerPage The number of items per page.
  /// @return A list of lists, where each sublist contains the items of a page.
  List<List<T>> paginate(int itemsPerPage) {
    List<List<T>> pages = [];

    for (int i = 0; i < length; i += itemsPerPage) {
      int end = (i + itemsPerPage < length) ? i + itemsPerPage : length;
      pages.add(sublist(i, end));
    }

    return pages;
  }

  /// Sorts this list according to the order specified by the [compare] function.
  /// The [compare] `String` value.
  void sortMap(String sortBy, {bool ascending = true}) => sort((a, b) {
        final valueA =
            a is Map ? a[sortBy] : (a as DefaultModel).toJson()[sortBy];
        final valueB =
            b is Map ? b[sortBy] : (b as DefaultModel).toJson()[sortBy];

        return ascending
            ? valueB
                .toString()
                .toLowerCase()
                .compareTo(valueA.toString().toLowerCase())
            : valueA
                .toString()
                .toLowerCase()
                .compareTo(valueB.toString().toLowerCase());
      });

  /// Removes duplicate elements from a list.
  /// Elements are considered duplicates if they have the same property values.
  /// Returns a new list that contains only unique elements, preserving the original order.
  List<T> removeDuplicates() {
    final distinctList = [];
    final uniqueKeys = <String>{};

    for (final item in this) {
      final key = item.toString();

      if (uniqueKeys.contains(key)) continue;

      uniqueKeys.add(key);
      distinctList.add(item);
    }

    return distinctList.cast<T>();
  }

  Future<void> saveAsCsvFile({
    String? dirName,
    String Function(String dir)? message,
    Duration? messageDuration,
  }) async {
    final permission = (await Permission.storage.request()).isGranted;

    if (permission) {
      //store file in documents folder
      String dir =
          "${(await getExternalStorageDirectory())!.path}/${dirName ?? AppName.kedabcase}.csv";
      io.File file = io.File(dir);

      // convert rows to String and write as csv file
      String csv =
          const ListToCsvConverter().convert(this as List<List<dynamic>>);
      await file.writeAsString(csv);

      if (message != null) {
        showSnackbar(
          message(dir),
          type: SnackbarType.success,
          duration: messageDuration,
        );
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      debugPrint("$statuses ⭕");
    }
  }
}

// ? set extension
extension SetExtension<T> on Set<T> {
  /// Sorts this list according to the order specified by the [compare] function.
  /// The [compare] `String` value.
  /// Returns a new sorted Set.
  Set<T> sortedCompare(String sortBy) {
    final sortedList = toList();
    sortedList.sort((a, b) {
      final valueA = a is Map ? a : (a as DefaultModel).toJson();
      final valueB = b is Map ? b : (b as DefaultModel).toJson();

      return (valueA[sortBy] as String)
          .toLowerCase()
          .compareTo((valueB[sortBy] as String).toLowerCase());
    });

    return sortedList.toSet();
  }

  /// Removes duplicate elements from a list.
  /// Elements are considered duplicates if they have the same property values.
  /// Returns a new Set that contains only unique elements, preserving the original order.
  Set<T> removeDuplicates() {
    final distinctList = [];
    final uniqueKeys = <String>{};

    for (final item in this) {
      final key = item.toString();

      if (uniqueKeys.contains(key)) continue;

      uniqueKeys.add(key);
      distinctList.add(item);
    }

    return distinctList.cast<T>().toSet();
  }
}

// ? Nullable Iterable extension
extension NullableIterableExtension on Iterable? {
  /// Getter to know if List is not `null` or is not [Empty].
  bool get hasValue => this?.isNotEmpty ?? false;

  /// Getter to know if List is `null` or is [Empty].
  bool get hasNotValue => this?.isEmpty ?? true;
}

// ? Nullable list extension
extension NullableListExtension on List? {
  /// Getter to know if List is not `null` or is not [Empty].
  bool get hasValue => this?.isNotEmpty ?? false;

  /// Getter to know if List is `null` or is [Empty].
  bool get hasNotValue => this?.isEmpty ?? true;
}

// ? Nullable map extension
extension NullableMapExtension on Map? {
  /// Getter to know if Map is not `null` or is not [Empty].
  bool get hasValue => this?.isNotEmpty ?? false;

  /// Getter to know if Map is `null` or is [Empty].
  bool get hasNotValue => this?.isEmpty ?? true;
}

// ? Int extension
extension IntExtension on int {
  /// Converts a number of bytes into a human-readable string representing the size in B, KB, MB, GB, etc.
  ///
  /// @param bytes The number of bytes to convert.
  /// @param decimals The number of decimal places to include in the result.
  /// @return A string representing the size in B, KB, MB, GB, etc., with the specified number of decimal places.
  ///
  /// Usage example:
  ///   String size = formatBytes(1550, 2); // Returns "1.51 KB"
  String formatBytes({int decimals = 2}) {
    if (this <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (math.log(this) / math.log(1024)).floor();
    return '${(this / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Format `int` to decimal number system with nested currency.
  ///
  /// by default [locale] has deviceLanguage value and 3 decimals max.
  String formatAmount({
    String? name,
    String? symbol,
    String? locale,
    int maxDecimals = Vars.maxDecimals,
    int minimumFractionDigits = Vars.maxDecimals,
    String? customPattern = '#,##0.00 ¤',
    bool compact = false,
  }) {
    late NumberFormat formatter;

    if (compact) {
      formatter = NumberFormat.compactCurrency(
        locale: "en_US",
        name: name ?? "",
        symbol: symbol,
        decimalDigits: 1,
      );

      formatter.minimumFractionDigits = 0;
    } else {
      formatter = NumberFormat.currency(
        locale: locale ?? AppLocale.locale.languageCode,
        name: name ?? "",
        symbol: symbol,
        decimalDigits: maxDecimals,
        customPattern: customPattern,
      );

      formatter.minimumFractionDigits = minimumFractionDigits;
    }

    return formatter.format(this).trim();
  }
}

String formatAmountManually(double value) {
  // Divide el número en partes
  final isNegative = value < 0;
  final absoluteValue = value.abs();
  final intValue = absoluteValue.truncate();
  final decimalValue = (absoluteValue - intValue) *
      100; // Multiplica por 100 para obtener los dos dígitos decimales

  // Agrega las comas de los miles a la parte entera
  final formattedIntValue = intValue
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) {
    return '${match.group(1)},';
  });

  // Une las partes nuevamente
  final formattedAmount =
      '${isNegative ? '-' : ''}$formattedIntValue.${decimalValue.toStringAsFixed(0)}';

  return formattedAmount;
}

// ? Double extension
extension DoubleExtension on double {
  /// Format `double` to decimal number system with nested currency.
  ///
  /// by default [locale] has deviceLanguage value and 3 decimals max.
  String formatAmount({
    String? name,
    String? symbol,
    String? locale,
    int maxDecimals = Vars.maxDecimals,
    int minimumFractionDigits = Vars.maxDecimals,
    String? customPattern = '#,##0.00 ¤',
    bool compact = false,
  }) {
    late NumberFormat formatter;
    late String formattedAmount;

    if (compact) {
      formatter = NumberFormat.compactCurrency(
        locale: "en_US",
        name: name ?? "",
        symbol: symbol,
        decimalDigits: 1,
      );

      formatter.minimumFractionDigits = 0;

      formattedAmount = formatter.format(this).trim();
    } else {
      final localeValue = locale ?? AppLocale.locale.languageCode,
          language = LanguageList.get(localeValue);

      formatter = NumberFormat.currency(
        locale: localeValue,
        name: name ?? "",
        symbol: symbol,
        decimalDigits: maxDecimals,
        customPattern: customPattern,
      );

      formatter.minimumFractionDigits = minimumFractionDigits;

      formattedAmount = formatter.format(this).trim();

      // prevent round numbers
      if (maxDecimals >= minimumFractionDigits) {
        final withoutThousands = formattedAmount
            .replaceAll(language.thousandsSeparator, '')
            .replaceAll(',', '.');

        final amountWithoutThousands =
            withoutThousands.replaceAllMapped(RegExp(r'\d+(\.\d+)?'), (match) {
          var value = this.maxDecimals(maxDecimals).toString();
          if (kIsWeb && this is int) value = toStringAsFixed(1);

          final resultSplitted = value.split('.'),
              multiplier =
                  minimumFractionDigits - resultSplitted.elementAt(1).length;

          final result =
                  "${resultSplitted.join(language.decimalSeparator)}${'0' * multiplier}",
              splittedResult = result.split(language.decimalSeparator);

          if (minimumFractionDigits == 0 &&
              splittedResult.elementAt(1) == '0') {
            return splittedResult.elementAt(0);
          }

          return result;
        });

        formattedAmount = amountWithoutThousands.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)}${language.thousandsSeparator}',
        );
      }
    }

    return formattedAmount;
  }

  /// Used to limit decimal characters in `double`
  double maxDecimals([int max = Vars.maxDecimals]) {
    final splitted = toString().split("."),
        decimalsFiltered = splitted.last.substring(
            0, splitted.last.length > max ? max : splitted.last.length);
    splitted.removeLast();
    splitted.add(decimalsFiltered);
    return double.parse(splitted.join("."));
  }
}

// ? Nullable Color extension
extension NullableColorExtension on Color? {
  /// Turn current [Color] value to Hexadecimal.
  String? toHexadecimal() => this != null ? toString() : null;
}

// ? Nullable string extension
extension NullableStringExtension on String? {
  /// Getter to know if String is not `null` or is not [Empty].
  bool get hasValue => this?.isNotEmpty ?? false;

  /// Getter to know if String is `null` or is [Empty].
  bool get hasNotValue => this?.isEmpty ?? true;

  /// Getter to check if `string` contains `http` inside.
  bool get hasNetworkPath => this?.contains("http") ?? false;

  String removeQuery() => this?.split('?')[0] ?? '';

  /// Turn current Hexadecimal value to [Color].
  Color? hexadecimalToColor() =>
      this != null ? Color(this!.replaceFirst('#', '0xff').toInt()) : null;
}

// ? String extension
extension StringExtension on String {
  // returns bool to know if string is html
  bool isHtml() => RegExp(r'<[^>]+>').hasMatch(this);

  // returns current string obfuscated
  String obfuscateText({
    bool email = false,
    int? characters,
    bool reverse = false,
  }) {
    if (email) {
      var parts = split('@');
      if (parts.length != 2) return this;

      var name = parts[0].length > 4 ? parts[0].substring(0, 4) : parts[0];
      var domain = parts[1].length > 3 ? parts[1].substring(0, 3) : parts[1];
      var obscuredName = name + '*' * (parts[0].length - 4);
      var obscuredDomain = domain + '*' * (parts[1].length - 3);
      return '$obscuredName@$obscuredDomain';
    }

    if (characters != null && characters < length) {
      if (reverse) {
        return "*" * (length - characters) + substring(length - characters);
      } else {
        return substring(0, characters) + "*" * (length - characters);
      }
    }

    return "*" * length;
  }

  /// Return a string representing [date] formatted according to our locale and internal format.
  String formatTime({
    String? pattern = 'dd/MM/yyyy HH:mm',
    bool toLocal = false,
    String? locale,
  }) =>
      DateTime.parse(this).formatTime(
        locale: locale,
        pattern: pattern,
        toLocal: toLocal,
      );

  /// Limit characters length to value provided.
  ///
  /// in case the current string is not long enough, an unmutated value will
  /// be returned
  String limitChatacters(int value) =>
      length >= value ? "${substring(0, value)}..." : this;

  /// Constructs a new [DateTime] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The accepted inputs are currently:
  ///
  /// * A date: A signed four-to-six digit year, two digit month and
  ///   two digit day, optionally separated by `-` characters.
  ///   Examples: "19700101", "-0004-12-24", "81030-04-01".
  /// * An optional time part, separated from the date by either `T` or a space.
  ///   The time part is a two digit hour,
  ///   then optionally a two digit minutes value,
  ///   then optionally a two digit seconds value, and
  ///   then optionally a '.' or ',' followed by at least a one digit
  ///   second fraction.
  ///   The minutes and seconds may be separated from the previous parts by a
  ///   ':'.
  ///   Examples: "12", "12:30:24.124", "12:30:24,124", "123010.50".
  /// * An optional time-zone offset part,
  ///   possibly separated from the previous by a space.
  ///   The time zone is either 'z' or 'Z', or it is a signed two digit hour
  ///   part and an optional two digit minute part. The sign must be either
  ///   "+" or "-", and cannot be omitted.
  ///   The minutes may be separated from the hours by a ':'.
  ///   Examples: "Z", "-10", "+01:30", "+1130".
  ///
  /// This includes the output of both [toString] and [toIso8601String], which
  /// will be parsed back into a `DateTime` object with the same time as the
  /// original.
  ///
  /// The result is always in either local time or UTC.
  /// If a time zone offset other than UTC is specified,
  /// the time is converted to the equivalent UTC time.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789z"`
  /// * `"2012-02-27 13:27:00,123456789z"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  ///
  /// This method accepts out-of-range component values and interprets
  /// them as overflows into the next larger component.
  /// For example, "2020-01-42" will be parsed as 2020-02-11, because
  /// the last valid date in that month is 2020-01-31, so 42 days is
  /// interpreted as 31 days of that month plus 11 days into the next month.
  ///
  /// To detect and reject invalid component values, use
  /// [DateFormat.parseStrict](https://pub.dev/documentation/intl/latest/intl/DateFormat/parseStrict.html)
  /// from the [intl](https://pub.dev/packages/intl) package.
  DateTime toDateTime() => DateTime.parse(this);

  /// Creates a [File] object from a raw path.
  ///
  /// A raw path is a sequence of bytes, as paths are represented by the OS.
  io.File toFileFromBase64() => io.File.fromRawPath(base64Decode(this));

  /// Parse [source] as a, possibly signed, integer literal.
  ///
  /// Like [parse] except that this function returns `null` where a
  /// similar call to [parse] would throw a [FormatException].
  ///
  /// Example:
  /// ```dart
  /// print('2021'.toInt()); // 2021
  /// print('1f'.toInt()); // fallback ?? 0
  /// ```
  int toInt({int? fallback}) => int.tryParse(this) ?? fallback ?? 0;

  /// Parse [source] as a double literal and return its value.
  ///
  /// Like [parse], except that this function returns `null` for invalid inputs
  /// instead of throwing.
  ///
  /// Example:
  /// ```dart
  /// var value = '3.14'.toDouble(); // 3.14
  /// value = '  3.14 \xA0'.toDouble(); // 3.14
  /// value = '0xFF'.toDouble(); // fallback ?? 0.0
  /// ```
  double toDouble({int? withMaxDecimals, double? fallback}) {
    final value = double.tryParse(commasToDot()) ?? fallback ?? 0.0;

    return withMaxDecimals != null ? value.maxDecimals(withMaxDecimals) : value;
  }

  /// Format `string` to decimal number system with nested currency.
  ///
  /// by default [locale] has deviceLanguage value and 3 decimals max.
  String formatAmount({
    String? name,
    String? symbol,
    String? locale,
    int maxDecimals = Vars.maxDecimals,
    int minimumFractionDigits = Vars.maxDecimals,
    String? customPattern = '#,##0.00 ¤',
    bool compact = false,
  }) {
    late NumberFormat formatter;
    late String formattedAmount;

    if (compact) {
      formatter = NumberFormat.compactCurrency(
        locale: "en_US",
        name: name ?? "",
        symbol: symbol,
        decimalDigits: 1,
      );

      formatter.minimumFractionDigits = 0;

      formattedAmount = formatter.format(toDouble()).trim();
    } else {
      final localeValue = locale ?? AppLocale.locale.languageCode,
          language = LanguageList.get(localeValue);

      formatter = NumberFormat.currency(
        locale: localeValue,
        name: name ?? "",
        symbol: symbol,
        decimalDigits: maxDecimals,
        customPattern: customPattern,
      );

      formatter.minimumFractionDigits = minimumFractionDigits;

      formattedAmount = formatter.format(toDouble()).trim();

      // prevent round numbers
      if (maxDecimals >= minimumFractionDigits) {
        final withoutThousands = formattedAmount
            .replaceAll(language.thousandsSeparator, '')
            .replaceAll(',', '.');

        final amountWithoutThousands =
            withoutThousands.replaceAllMapped(RegExp(r'\d+(\.\d+)?'), (match) {
          var value = toDouble().maxDecimals(maxDecimals).toString();
          if (kIsWeb && value.toDouble() is int) {
            value = value.toDouble().toStringAsFixed(1);
          }

          final resultSplitted = value.split('.'),
              multiplier =
                  minimumFractionDigits - resultSplitted.elementAt(1).length;

          final result =
                  "${resultSplitted.join(language.decimalSeparator)}${'0' * multiplier}",
              splittedResult = result.split(language.decimalSeparator);

          if (minimumFractionDigits == 0 &&
              splittedResult.elementAt(1) == '0') {
            return splittedResult.elementAt(0);
          }

          return result;
        });

        formattedAmount = amountWithoutThousands.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)}${language.thousandsSeparator}',
        );
      }
    }

    return formattedAmount;
  }

  // This function "unformats" a currency amount string.
  double unformatAmount([String? locale]) {
    final language = LanguageList.get(locale ?? AppLocale.locale.languageCode);

    // Remove the currency symbol and compact notation (like 'K', 'M', etc.)
    //
    // Later replace the thousand and decimal separators to get simple value.
    String value = replaceAll(RegExp(r'[^\d.,]'), "")
        .replaceAll(language.thousandsSeparator, "")
        .replaceAll(language.decimalSeparator, ".");

    // Parse the string as a double. If parsing fails, return 0.0.
    return double.tryParse(value) ?? 0.0;
  }

  /// Converts first character from `string` in uppercase.
  String toCapitalize() {
    try {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    } catch (error) {
      return "";
    }
  }

  /// Converts all characters from `string` separated by space in uppercase.
  String toCapitalizeEachFirstWord() =>
      split(" ").map((str) => str.toCapitalize()).join(" ");

  /// Copy text from `string` to clipboard.
  void copyToClipboard({
    String? message,
    Duration? messageDuration = const Duration(seconds: 3),
  }) {
    Clipboard.setData(ClipboardData(text: this))
        .then((value) => message != null
            ? showSnackbar(message,
                type: SnackbarType.info, duration: messageDuration)
            : null)
        .catchError((onError) => debugPrint("${onError.toString()} ⭕"));
  }

  /// Converts all commas inside `string` to dots
  ///
  /// if has multiple commas will be removes and just stay the first.
  String commasToDot() {
    if (!contains(",")) return this;

    final splitted = split(",");

    if (splitted.length > 2) {
      final intire = splitted.first;
      splitted.removeWhere((element) => element.isEmpty || element == intire);
      return "$intire,${splitted.join("")}";
    } else {
      return splitted.join(".");
    }
  }

  /// Converts all dots inside `string` to commas.
  ///
  /// if has multiple dots will be removes and just stay the first.
  String dotsToComma() {
    if (!contains(".")) return this;

    final splitted = split(".");

    if (splitted.length > 2) {
      final intire = splitted.first;
      splitted.removeWhere((element) => element.isEmpty || element == intire);
      return "$intire.${splitted.join("")}";
    } else {
      return splitted.join(",");
    }
  }
}

// ? Unused
// ? Uri extension
// extension UriExtension on Uri {
//   /// Getter to path value without mutations
//   String get originalPath {
//     if (hasScheme) {
//       return "/${pathSegments.join("/").split(origin)[0]}";
//     }
//     return pathSegments.join("/");
//   }

//   /// Add Custom network base url path to uri.
//   Uri addNetworkPath(String netWorkPath) {
//     if (!hasScheme) {
//       return Uri.parse("$netWorkPath$originalPath");
//     }
//     debugPrint("$this - already has scheme ⭕");
//     return this;
//   }

//   /// Remove Custom network base url path to uri.
//   Uri removeNetworkPath() {
//     if (hasScheme) {
//       return Uri.parse(originalPath);
//     }
//     debugPrint("$this - haven't scheme ⭕");
//     return this;
//   }
// }

// ? Screenshot extension
extension ScreenshotExtension on ScreenshotController {
  Future<void> captureAndSaveAuto({
    String? message,
    Duration? messageDuration,
  }) async {
    Uint8List? imageBytes = await capture(pixelRatio: 1.5);

    final io.Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String imagePath = '$path/screenshot${DateTime.now()}.png';
    final io.File file = io.File(imagePath);
    await file.writeAsBytes(imageBytes!, mode: io.FileMode.write);
    await GallerySaver.saveImage(file.path);

    if (message != null) {
      showSnackbar(
        message,
        type: SnackbarType.success,
        duration: messageDuration,
      );
    }
  }

  Future<void> shareCapture({double pixelRatio = 1.5}) async {
    Uint8List? imageBytes = await capture(pixelRatio: pixelRatio);

    final io.Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String imagePath = '$path/screenshot${DateTime.now()}.png';
    final io.File file = io.File(imagePath);
    await file.writeAsBytes(imageBytes!, mode: io.FileMode.write);
    Share.shareXFiles([XFile(file.path)]);
  }
}

// ? TextEditingValue extension
extension TextEditingValueExtension on TextEditingValue {
  String unformat() {
    final value = text.replaceAll(RegExp(r'[^\d.,]'), "");
    return value.split(',').join('.');
  }
}

// ? MultipartFile extension
extension MultipartFileExtension on dio.MultipartFile {
  Map<String, dynamic> toJson() => {
        "contentType": contentType.toString(),
        "filename": filename,
        "length": length,
      };
}

// ? Key extension
extension KeyExtension on Key? {
  String? get value {
    if (this == null) return null;

    String? keyValue = this!.toString();

    return keyValue.substring(
      keyValue.indexOf("'") + 1,
      keyValue.lastIndexOf("'"),
    );
  }
}

// ? ExceptionHandler extension
extension ExceptionHandler on Object {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custom default message.
  String catchErrorMessage({String? fallback}) {
    String responseMessage = '';
    dynamic type;
    String? statusCode;
    dynamic error;
    String? url;

    if (this is String) return this as String;

    if (this is Exception) {
      final exception = this as Exception;

      responseMessage = exception.toString();
    }

    if (this is dio.DioException) {
      final exception = this as dio.DioException;

      type = exception.type;
      statusCode = exception.response?.statusCode.toString();
      error = exception.message;
      url = exception.response?.realUri.toString();
      responseMessage = exception.response?.data is Map<String, dynamic>
          ? exception.response!.data!['message']?.toString() ??
              exception.response!.data!['error']?.toString() ??
              exception.response!.data!['data']?.toString() ??
              ''
          : exception.response?.data?.toString() ?? '';
    }

    if (this is io.HttpException) {
      final exception = this as io.HttpException;

      responseMessage = exception.message;
      url = exception.uri.toString();
    }

    ///! uncomment if use [firebase-core] package
    // if (this is FirebaseException) {
    //   final exception = this as FirebaseException;

    //   statusCode = exception.code;
    //   url = exception.plugin;
    //   error = exception.stackTrace;
    //   responseMessage = exception.message ?? '';
    // }

    if (this is io.SocketException) {
      final exception = this as io.SocketException;

      type = /* exception.address?.type ??  */
          dio.DioExceptionType.connectionError;
      statusCode = exception.osError?.errorCode.toString();
      error = exception.osError?.message;
      url = exception.address?.address;
      responseMessage = exception.message;
    }

    if (this is PlatformException) {
      final exception = this as PlatformException;

      statusCode = exception.code;
      error = exception.details;
      responseMessage = exception.message ?? '';
    }

    //* catch connection failed
    if (type case dio.DioExceptionType.connectionError) {
      return "Oops, it seems that a connection error occurred! Please try again later.";
    }

    //* catch unauthorized request
    if (statusCode == "401") {
      return "Your session has expired. Please log in again.";
    }

    debugPrint(
      "⭕ exceptionType: $type ⭕\n⭕ statusCode: $statusCode ⭕\n⭕ error: $error ⭕\n⭕ url: $url ⭕",
    );

    fallback ??= "${statusCode ?? 'Error'}: Ha ocurrido un error inesperado";
    if (responseMessage.isHtml()) return fallback;
    return responseMessage.isNotEmpty ? responseMessage : fallback;
  }

  /// Will return the `error StatusCode` from the request.
  String? catchErrorStatusCode() {
    String? statusCode;

    if (this is dio.DioException) {
      final exception = this as dio.DioException;

      statusCode = exception.response?.statusCode.toString();
    }

    ///! uncomment if use [firebase-core] package
    // if (this is FirebaseException) {
    //   final exception = this as FirebaseException;

    //   statusCode = exception.code;
    // }

    if (this is io.SocketException) {
      final exception = this as io.SocketException;

      statusCode = exception.osError?.errorCode.toString();
    }

    if (this is PlatformException) {
      final exception = this as PlatformException;

      statusCode = exception.code;
    }

    return statusCode;
  }
}
