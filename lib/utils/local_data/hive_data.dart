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
    debugPrint("${key.name} from hive data storage 💦");
    return storage.get(key.name) ?? '';
  }

  // * Read all values
  static Iterable readAll() {
    debugPrint("${storage.values} from hive data storage 💦");
    return storage.values;
  }

  // * Delete value
  static delete(HiveDataCollection key) {
    storage.delete(key.name).whenComplete(
        () => debugPrint('"$key" from hive data storage is cleared 💦'));
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
        .whenComplete(() => debugPrint("$value from hive data storage 💦"));
  }
}
