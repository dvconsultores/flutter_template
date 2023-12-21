import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///? Collection used to know storage elements into secure storage.
enum SecureCollection {
  tokenAuth;
}

/// Configuration class to Secure storage.
class SecureStorage {
  ///?  Set options
  static AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static IOSOptions getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static WebOptions getWebOptions() => const WebOptions();

  ///? Create storage
  static const storage = FlutterSecureStorage();

  /// Get any value from secure storage using [SecureCollection] key.
  static Future<T> read<T>(SecureCollection key) async {
    try {
      final String? value = await storage.read(
        key: key.name,
        aOptions: getAndroidOptions(),
        iOptions: getIOSOptions(),
        webOptions: getWebOptions(),
      );

      debugPrint("${key.name}: $value - readed from Secure storage 🛡️");
      return jsonDecode(value ?? "null") as T;
    } catch (_) {
      delete(key);
      return null as T;
    }
  }

  /// Get all values storaged into secure storage.
  static Future<Map<String, String>> readAll() async {
    final Map<String, String> allValues = await storage.readAll(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
      webOptions: getWebOptions(),
    );

    debugPrint("$allValues - all readed from Secure storage 🛡️");
    return allValues;
  }

  /// Delete a value from secure storage using [SecureCollection] key.
  static Future<void> delete(SecureCollection key) async => await storage
      .delete(
        key: key.name,
        aOptions: getAndroidOptions(),
        iOptions: getIOSOptions(),
        webOptions: getWebOptions(),
      )
      .whenComplete(
          () => debugPrint("${key.name} - deleted from Secure storage 🛡️"));

  /// Delete all values from secure storage.
  static Future<void> deleteAll() async => await storage
      .deleteAll(
        aOptions: getAndroidOptions(),
        iOptions: getIOSOptions(),
        webOptions: getWebOptions(),
      )
      .whenComplete(() => debugPrint("Secure storage cleared 🛡️"));

  /// Write/storage a value into secure storage using [SecureCollection] key.
  static Future<void> write(SecureCollection key, dynamic value) async =>
      await storage
          .write(
            key: key.name,
            value: jsonEncode(value),
            aOptions: getAndroidOptions(),
            iOptions: getIOSOptions(),
            webOptions: getWebOptions(),
          )
          .then((_) => debugPrint(
              "${key.name}: $value - written from Secure storage 🛡️"))
          .catchError((onError) => throw onError);

  /// Read and write modifying key / values into hive data elements using [SecureCollection] key.
  static Future<void> updateFields<T>(
    SecureCollection key,
    void Function(T stored) values,
  ) async {
    final T storedElement = jsonDecode((await storage.read(
          key: key.name,
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
          webOptions: getWebOptions(),
        )) ??
        "null");

    if (storedElement == null) return;
    values(storedElement);

    await storage
        .write(
          key: key.name,
          value: jsonEncode(storedElement),
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
          webOptions: getWebOptions(),
        )
        .then((_) => debugPrint(
            "${key.name}: $storedElement - updated from Secure storage 🛡️"))
        .catchError((onError) => throw onError);
  }
}
