import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

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
  String parseToBase64() =>
      // print('parseToBase64: ${base64Encode(readAsBytesSync())} - $path');
      base64Encode(readAsBytesSync());
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
}
