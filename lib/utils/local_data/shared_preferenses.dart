import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ? collection used to know storage elements
enum SharedPreferensesCollection {
  something,
  somethingMore;
}

class SharedPrefs {
  static final Future<SharedPreferences> futureInstance =
      SharedPreferences.getInstance();

  // * Read value
  static Future<Object?> read(SharedPreferensesCollection key) async {
    final SharedPreferences prefs = await futureInstance;
    final Object? value = prefs.get(key.name);

    debugPrint("$value - readed from shared preferenses ๐ ");
    return value;
  }

  // * Read all values
  static Future<Set<String>> readAll() async {
    final SharedPreferences prefs = await futureInstance;
    final Set<String> allValues = prefs.getKeys();

    debugPrint("$allValues - all readed from shared preferenses ๐ ");
    return allValues;
  }

  // * Delete value
  static Future<bool> delete(SharedPreferensesCollection key) async {
    final SharedPreferences prefs = await futureInstance;

    return prefs.remove(key.name).whenComplete(
        () => debugPrint("${key.name} - deleted from shared preferenses is cleared๐ "));
  }

  // * Delete all
  static Future<bool> deleteAll() async {
    final SharedPreferences prefs = await futureInstance;

    return prefs
        .clear()
        .whenComplete(() => debugPrint("shared preferenses cleared ๐ "));
  }
}
