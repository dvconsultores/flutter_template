import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

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

// ? String extension
extension StringExtension on String {
  DateTime parseToDateTime() => DateTime.parse(this);

  File parseBase64ToFile() => File.fromRawPath(base64Decode(this));

  String toCapitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  String toCapitalizeEachFirstWord() =>
      split(" ").map((str) => str.toCapitalize()).join(" ");

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: this));
  }

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

  bool get hasNetworkPath => contains("http");

  String addNetworkPath(String networkPath) {
    if (!hasNetworkPath) return "$networkPath$this";
    debugPrint("This uri already has scheme ⭕");
    return this;
  }

  String removeNetworkPath(String networkPath) {
    if (hasNetworkPath) return split(networkPath)[1];
    debugPrint("This uri haven't scheme ⭕");
    return this;
  }
}

// ? Unused
// ? Uri extension
// extension UriExtension on Uri {
//   String get originalPath {
//     if (hasScheme) {
//       return "/${pathSegments.join("/").split(origin)[0]}";
//     }
//     return pathSegments.join("/");
//   }

//   Uri addNetworkPath(String netWorkPath) {
//     if (!hasScheme) {
//       return Uri.parse("$netWorkPath$originalPath");
//     }
//     debugPrint("This uri already has scheme ⭕");
//     return this;
//   }

//   Uri removeNetworkPath() {
//     if (hasScheme) {
//       return Uri.parse(originalPath);
//     }
//     debugPrint("This uri haven't scheme ⭕");
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
        .firstWhereOrNull((element) => element.value.contains(getFormat()))
        ?.name;
  }
}

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

  const FilesType(this.value);
  final List<String> value;
}
