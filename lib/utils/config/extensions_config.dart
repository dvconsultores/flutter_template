import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/global_models/files_type.dart';
import 'package:flutter_detextre4/utils/config/fetch_config.dart';
import 'package:flutter_detextre4/utils/general/global_functions.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
  /// Parse to `String` with conventional date format.
  String toDateString({
    String separator = '/',
    bool spaced = false,
    String? locale,
  }) {
    final divider = spaced ? ' $separator ' : separator;

    if (locale?.contains("es") ?? false) {
      return '${day.toString().padLeft(2, '0')}$divider${month.toString().padLeft(2, '0')}$divider$year';
    }
    return '${year.toString().padLeft(2, '0')}$divider${month.toString().padLeft(2, '0')}$divider$day';
  }
}

// ? File extension
extension FileExtension on File {
  String parseToBase64() => base64Encode(readAsBytesSync());
}

// ? Duration extension
extension DurationExtension on Duration {
  String toStringShort() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String toStringSimple() {
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

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
            ? valueA
                .toString()
                .toLowerCase()
                .compareTo(valueB.toString().toLowerCase())
            : valueB
                .toString()
                .toLowerCase()
                .compareTo(valueA.toString().toLowerCase());
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
  /// Format `int` to decimal number system with nested currency.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String amountFormatterCurrency({
    String? name,
    String? symbol,
    String? locale,
    String? customPattern,
  }) =>
      NumberFormat.currency(
        locale: locale,
        name: name ?? "",
        symbol: symbol,
        decimalDigits: 0,
        customPattern: customPattern,
      ).format(this).trim();

  /// Format `int` to decimal number system.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String amountFormatter({String? locale}) =>
      NumberFormat('#,##0', locale).format(this);
}

// ? Double extension
extension DoubleExtension on double {
  /// Format `double` to decimal number system with nested currency.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String amountFormatterCurrency({
    String? name,
    String? symbol,
    String? locale,
    int? maxDecimals,
    String? customPattern,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      name: name ?? "",
      symbol: symbol,
      decimalDigits: maxDecimals,
      customPattern: customPattern,
    );
    formatter.minimumFractionDigits = 0;
    return formatter
        .format(double.tryParse(toString().replaceAll(",", "")) ?? 0.0)
        .trim();
  }

  /// Format `double` to decimal number system.
  ///
  /// by default `locale` has `'en_US'` value and 2 decimals max.
  String amountFormatter({
    int maxDecimals = 2,
    String? locale,
    bool onlyDecimals = false,
  }) =>
      NumberFormat(
              '${onlyDecimals ? "" : "#,##"}0.${"#" * maxDecimals}', locale)
          .format(double.tryParse(toString().replaceAll(",", "")) ?? 0.0);

  /// Format `double` to decimal number system with filling in with zeros.
  ///
  /// by default `locale` has `'en_US'` value and 2 decimals max.
  String amountFormatterWithFilledIn({
    int maxDecimals = 2,
    String? locale,
    bool onlyDecimals = false,
  }) {
    final formattedAmount = amountFormatter(
      maxDecimals: maxDecimals,
      locale: locale,
      onlyDecimals: onlyDecimals,
    );
    final dotOrComma = locale == null ? "." : ",";
    final amountSplitted = formattedAmount.split(dotOrComma);

    if (amountSplitted.length == 1 || amountSplitted.last.isEmpty) {
      return "${amountSplitted.first}${maxDecimals > 0 ? dotOrComma + '0' * maxDecimals : ''}";
    }

    return amountSplitted.last.length < maxDecimals
        ? "$formattedAmount${'0' * (maxDecimals - amountSplitted.last.length)}"
        : formattedAmount;
  }

  /// Used to limit decimal characters in `double`
  double maxDecimals(int max) {
    final splitted = toString().split(".");
    final decimalsFiltered = splitted.last
        .substring(0, splitted.last.length > max ? max : splitted.last.length);
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
}

// ? String extension
extension StringExtension on String {
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
  File toFileFromBase64() => File.fromRawPath(base64Decode(this));

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

