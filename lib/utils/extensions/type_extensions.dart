import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:csv/csv.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/services/local_data/env_service.dart';
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
  String formatToClock({bool showSeconds = true, bool militaryTime = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60)),
        twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    int hours = inHours;

    if (!militaryTime && hours > 12) hours = hours - 12;

    return "${twoDigits(hours)}:$twoDigitMinutes${showSeconds ? ':$twoDigitSeconds' : ''}";
  }

  String formatToString() {
    int minutes = inMinutes.remainder(60), seconds = inSeconds.remainder(60);

    // ? seconds
    if (inHours == 0 && inMinutes == 0) {
      return "${seconds}seg";
      // ? minutes
    } else if (inHours == 0) {
      return "${minutes}min ${seconds == 0 ? '' : '${seconds}seg'}";
    }
    // ? hours
    return "${inHours}h ${minutes == 0 ? '' : '${minutes}min'} ${seconds == 0 ? '' : '${seconds}seg'}";
  }
}

// ? list extension
extension ListExtension<T> on List<T> {
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
      debugPrint("$csv ⭐");

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

  /// Format `String` to decimal number system with nested currency.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String formatAmount({
    String? name,
    String? symbol,
    String? locale = 'en_US',
    int maxDecimals = 3,
    int minimumFractionDigits = 3,
    String? customPattern = '#,##0.00 ¤',
    bool useUnitFormat = false,
  }) {
    // Parse the string as a double. If parsing fails, use 0.0.
    double value = double.tryParse(toString().replaceAll(",", "")) ?? 0.0;

    // If unit formatting is enabled...
    if (useUnitFormat) {
      maxDecimals = 1;
      minimumFractionDigits = 0;
      String unit = '';

      if (value >= 1000000000) {
        unit = 'b';
        value /= 1000000000;
      } else if (value >= 1000000) {
        unit = 'm';
        value /= 1000000;
      } else if (value >= 1000) {
        unit = 'k';
        value /= 1000;
      }

      customPattern = customPattern!.replaceAllMapped(
          RegExp(r'0\.0'), (match) => '0.${"0" * maxDecimals}$unit');
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      name: name ?? "",
      symbol: symbol,
      decimalDigits: maxDecimals,
      customPattern: customPattern,
    );
    formatter.minimumFractionDigits = minimumFractionDigits;
    return formatter.format(value).trim();
  }

  // This function "unformats" a currency amount string.
  double unformatAmount() {
    var amount = toString();

    // Remove the currency symbol and trim whitespace.
    amount = amount.replaceAll(RegExp(r'[^\d.,kmb]'), '').trim();

    String unit = amount[amount.length - 1];
    // Remove the unit from the string.
    amount = amount.substring(0, amount.length - 1);

    // Parse the string as a double. If parsing fails, return 0.0.
    double value = double.tryParse(amount.replaceAll(",", ".")) ?? 0.0;

    switch (unit) {
      case 'k':
        value *= 1000;
        break;
      case 'm':
        value *= 1000000;
        break;
      case 'b':
        value *= 1000000000;
        break;
    }

    return value;
  }
}

// ? Double extension
extension DoubleExtension on double {
  // Map the value from one range to another
  double clampMapRanged({
    bool invert = false,
    required double fromMin,
    required double fromMax,
    required double toMin,
    required double toMax,
  }) {
    double mappedValue =
        ((this - fromMin) / (fromMax - fromMin)) * (toMax - toMin) + toMin;

    // Make sure the mapped value is within the toMin and toMax ranges
    mappedValue = mappedValue.clamp(toMin, toMax);

    // Inverts return values if invert is specified as true
    return invert ? toMax + toMin - mappedValue : mappedValue;
  }

  /// Format `String` to decimal number system with nested currency.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String formatAmount({
    String? name,
    String? symbol,
    String? locale = 'en_US',
    int maxDecimals = 3,
    int minimumFractionDigits = 3,
    String? customPattern = '#,##0.00 ¤',
    bool useUnitFormat = false,
  }) {
    // Parse the string as a double. If parsing fails, use 0.0.
    double value = double.tryParse(toString().replaceAll(",", "")) ?? 0.0;

    // If unit formatting is enabled...
    if (useUnitFormat) {
      maxDecimals = 1;
      minimumFractionDigits = 0;
      String unit = '';

      if (value >= 1000000000) {
        unit = 'b';
        value /= 1000000000;
      } else if (value >= 1000000) {
        unit = 'm';
        value /= 1000000;
      } else if (value >= 1000) {
        unit = 'k';
        value /= 1000;
      }

      customPattern = customPattern!.replaceAllMapped(
          RegExp(r'0\.0'), (match) => '0.${"0" * maxDecimals}$unit');
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      name: name ?? "",
      symbol: symbol,
      decimalDigits: maxDecimals,
      customPattern: customPattern,
    );
    formatter.minimumFractionDigits = minimumFractionDigits;
    return formatter.format(value).trim();
  }

  // This function "unformats" a currency amount string.
  double unformatAmount() {
    var amount = toString();

    // Remove the currency symbol and trim whitespace.
    amount = amount.replaceAll(RegExp(r'[^\d.,kmb]'), '').trim();

    String unit = amount[amount.length - 1];
    // Remove the unit from the string.
    amount = amount.substring(0, amount.length - 1);

    // Parse the string as a double. If parsing fails, return 0.0.
    double value = double.tryParse(amount.replaceAll(",", ".")) ?? 0.0;

    switch (unit) {
      case 'k':
        value *= 1000;
        break;
      case 'm':
        value *= 1000000;
        break;
      case 'b':
        value *= 1000000000;
        break;
    }

    return value;
  }

  /// Used to limit decimal characters in `double`
  double maxDecimals(int max) {
    final splitted = toString().split("."),
        decimalsFiltered = splitted.last.substring(
            0, splitted.last.length > max ? max : splitted.last.length);
    splitted.removeLast();
    splitted.add(decimalsFiltered);
    return double.parse(splitted.join("."));
  }
}

