import 'package:hive/hive.dart';

///? Collection to Application name used in hive box.
enum HiveBox { application }

///? Collection used to know storage elements into hive data.
enum HiveDataCollection {
  theme,
  language,
  profile;
}

/// Configuration class to hive.
class HiveData {
  static String boxName = HiveBox.application.name;
  static final Box storage = Hive.box(boxName);

  /// Get any value from hive data using [HiveDataCollection] key.
  static T read<T>(HiveDataCollection key) => storage.get(key.name);

  /// Get all values storaged into hive data.
  static Iterable readAll() => storage.values;

  /// Delete a value from hive data using [HiveDataCollection] key.
  static void delete(HiveDataCollection key) => storage.delete(key.name);

  /// Delete all values from hive data.
  static void deleteAll() => storage.clear();

  /// Write/storage a value into hive data using [HiveDataCollection] key.
  static void write(HiveDataCollection key, dynamic value) =>
      storage.put(key.name, value);

  /// Read and write modifying key / values into hive data elements using [HiveDataCollection] key.
  static void updateFields<T>(
    HiveDataCollection key,
    void Function(T stored) values,
  ) {
    final T storedElement = storage.get(key.name);

    if (storedElement == null) return;
    values(storedElement);

    storage.put(key.name, storedElement);
  }
}
