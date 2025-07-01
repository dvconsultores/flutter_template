import 'dart:convert';
import 'dart:developer';

import 'package:biometric_storage/biometric_storage.dart';

///? Collection used to know storage elements into hive data.
enum BioStorageCollection {
  publicKey;
}

/// Configuration class to Bio storage.
class BioStorage {
  ///? Create storage
  static final instance = BiometricStorage();

  /// Returns whether this device supports biometric/secure storage or the reason [CanAuthenticateResponse] why it is not supported.
  static Future<CanAuthenticateResponse> canAuthenticate() async {
    return await instance.canAuthenticate();
  }

  /// Get any value from bio storage using [BioStorageCollection] key.
  static Future<T> read<T>(BioStorageCollection key,
      [PromptInfo? promptInfo]) async {
    try {
      final String? value = await (await instance.getStorage(key.name))
          .read(promptInfo: promptInfo);

      return jsonDecode(value ?? "null") as T;
    } catch (error) {
      log("error: $error");
      delete(key, promptInfo);
      return null as T;
    }
  }

  /// Delete a value from bio storage using [BioStorageCollection] key.
  static Future<void> delete(BioStorageCollection key,
          [PromptInfo? promptInfo]) async =>
      await (await instance.getStorage(key.name))
          .delete(promptInfo: promptInfo);

  /// Write/storage a value into bio storage using [BioStorageCollection] key.
  static Future<void> write(BioStorageCollection key, dynamic value,
          [PromptInfo? promptInfo]) async =>
      await (await instance.getStorage(key.name))
          .write(
            jsonEncode(value),
            promptInfo: promptInfo,
          )
          .catchError((onError) => throw onError);
}
