import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum HiveBox { aplication }

// ? collection used to know storage elements
enum HiveDataCollection {
  something,
  somethingMore;
}

class HiveData {
  static String boxName = HiveBox.aplication.name;
  static final Box storage = Hive.box(boxName);

  // * Read value
  static String read(HiveDataCollection key) {
    final String value = storage.get(key.name) ?? '';

    debugPrint("$value - readed from hive data storage 💦");
    return value;
  }

  // * Read all values
  static Iterable readAll() {
    final Iterable allValues = storage.values;

    debugPrint("$allValues - all readed from hive data storage 💦");
    return allValues;
  }

  // * Delete value
  static delete(HiveDataCollection key) {
    storage.delete(key.name).whenComplete(
        () => debugPrint("${key.name} - deleted from hive data storage is cleared 💦"));
  }

  // * Delete all
  static deleteAll() {
    storage
        .clear()
        .whenComplete(() => debugPrint("Hive data storage cleared 💦"));
  }

  // * Write value
  static write(HiveDataCollection key, String value) {
    storage
        .put(key.name, value)
        .whenComplete(() => debugPrint("$value - written from hive data storage 💦"));
  }
}
