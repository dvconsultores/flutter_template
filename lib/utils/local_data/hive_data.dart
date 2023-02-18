import 'package:hive/hive.dart';

enum HiveBox { aplication }

enum HiveDataCollection {
  something;
}

class HiveData {
  static String boxName = HiveBox.aplication.name;
  static final Box storage = Hive.box(boxName);

  // * something
  static String get getSomething =>
      storage.get(HiveDataCollection.something.name) ?? '';
  static set setSomething(String value) =>
      storage.put(HiveDataCollection.something.name, value);
}
