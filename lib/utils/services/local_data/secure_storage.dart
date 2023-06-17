import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///? Collection used to know storage elements into secure storage.
enum SecureStorageCollection {
  dataUser,
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
  static Future<dynamic> read(SecureStorageCollection key) async {
    final String? value = await storage.read(
      key: key.name,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("${key.name}: $value - readed from Secure storage 🛡️");
    return jsonDecode(value ?? "null");
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
  static Future<void> write(SecureStorageCollection key, dynamic value) async {
    await storage
        .write(
          key: key.name,
          value: jsonEncode(value),
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .then((_) =>
            debugPrint("${key.name}: $value - written from Secure storage 🛡️"))
        .catchError((onError) => throw onError);
  }
}
