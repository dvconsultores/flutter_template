import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/model/files_type.dart';
import 'package:flutter_detextre4/utils/general/global_functions.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

// ? Dynamic extension
extension Existence on dynamic {
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

// ? Enum extension
extension EnumExtension on Enum {
  String get name => toString().split('.').last;
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
      return "${minutes}min ${seconds}seg";
    }
    // ? hours
    return "${inHours}h ${minutes}min ${seconds}seg";
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
  String amountFormatter({int maxDecimals = 2, String? locale}) =>
      NumberFormat('#,##0.${"#" * maxDecimals}', locale)
          .format(double.tryParse(toString().replaceAll(",", "")) ?? 0.0);

  /// Format `double` to decimal number system with filling in with zeros.
  ///
  /// by default `locale` has `'en_US'` value and 2 decimals max.
  String amountFormatterWithFilledIn({int maxDecimals = 2, String? locale}) {
    final formattedAmount =
        amountFormatter(maxDecimals: maxDecimals, locale: locale);
    final dotOrComma = locale == null ? "." : ",";
    final amountSplitted = formattedAmount.split(dotOrComma);

    if (amountSplitted.length == 1 || amountSplitted.last.isEmpty) {
      return "${amountSplitted.first}${maxDecimals > 0 ? dotOrComma + '0' * maxDecimals : ''}";
    }

    return amountSplitted.last.length < maxDecimals
        ? "$formattedAmount${'0' * (maxDecimals - amountSplitted.last.length)}"
        : formattedAmount;
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
  DateTime parseToDateTime() => DateTime.parse(this);

  File parseBase64ToFile() => File.fromRawPath(base64Decode(this));

  /// Parse [source] as a, possibly signed, integer literal.
  ///
  /// Like [parse] except that this function returns `null` where a
  /// similar call to [parse] would throw a [FormatException].
  ///
  /// Example:
  /// ```dart
  /// print('2021'.toInt()); // 2021
  /// print('1f'.toInt()); // defaultValue ?? 0
  /// ```
  int toInt({int? defaultValue}) => int.tryParse(this) ?? defaultValue ?? 0;

  /// Parse [source] as a double literal and return its value.
  ///
  /// Like [parse], except that this function returns `null` for invalid inputs
  /// instead of throwing.
  ///
  /// Example:
  /// ```dart
  /// var value = '3.14'.toDouble(); // 3.14
  /// value = '  3.14 \xA0'.toDouble(); // 3.14
  /// value = '0xFF'.toDouble(); // defaultValue ?? 0.0
  /// ```
  double toDouble({double? defaultValue}) =>
      double.tryParse(commasToDot()) ?? defaultValue ?? 0.0;

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
  String amountFormatter({int maxDecimals = 2, String? locale}) =>
      NumberFormat('#,##0.${"#" * maxDecimals}', locale)
          .format(double.tryParse(replaceAll(",", "")) ?? 0.0);

  /// Format `String` to decimal number system with filling in with zeros.
  ///
  /// by default `locale` has `'en_US'` value and 2 decimals max.
  String amountFormatterWithFilledIn({int maxDecimals = 2, String? locale}) {
    final formattedAmount =
        amountFormatter(maxDecimals: maxDecimals, locale: locale);
    final dotOrComma = locale == null ? "." : ",";
    final amountSplitted = formattedAmount.split(dotOrComma);

    if (amountSplitted.length == 1 || amountSplitted.last.isEmpty) {
      return "${amountSplitted.first}${maxDecimals > 0 ? dotOrComma + '0' * maxDecimals : ''}";
    }

    return amountSplitted.last.length < maxDecimals
        ? "$formattedAmount${'0' * (maxDecimals - amountSplitted.last.length)}"
        : formattedAmount;
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
            ? appSnackbar(message!,
                type: ColorSnackbarState.success, duration: duration)
            : null)
        .catchError((onError) => appSnackbar(onError,
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
  String addNetworkPath(String networkPath) {
    if (!hasNetworkPath) return "$networkPath$this";
    debugPrint("$this - already has scheme ⭕");
    return this;
  }

  /// Remove Custom network base url path to `string`.
  ///
  /// normally must to end without slash [/].
  String removeNetworkPath(String networkPath) {
    if (hasNetworkPath) return split(networkPath)[1];
    debugPrint("$this - haven't scheme ⭕");
    return this;
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

// ? response extension
extension ResponseExtension on http.Response {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custome default message.
  String catchErrorMessage({
    String searchBy = "message",
    String defaultMessage = "Error",
  }) =>
      body.isNotEmpty ? jsonDecode(body)[searchBy] : defaultMessage;
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
