import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

///? Collection to Application name used in hive box.
enum HiveBox { application }

///? Collection used to know storage elements into hive data.
enum HiveDataCollection {
  theme,
  language,
  something,
  somethingMore;
}

/// Configuration class to hive.
class HiveData {
  static String boxName = HiveBox.application.name;
  static final Box storage = Hive.box(boxName);

  /// Get any value from hive data using [HiveDataCollection] key.
  static dynamic read(HiveDataCollection key) {
    final dynamic value = storage.get(key.name);

    debugPrint("${key.name}: $value - readed from hive data 💦");
    return value;
  }

  /// Get all values storaged into hive data.
  static Iterable readAll() {
    final Iterable allValues = storage.values;

    debugPrint("$allValues - all readed from hive data 💦");
    return allValues;
  }

  /// Delete a value from hive data using [HiveDataCollection] key.
  static void delete(HiveDataCollection key) {
    storage.delete(key.name).whenComplete(
        () => debugPrint("${key.name} - deleted from hive data is cleared 💦"));
  }

  /// Delete all values from hive data.
  static void deleteAll() {
    storage.clear().whenComplete(() => debugPrint("Hive data cleared 💦"));
  }

  /// Write/storage a value into hive data using [HiveDataCollection] key.
  static void write(HiveDataCollection key, dynamic value) {
    storage.put(key.name, value).whenComplete(() =>
        debugPrint("${key.name}: $value - written from hive data storage 💦"));
  }

  /// Read and write modifying key / values into hive data elements using [HiveDataCollection] key.
  static void updateFields<T>(
    HiveDataCollection key,
    void Function(T stored) values,
  ) {
    final T storedElement = storage.get(key.name);

    if (storedElement == null) return;
    values(storedElement);

    storage.put(key.name, storedElement).whenComplete(() => debugPrint(
        "${key.name}: $storedElement - updated from hive data storage 💦"));
  }
}
