import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  /// A Flutter plugin for authenticating the user identity locally.
  static final auth = LocalAuthentication();

  /// @returns [true] if has biometrics, [false] otherwise
  static Future<bool> hasBiometrics() async {
    if (kIsWeb) return false;

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    return availableBiometrics.isNotEmpty;
  }

  /// @param [message] Message shown to user in FaceID/TouchID popup
  /// @returns [true] if successfully authenticated, [false] otherwise
  static Future<bool> authenticate([String? message]) async {
    message ??= "Verifica tu identidad antes de continuar";

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) return false;

    // Here ask for bio:
    return await auth.authenticate(localizedReason: message);
  }
}
