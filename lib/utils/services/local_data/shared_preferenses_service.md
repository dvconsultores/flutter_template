import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//? Collection used to know storage elements into shared preferenses.
enum SharedPreferensesCollection {
  something,
  somethingMore;
}

// ! if you need write a new value into shared preferences need call
// ! [futureInstance] and set manually.

/// Configuration class to Secure storage.
class SharedPrefs {
  /// Get the shared preferences future instance.
  static final Future<SharedPreferences> futureInstance = SharedPreferences.getInstance();

  /// Get any value from shared preferenses using [SharedPreferensesCollection] key.
  static Future<Object?> read(SharedPreferensesCollection key) async {
    final SharedPreferences prefs = await futureInstance;
    final Object? value = prefs.get(key.name);

    return value;
  }

  /// Get all values storaged into shared preferenses.
  static Future<Set<String>> readAll() async {
    final SharedPreferences prefs = await futureInstance;
    final Set<String> allValues = prefs.getKeys();

    return allValues;
  }

  /// Delete a value from shared preferenses using [SharedPreferensesCollection] key.
  static Future<bool> delete(SharedPreferensesCollection key) async {
    final SharedPreferences prefs = await futureInstance;

    return prefs.remove(key.name);
  }

  /// Delete all values from shared preferenses.
  static Future<bool> deleteAll() async {
    final SharedPreferences prefs = await futureInstance;

    return prefs.clear();
  }
}
