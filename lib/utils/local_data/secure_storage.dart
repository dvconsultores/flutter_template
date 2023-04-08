import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///? Collection used to know storage elements into secure storage.
enum SecureStorageCollection {
  tokenAuth,
  something,
  somethingMore;
}

/// Configuration class to Secure storage.
class SecureStorage {
  ///?  Set options
  static AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static IOSOptions getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  ///? Create storage
  static const storage = FlutterSecureStorage();

  /// Get any value from secure storage using [SecureStorageCollection] key.
  ///
  /// this method will parse [Map], [List], [bool], [Null], [double] or [int].
  static Future<dynamic> read(SecureStorageCollection key) async {
    final String? value = await storage.read(
      key: key.name,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    final valueDecoded = jsonDecode(value ?? "null");
    final isMapOrList = RegExp(r'^[\[,{]|[\],}]$').hasMatch(value ?? '');
    final isBoolean = value == "true" || value == "false";
    final isNumeric =
        valueDecoded.runtimeType == double || valueDecoded.runtimeType == int;

    debugPrint("$value - readed from Secure storage 🛡️");
    if (value.isNotExist || isMapOrList || isBoolean || isNumeric) {
      return valueDecoded;
    }
    return value;
  }

  /// Get any [String] value from secure storage using [SecureStorageCollection] key.
  static Future<dynamic> readString(SecureStorageCollection key) async {
    final String? value = await storage.read(
      key: key.name,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("$value - readed from Secure storage 🛡️");
    return value;
  }

  /// Get all values storaged into secure storage.
  static Future<Map<String, String>> readAll() async {
    final Map<String, String> allValues = await storage.readAll(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("$allValues - all readed from Secure storage 🛡️");
    return allValues;
  }

  /// Delete a value from secure storage using [SecureStorageCollection] key.
  static Future<void> delete(SecureStorageCollection key) async {
    await storage
        .delete(
          key: key.name,
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .whenComplete(() => debugPrint(
            "${key.name} - deleted from Secure storage is cleared 🛡️"));
  }

  /// Delete all values from secure storage.
  static Future<void> deleteAll() async {
    await storage
        .deleteAll(
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .whenComplete(() => debugPrint("Secure storage cleared 🛡️"));
  }

  /// Write/storage a value into secure storage using [SecureStorageCollection] key.
  static Future<void> write(SecureStorageCollection key, String value) async {
    await storage
        .write(
          key: key.name,
          value: value,
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .then((_) => debugPrint("$value - written from Secure storage 🛡️"))
        .catchError((onError) => throw onError);
  }
}
