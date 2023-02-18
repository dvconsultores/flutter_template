import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageCollection {
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
  static Future<String> read(SecureStorageCollection key) async {
    String? value = await storage.read(
      key: key.name,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("$value 🛡️");
    return value ?? "";
  }

  // * Read all values
  static Future readAll() async {
    Map<String, String> allValues = await storage.readAll(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("$allValues 🛡️");
    return allValues;
  }

  // * Delete value
  static Future delete(SecureStorageCollection key) async {
    await storage.delete(
      key: key.name,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint('"${key.name}" from Secure storage is cleared 🛡️');
  }

  // * Delete all
  static Future deleteAll() async {
    await storage.deleteAll(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );

    debugPrint("Secure storage cleared 🛡️");
  }

  // * Write value
  static Future write(SecureStorageCollection key, String value) async {
    debugPrint("$value 🛡️");

    await storage.write(
      key: key.name,
      value: value,
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );
  }
}
