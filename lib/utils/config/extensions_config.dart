import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

// ? Dynamic extension
extension Existence on dynamic {
  /// Getter to know if value is not null.
  bool get isExist => this != null;

  /// Getter to know if value is null.
  bool get isNotExist => this == null;
}

// ? Enum extension
extension EnumExtension on Enum {
  String get name => toString().split('.').last;
}

// ? DateTime extension
extension DateTimeExtension on DateTime {
  String parseToString() => toString();

  String toDateString() =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
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

// ? List extension
extension ListExtension on List {
  /// Getter to know if List is not [Null] or is not [Empty].
  bool get hasValue => isExist || isNotEmpty;

  /// Getter to know if List is [Null] or is [Empty].
  bool get hasNotValue => isNotExist || isEmpty;

  /// Getter to know if List is not [Null] and is [Empty].
  bool get isEmptyNullable => isExist && isEmpty;

  /// Getter to know if List is not [Null] and is not [Empty].
  bool get isNotEmptyNullable => isExist && isNotEmpty;
}

// ? Map extension
extension MapExtension on Map {
  /// Getter to know if Map is not [Null] or is not [Empty].
  bool get hasValue => isExist || isNotEmpty;

  /// Getter to know if Map is [Null] or is [Empty].
  bool get hasNotValue => isNotExist || isEmpty;

  /// Getter to know if Map is not [Null] and is [Empty].
  bool get isEmptyNullable => isExist && isEmpty;

  /// Getter to know if Map is not [Null] and is not [Empty].
  bool get isNotEmptyNullable => isExist && isNotEmpty;
}

// ? Double extension
extension DoubleExtension on double {
  /// Format text to decimal number system.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String amountFormatter({int maxDecimals = 2, String? locale}) {
    final formatter = NumberFormat('#,##0.${"#" * maxDecimals}', locale);
    return formatter.format(double.parse(toString().replaceAll(",", "")));
  }

  /// Format text to decimal number system with filling in with zeros.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
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

// ? String extension
extension StringExtension on String {
  DateTime parseToDateTime() => DateTime.parse(this);

  File parseBase64ToFile() => File.fromRawPath(base64Decode(this));

  /// Getter to know if String is not [Null] or is not [Empty].
  bool get hasValue => isExist || isNotEmpty;

  /// Getter to know if String is [Null] or is [Empty].
  bool get hasNotValue => isNotExist || isEmpty;

  /// Getter to know if String is not [Null] and is [Empty].
  bool get isEmptyNullable => isExist && isEmpty;

  /// Getter to know if String is not [Null] and is not [Empty].
  bool get isNotEmptyNullable => isExist && isNotEmpty;

  /// Format text to decimal number system.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
  String amountFormatter({int maxDecimals = 2, String? locale}) {
    final formatter = NumberFormat('#,##0.${"#" * maxDecimals}', locale);
    return formatter.format(double.parse(replaceAll(",", "")));
  }

  /// Format text to decimal number system with filling in with zeros.
  ///
  /// by default [locale] has ['en_US'] value and 2 decimals max.
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

  /// Converts first character from string in uppercase.
  String toCapitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  /// Converts all characters from string separated by space in uppercase.
  String toCapitalizeEachFirstWord() =>
      split(" ").map((str) => str.toCapitalize()).join(" ");

  /// Copy text from string to clipboard.
  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: this));
  }

  /// Converts all commas into string to dots
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

  /// Converts all dots into string to commas.
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

  /// Getter to check if string contains [http] into.
  bool get hasNetworkPath => contains("http");

  /// Add Custom network base url path to string.
  String addNetworkPath(String networkPath) {
    if (!hasNetworkPath) return "$networkPath$this";
    debugPrint("$this - already has scheme ⭕");
    return this;
  }

  /// Remove Custom network base url path to string.
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

// ? Multipart request extension
extension MultipartRequestExtension on http.MultipartRequest {
  /// Adds all key/value pairs of [fieldsInComming] to this map and will be
  /// transformer to string.
  ///
  /// If a key of [fieldsInComming] is already in this map, its value is overwritten.
  void addFields(Map<String, dynamic> fieldsInComming) {
    for (final element in fieldsInComming.keys) {
      if (fieldsInComming[element] == null) continue;

      fields[element] = fieldsInComming[element].toString();
    }
  }

  /// Generate a MultipartFile from each [FileConstructor] into list and will be
  /// added to multipart request.
  Future<void> addFiles(List<FileConstructor?> filesIncoming) async {
    for (final element in filesIncoming) {
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
/// could be used to add files into [http.MultipartRequest] using [addFiles]
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

/// A Collection of formats to diverse file types
enum FilesType {
  image([
    "svg",
    "jpeg",
    "jpg",
    "png",
    "gif",
    "tiff",
    "psd",
    "pdf",
    "eps",
    "ai",
    "indd",
    "raw",
  ]),
  video([
    "mp4",
    "mov",
    "wmv",
    "avi",
    "mkv",
    "avchd",
    "flv",
    "f4v",
    "swf",
    "webm",
    "html5",
    "mpeg-2",
  ]),
  audio([
    "m4a",
    "flac",
    "mp3",
    "wav",
    "wma",
    "aac",
  ]);

  const FilesType(this.listValues);

  /// List of admitted formats
  final List<String> listValues;
}
