import 'dart:io' as io;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space_update/disk_space_update.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:uuid/uuid.dart';

/// enum to classify devices 📱 | 💻
enum DeviceType { mobile, desktop, unknown }

/// Physical memory state collection
enum PhysicalMemoryState {
  low(1024),
  medium(2048),
  high(3072),
  unknow(0);

  const PhysicalMemoryState(this.value);
  final double value;

  static PhysicalMemoryState fromDouble(double? value) {
    if (value == null) {
      return unknow;
    } else if (value > medium.value) {
      return high;
    } else if (value > low.value) {
      return medium;
    } else if (value > unknow.value) {
      return low;
    }

    return unknow;
  }
}

/// Instance of Physical memory state
class PhysicalMemory {
  const PhysicalMemory({this.memory, required this.state});
  final double? memory;
  final PhysicalMemoryState state;

  factory PhysicalMemory.fromDouble(double? value) => PhysicalMemory(
      memory: value, state: PhysicalMemoryState.fromDouble(value));
}

class DeviceInfo {
  /// No work is done when instantiating the plugin. It's safe to call this
  /// repeatedly or in performance-sensitive blocks.
  static final instance = DeviceInfoPlugin();

  /// Android module info
  static final android = _Android(instance);

  /// IOS module info
  static final ios = _IOS(instance);

  /// Web module info
  static final web = _Web(instance);

  /// Getter to device [PhysicalMemory] using [DiskSpace] package
  static Future<PhysicalMemory> get physicalMemory async =>
      PhysicalMemory.fromDouble(await DiskSpace.getFreeDiskSpace);

  /// Getter to device model or web user agent
  static Future<String> get deviceName async {
    late final String deviceName;

    if (kIsWeb) {
      deviceName = await DeviceInfo.web.getModel();
    } else if (io.Platform.isAndroid) {
      deviceName = await DeviceInfo.android.model;
    } else {
      deviceName = await DeviceInfo.ios.model;
    }

    return deviceName;
  }

  /// Getter to determine if the device is mobile or desktop.
  /// 📱 | 💻
  static Future<DeviceType> get deviceType async {
    if (kIsWeb) {
      return await DeviceInfo.web.getDeviceType();
    } else {
      if (io.Platform.isAndroid || io.Platform.isIOS) {
        return DeviceType.mobile;
      } else if (io.Platform.isWindows ||
          io.Platform.isLinux ||
          io.Platform.isMacOS) {
        return DeviceType.desktop;
      }
    }

    return DeviceType.unknown;
  }

  /// Getter to determine if the device is mobile or desktop.
  /// 📱 | 💻
  static Future<String?> get getDeviceId async {
    String? deviceId;

    if (kIsWeb) {
      deviceId = await SecureStorage.read(SecureCollection.webUuid);

      // generate device uuid
      if (deviceId == null) {
        deviceId = Uuid().v4();
        await SecureStorage.write(SecureCollection.webUuid, deviceId);
      }
    } else if (io.Platform.isIOS) {
      deviceId = (await ios.instance).identifierForVendor;
    } else if (io.Platform.isAndroid) {
      deviceId = (await android.instance).id;
    }

    return deviceId;
  }
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
    assert(!kIsWeb && io.Platform.isAndroid, "Android device not found");

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
  Future<String> info() async {
    assert(!kIsWeb && io.Platform.isIOS, "IOS device not found");

    final value =
        '${await systemName} ${await version}, ${await name} ${await model}';
    debugPrint(value); // iOS 13.1, iPhone 11 Pro Max iPhone
    return value;
  }
}

class _Web {
  _Web(this._instance);
  final DeviceInfoPlugin _instance;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  late final instance = _instance.webBrowserInfo;

  /// The name of the current operating system.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620054-systemname
  late final systemName = instance.then((value) => value.browserName.name);

  /// The current operating system version.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620043-systemversion
  late final version = instance.then((value) => value.appVersion);

  /// Device name.
  ///
  /// On iOS < 16 returns user-assigned device name
  /// On iOS >= 16 returns a generic device name if project has
  /// no entitlement to get user-assigned device name.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620015-name
  late final name = instance.then((value) => value.appName);

  late final platform = instance.then((value) => value.platform);

  late final userAgent = instance.then((value) => value.userAgent);

  /// Display device information
  Future<String> info() async {
    assert(kIsWeb, "Web platform not found");

    final value =
        '${await systemName} ${await version}, ${await name}, platform: ${await platform}, userAgent: ${await userAgent}';
    debugPrint(value);
    // edge 5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0, Netscape, platform: Win32, userAgent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0
    return value;
  }

  /// Get the model representation from the web device
  Future<String> getModel() async {
    assert(kIsWeb, "Web platform not found");
    final agent = (await userAgent) ?? '';

    final osMatch = RegExp(r'\(([^)]+)\)').firstMatch(agent);
    final osInfo = osMatch != null ? osMatch.group(1) : '';
    String browser = '';

    if (agent.contains('Edg/')) {
      browser = 'Edge';
    } else if (agent.contains('Chrome/')) {
      browser = 'Chrome';
    } else if (agent.contains('Firefox/')) {
      browser = 'Firefox';
    } else if (agent.contains('Safari/') && !agent.contains('Chrome/')) {
      browser = 'Safari';
    } else {
      browser = 'Navegador desconocido';
    }

    return '$browser ($osInfo)';
  }

  /// get the [TargetPlatform] from current device
  ///
  /// if returns [null] it means that current platform is Web
  Future<TargetPlatform?> getOSInsideWeb() async {
    assert(kIsWeb, "Web platform not found");
    final agent = (await userAgent) ?? '';

    if (agent.contains("iphone")) return TargetPlatform.iOS;
    if (agent.contains("ipad")) return TargetPlatform.iOS;
    if (agent.contains("android")) return TargetPlatform.android;

    return null;
  }

  /// Determines if the browser is running on a mobile or desktop device
  /// by analyzing the user agent string.
  Future<DeviceType> getDeviceType() async {
    assert(kIsWeb, "Web platform not found");
    final agent = (await userAgent ?? '').toLowerCase();

    // Patrones comunes para identificar navegadores móviles.
    if (agent.contains('mobi') ||
        agent.contains('android') ||
        agent.contains('iphone')) {
      return DeviceType.mobile;
    }

    return DeviceType.desktop;
  }
}
