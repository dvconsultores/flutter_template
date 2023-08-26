import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

// ! ⚠️under revision⚠️
class LocalAuth {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// hasBiometrics()
  ///
  /// @returns [true] if device has fingerprint/faceID available and registered, [false] otherwise
  static Future<bool> hasBiometrics() async {
    if (kIsWeb && !(io.Platform.isAndroid || io.Platform.isIOS)) return false;

    final bool canCheck = await _localAuth.canCheckBiometrics;
    if (!canCheck) return false;

    final List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face) ||
        availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.weak)) {
      return true;
    }

    return false;
  }

  /// authenticateWithBiometrics()
  ///
  /// @param [message] Message shown to user in FaceID/TouchID popup
  /// @returns [true] if successfully authenticated, [false] otherwise
  static Future<bool> authenticateWithBiometrics() async {
    const String message = 'Favor de autenticarse para acceder';
    final bool hasBiometricsEnrolled = await hasBiometrics();

    if (!hasBiometricsEnrolled) return false;

    final LocalAuthentication localAuth = LocalAuthentication();
    return await localAuth.authenticate(
        localizedReason: message,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          biometricOnly: true,
        ));
  }
}