  /// Get amount without currency.
  String getAmountWithoutCurrency(String? currency, {String? locale}) {
    final value = currency.isExist
        ? split(currency!)
                .singleWhereOrNull((element) => element.isNotEmpty)
                ?.trim() ??
            this
        : this;

    if (locale?.contains("es") ?? false) {
      return value.split(".").join("").split(",").join(".");
    }

    return value.split(",").join("");
  }

  /// Format `String` to decimal number system with nested currency.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String amountFormatterCurrency({
    String? name,
    String? symbol,
    String? locale,
    int? maxDecimals,
    String? customPattern,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      name: name ?? "",
      symbol: symbol,
      decimalDigits: maxDecimals,
      customPattern: customPattern,
    );
    formatter.minimumFractionDigits = 0;
    return formatter.format(double.tryParse(replaceAll(",", "")) ?? 0.0).trim();
  }

  /// Format `String` to decimal number system.
  ///
  /// by default `locale` has `'en_US'` value and 2 decimals max.
  String amountFormatter({
    int maxDecimals = 2,
    String? locale,
    bool onlyDecimals = false,
  }) =>
      NumberFormat(
              '${onlyDecimals ? "" : "#,##"}0.${"#" * maxDecimals}', locale)
          .format(double.tryParse(replaceAll(",", "")) ?? 0.0);

  /// Format `String` to decimal number system with filling in with zeros.
  ///
  /// by default `locale` has `'en_US'` value and 2 decimals max.
  String amountFormatterWithFilledIn({
    int maxDecimals = 2,
    String? locale,
    bool onlyDecimals = false,
  }) {
    final formattedAmount = amountFormatter(
      maxDecimals: maxDecimals,
      locale: locale,
      onlyDecimals: onlyDecimals,
    );
    final dotOrComma = locale == null ? "." : ",";
    final amountSplitted = formattedAmount.split(dotOrComma);

    if (amountSplitted.length == 1 || amountSplitted.last.isEmpty) {
      return "${amountSplitted.first}${maxDecimals > 0 ? dotOrComma + '0' * maxDecimals : ''}";
    }

    return amountSplitted.last.length < maxDecimals
        ? "$formattedAmount${'0' * (maxDecimals - amountSplitted.last.length)}"
        : formattedAmount;
  }

  /// Used to limit decimal characters in `double`
  String maxDecimals(int max) {
    final splitted = toString().split(".");
    final decimalsFiltered = splitted.last
        .substring(0, splitted.last.length > max ? max : splitted.last.length);
    splitted.removeLast();
    splitted.add(decimalsFiltered);
    return splitted.join(".");
  }

  /// Converts first character from `string` in uppercase.
  String toCapitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  /// Converts all characters from `string` separated by space in uppercase.
  String toCapitalizeEachFirstWord() =>
      split(" ").map((str) => str.toCapitalize()).join(" ");

  /// Copy text from `string` to clipboard.
  void copyToClipboard({String? message, Duration? duration}) {
    Clipboard.setData(ClipboardData(text: this))
        .then((value) => message.isExist
            ? showSnackbar(message!,
                type: ColorSnackbarState.success, duration: duration)
            : null)
        .catchError((onError) => showSnackbar(onError,
            type: ColorSnackbarState.error, duration: duration));
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

  /// Getter to check if `string` contains `http` inside.
  bool get hasNetworkPath => contains("http");

  /// Add Custom network base url path to `string`.
  ///
  /// normally must to end without slash `/`.
  String addNetworkPath({String? path}) {
    if (hasNetworkPath) {
      debugPrint("$this - already has scheme ⭕");
      return this;
    }

    return "${path ?? FetchConfig.fileBaseUrl}$this";
  }

  /// Remove Custom network base url path to `string`.
  ///
  /// normally must to end without slash [/].
  String removeNetworkPath({String? path}) {
    if (hasNetworkPath) {
      debugPrint("$this - haven't scheme ⭕");
      return this;
    }

    return split(path ?? FetchConfig.fileBaseUrl)[1];
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
  Future<void> captureAndSaveAuto({String? message}) async {
    Uint8List? imageBytes = await capture(pixelRatio: 1.5);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String imagePath = '$path/screenshot${DateTime.now()}.png';
    final File file = File(imagePath);
    await file.writeAsBytes(imageBytes!, mode: FileMode.write);
    dev.log(
        'Image saved to: $imagePath (size: ${file.lengthSync()} bytes) ${file.path} ⭐');
    await GallerySaver.saveImage(file.path);

    showSnackbar(message ?? "Capture saved on gallery");
  }

  Future<void> shareCapture() async {
    Uint8List? imageBytes = await capture(pixelRatio: 1.5);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String imagePath = '$path/screenshot${DateTime.now()}.png';
    final File file = File(imagePath);
    await file.writeAsBytes(imageBytes!, mode: FileMode.write);
    dev.log(
        'Image saved to: $imagePath (size: ${file.lengthSync()} bytes) ${file.path} ⭐');
    Share.shareXFiles([XFile(file.path)]);
  }
}

// ? response extension
extension ResponseExtension on http.Response {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custome default message.
  String catchErrorMessage({
    String searchBy = '"message":',
    String fallback = 'Error',
  }) {
    dev.log("$statusCode ⭕");
    dev.log("$body ⭕");

    return body.contains(searchBy)
        ? jsonDecode(body)[searchBy]
        : body != ""
            ? body
            : fallback;
  }
}

// ? Multipart request extension
extension MultipartRequestExtension on http.MultipartRequest {
  /// Adds all key/value pairs of `fieldsIncomming` to this map and will be
  /// transformer to string.
  ///
  /// If a key of `fieldsIncomming` is already in this map, its value is overwritten.
  void addFields(Map<String, dynamic> fieldsIncomming) {
    for (final element in fieldsIncomming.keys) {
      if (fieldsIncomming[element] == null) continue;

      fields[element] = fieldsIncomming[element].toString();
    }
  }

  /// Generate a MultipartFile from each `FileConstructor` into list and will be
  /// added to multipart request.
  Future<void> addFiles(List<FileConstructor?> filesIncomingList) async {
    for (final element in filesIncomingList) {
      if (element == null) continue;

      final typeFile = element.type ?? element.getType() ?? "unknow";
      final formatFile = element.format ?? element.getFormat() ?? "unknow";

      files.add(http.MultipartFile.fromBytes(
        element.name,
        await File.fromUri(element.uri).readAsBytes(),
        contentType: MediaType(typeFile, formatFile),
        filename: '${element.name}.$formatFile',
      ));
    }
  }
}

/// A constructor used to storage files data.
///
/// could be used to add files into `http.MultipartRequest` using `addFiles`
/// method.
class FileConstructor {
  const FileConstructor({
    required this.uri,
    required this.name,
    this.format,
    this.type,
  });
  final Uri uri;
  final String name;
  final String? format;
  final String? type;

  /// Get current format of Uri, if dont match will return null
  String? getFormat() => uri.path.split(".").last;

  /// Get current type of File, if dont match will return null
  String? getType() {
    return FilesType.values
        .firstWhereOrNull((element) => element.listValues.contains(getFormat()))
        ?.name;
  }
}

// ? text extension
extension TextExtension on Text {
  Text invertedColor() {
    final color = style?.color ?? Colors.black;
    return Text(
      data ?? "",
      style: style?.copyWith(
          color: Color.fromARGB(
        (color.opacity * 255).round(),
        255 - color.red,
        255 - color.green,
        255 - color.blue,
      )),
    );
  }
}

// ? icon extension
extension IconExtension on Icon {
  Icon invertedColor() {
    final newColor = color ?? Colors.black;
    return Icon(
      icon,
      color: Color.fromARGB(
        (newColor.opacity * 255).round(),
        255 - newColor.red,
        255 - newColor.green,
        255 - newColor.blue,
      ),
    );
  }
}

// ? Navigator extension
extension NavigatorExtension on Navigator {
  ///* Normal `push` method from `Navigator` with custome transition.
  void pushWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) =>
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: Tween<double>(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            ),
            child: child,
          ),
        ),
      );

  ///* Normal `pushReplacement` method from `Navigator` with custome transition.
  void pushReplacementWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) =>
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: Tween<double>(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            ),
            child: child,
          ),
        ),
      );
}
