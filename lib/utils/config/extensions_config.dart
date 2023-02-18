import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

extension HiveEnumToString on Enum {
  String get name => toString().split('.').last;
}

extension DateTimeToString on DateTime {
  String get parseToString => toString();
  String get toDateString {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }
}

extension StringToDateTime on String {
  DateTime get parseToDateTime => DateTime.parse(this);
}

extension FileToBase64 on File {
  String get parseToBase64 {
    final Uint8List v = readAsBytesSync();
    // print('v: $v');
    // print('parseToBase64: ${base64Encode(v)}$path');
    return base64Encode(v);
  }
}

extension Base64ToFile on String {
  File get parseBase64ToFile => File.fromRawPath(base64Decode(this));
}
