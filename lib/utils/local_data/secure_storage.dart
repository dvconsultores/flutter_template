import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ? collection used to know storage elements
enum SecureStorageCollection {
  tokenAuth,
  something,
  somethingMore;
}

class SecureStorage {
  // * Set options
  static AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static IOSOptions getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  // * Create storage
  static const storage = FlutterSecureStorage();

  // * Read value
  static Future<String?> read(SecureStorageCollection key) async {
    final String? value = await storage.read(
      key: key.name,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("$value - readed from Secure storage 🛡️");
    return value;
  }

  // * Read all values
  static Future<Map<String, String>> readAll() async {
    final Map<String, String> allValues = await storage.readAll(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("$allValues - all readed from Secure storage 🛡️");
    return allValues;
  }

  // * Delete value
  static Future delete(SecureStorageCollection key) async {
    await storage
        .delete(
          key: key.name,
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .whenComplete(() =>
            debugPrint("${key.name} - deleted from Secure storage is cleared 🛡️"));
  }

  // * Delete all
  static Future deleteAll() async {
    await storage
        .deleteAll(
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .whenComplete(() => debugPrint("Secure storage cleared 🛡️"));
  }

  // * Write value
  static Future write(SecureStorageCollection key, String value) async {
    await storage
        .write(
          key: key.name,
          value: value,
          aOptions: getAndroidOptions(),
          iOptions: getIOSOptions(),
        )
        .whenComplete(() => debugPrint("$value - written from Secure storage 🛡️"));
  }
}