// ? Nullable string extension
extension NullableStringExtension on String? {
  /// Getter to know if String is not `null` or is not [Empty].
  bool get hasValue => this?.isNotEmpty ?? false;

  /// Getter to know if String is `null` or is [Empty].
  bool get hasNotValue => this?.isEmpty ?? true;

  /// Getter to check if `string` contains `http` inside.
  bool get hasNetworkPath => this?.contains("http") ?? false;

  String splitUrlFile(String by) => this?.split("?")[0] ?? "";

  /// Add Custom network base url path to `string`.
  ///
  /// normally must to end without slash `/`.
  String? addNetworkPath({String? path}) {
    if (this == null) return null;
    if (hasNetworkPath) {
      debugPrint("$this - already has scheme ⭕");
      return this;
    }

    return "${path ?? env.fileApiUrl}$this";
  }

  /// Remove Custom network base url path to `string`.
  ///
  /// normally must to end without slash [/].
  String? removeNetworkPath({String? path}) {
    if (this == null) return null;
    if (hasNetworkPath) {
      debugPrint("$this - haven't scheme ⭕");
      return this;
    }

    return this!.split(path ?? env.fileApiUrl)[1];
  }
}

// ? String extension
extension StringExtension on String {
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
  double toDouble({double? fallback}) =>
      double.tryParse(commasToDot()) ?? fallback ?? 0.0;

  /// Format `String` to decimal number system with nested currency.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String formatAmount({
    String? name,
    String? symbol,
    String? locale = 'en_US',
    int maxDecimals = 3,
    int minimumFractionDigits = 3,
    String? customPattern = '#,##0.00 ¤',
    bool useUnitFormat = false,
  }) {
    // Parse the string as a double. If parsing fails, use 0.0.
    double value = double.tryParse(replaceAll(",", "")) ?? 0.0;

    // If unit formatting is enabled...
    if (useUnitFormat) {
      maxDecimals = 1;
      minimumFractionDigits = 0;
      String unit = '';

      if (value >= 1000000000) {
        unit = 'b';
        value /= 1000000000;
      } else if (value >= 1000000) {
        unit = 'm';
        value /= 1000000;
      } else if (value >= 1000) {
        unit = 'k';
        value /= 1000;
      }

      customPattern = customPattern!.replaceAllMapped(
          RegExp(r'0\.0'), (match) => '0.${"0" * maxDecimals}$unit');
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      name: name ?? "",
      symbol: symbol,
      decimalDigits: maxDecimals,
      customPattern: customPattern,
    );
    formatter.minimumFractionDigits = minimumFractionDigits;
    return formatter.format(value).trim();
  }

  // This function "unformats" a currency amount string.
  double unformatAmount() {
    var amount = this;

    // Remove the currency symbol and trim whitespace.
    amount = amount.replaceAll(RegExp(r'[^\d.,kmb]'), '').trim();

    String unit = amount[amount.length - 1];
    // Remove the unit from the string.
    amount = amount.substring(0, amount.length - 1);

    // Parse the string as a double. If parsing fails, return 0.0.
    double value = double.tryParse(amount.replaceAll(",", ".")) ?? 0.0;

    switch (unit) {
      case 'k':
        value *= 1000;
        break;
      case 'm':
        value *= 1000000;
        break;
      case 'b':
        value *= 1000000000;
        break;
    }

    return value;
  }

  /// Used to limit decimal characters in `double`
  String maxDecimals(int max, {String locale = 'en_US'}) {
    final splitted =
            toString().split(LanguageList.get(locale).decimalSeparator),
        decimalsFiltered = splitted.last.substring(
            0, splitted.last.length > max ? max : splitted.last.length);
    splitted.removeLast();
    splitted.add(decimalsFiltered);
    return splitted.join(LanguageList.get(locale).decimalSeparator);
  }

  /// Converts first character from `string` in uppercase.
  String toCapitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

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
  /// and vice versa
  ///
  /// if has multiple commas / dots will be removes and just stay the first.
  String invertDecimal({String? locale = 'en_US'}) {
    final decimalSeparator = LanguageList.get(locale).decimalSeparator;
    return split(decimalSeparator).join(decimalSeparator == ',' ? '.' : ',');
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

// ? screenshot extension
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
    debugPrint(
        'Image saved to: $imagePath (size: ${file.lengthSync()} bytes) ${file.path} ⭐');
    await GallerySaver.saveImage(file.path);

    if (message != null) {
      showSnackbar(
        message,
        type: SnackbarType.success,
        duration: messageDuration,
      );
    }
  }

  Future<void> shareCapture() async {
    Uint8List? imageBytes = await capture(pixelRatio: 1.5);

    final io.Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String imagePath = '$path/screenshot${DateTime.now()}.png';
    final io.File file = io.File(imagePath);
    await file.writeAsBytes(imageBytes!, mode: io.FileMode.write);
    debugPrint(
        'Image saved to: $imagePath (size: ${file.lengthSync()} bytes) ${file.path} ⭐');
    Share.shareXFiles([XFile(file.path)]);
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
