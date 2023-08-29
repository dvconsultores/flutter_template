import 'dart:io' as io;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoService {
  /// No work is done when instantiating the plugin. It's safe to call this
  /// repeatedly or in performance-sensitive blocks.
  static final instance = DeviceInfoPlugin();

  /// Android module info
  static final android = _Android(instance);

  /// IOS module info
  static final ios = _IOS(instance);
}

class _Android {
  _Android(this._instance);
  final DeviceInfoPlugin _instance;

  /// Information derived from `android.os.Build`.
  ///
  /// See: https://developer.android.com/reference/android/os/Build.html
  late final instance = _instance.androidInfo;

  /// The user-visible version string.
  late final release = instance.then((value) => value.version.release);

  /// The user-visible SDK version of the framework.
  ///
  /// Possible values are defined in: https://developer.android.com/reference/android/os/Build.VERSION_CODES.html
  late final sdkInt = instance.then((value) => value.version.sdkInt);

  /// The manufacturer of the product/hardware.
  /// https://developer.android.com/reference/android/os/Build#MANUFACTURER
  late final manufacturer = instance.then((value) => value.manufacturer);

  /// The end-user-visible name for the end product.
  /// https://developer.android.com/reference/android/os/Build#MODEL
  late final model = instance.then((value) => value.model);

  /// Display device information
  Future<String> info() async {
    if (!io.Platform.isAndroid) throw "Android device not founded";

    final value =
        'Android ${await release} (SDK ${await sdkInt}), ${await manufacturer} ${await model}';
    debugPrint(value); // Android 9 (SDK 28), Xiaomi Redmi Note 7
    return value;
  }
}

class _IOS {
  _IOS(this._instance);
  final DeviceInfoPlugin _instance;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  late final instance = _instance.iosInfo;

  /// The name of the current operating system.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620054-systemname
  late final systemName = instance.then((value) => value.systemName);

  /// The current operating system version.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620043-systemversion
  late final version = instance.then((value) => value.systemVersion);

  /// Device name.
  ///
  /// On iOS < 16 returns user-assigned device name
  /// On iOS >= 16 returns a generic device name if project has
  /// no entitlement to get user-assigned device name.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620015-name
  late final name = instance.then((value) => value.name);

  /// Device model.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620044-model
  late final model = instance.then((value) => value.model);

  /// Display device information
  Future<String> ios() async {
    if (!io.Platform.isIOS) throw "IOS device not founded";

    final value =
        '${await systemName} ${await version}, ${await name} ${await model}';
    debugPrint(value); // iOS 13.1, iPhone 11 Pro Max iPhone
    return value;
  }
}
