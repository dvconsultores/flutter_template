import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';

class ReminderService {
  /// Initialize service to validate startup operations and timers included
  static Future<void> init(BuildContext context) async {
    //* use timers here

    // execute validations to reminders
    await validate(context);
  }

  /// Validate reminders one by one.
  static Future<bool> validate(BuildContext context) async {
    //* use reminder validations here

    return true;
  }

  /// Displays a reminder if the specified duration has passed since it was last shown.
  /// Uses Hive to store and check the last reminder display time.
  ///
  /// Parameters:
  /// - hiveDataCollection: The Hive data collection where the last reminder date is stored.
  /// - callback: The function to execute when the reminder should be shown.
  /// - duration: The minimum duration that must pass before showing the reminder again (default is 1 day).
  static Future<bool> reminder(
    HiveDataCollection hiveDataCollection,
    FutureOr Function() callback, {
    Duration duration = const Duration(days: 1),
  }) async {
    final lastShownDate = HiveData.read(hiveDataCollection);
    final now = DateTime.now();

    final lastShown = lastShownDate != null
        ? DateTime.parse(lastShownDate)
        : now.subtract(duration);

    if (now.difference(lastShown).inMilliseconds >= duration.inMilliseconds) {
      await callback();

      HiveData.write(hiveDataCollection, now.toIso8601String());
      return false;
    }

    return true;
  }
}
