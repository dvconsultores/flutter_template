import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';

class ReminderService {
  static Future<void> init() async {
    //* use timers here
  }

  static Future<void> validate() async {
    //* use reminder validations here
  }

  /// Displays a reminder if the specified duration has passed since it was last shown.
  /// Uses Hive to store and check the last reminder display time.
  ///
  /// Parameters:
  /// - hiveDataCollection: The Hive data collection where the last reminder date is stored.
  /// - callback: The function to execute when the reminder should be shown.
  /// - duration: The minimum duration that must pass before showing the reminder again (default is 1 day).
  static void reminder(
    HiveDataCollection hiveDataCollection,
    VoidCallback callback, {
    Duration duration = const Duration(days: 1),
  }) {
    final lastShownDate = HiveData.read(hiveDataCollection);
    final now = DateTime.now();

    final lastShown = lastShownDate != null
        ? DateTime.parse(lastShownDate)
        : now.subtract(duration);

    if (now.difference(lastShown).inMilliseconds >= duration.inMilliseconds) {
      callback();

      HiveData.write(hiveDataCollection, now.toIso8601String());
    }
  }
}
