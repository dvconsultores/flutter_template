import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class CustomValidator {
  const CustomValidator(this.value);
  final String? value;

  /// Main method used to inizialize [CustomValidator] and get the instance
  String? validate(
      List<String? Function()> Function(CustomValidator instance) validators) {
    for (final validator in validators(this)) {
      if (validator() == null) continue;
      return validator();
    }

    return null;
  }

  //* Validators
  String? required([String? customMessage]) =>
      value.hasNotValue ? customMessage ?? "Field required" : null;

  String? walletValidator(int blockchainAsset) {
    final v = value ?? '';

    bool validation() {
      switch (blockchainAsset) {
        // TRON
        case 1:
          {
            final tronRegexp = RegExp(r'^T[A-Za-z1-9]{33}');
            return tronRegexp.hasMatch(v);
          }

        // NEAR
        case 5:
          {
            final nearRegexp = RegExp(
                r'^(([a-z\d]+[-_])*[a-z\d]+\.)*([a-z\d]+[-_])*[a-z\d]+$');
            return v.length >= 2 && v.length <= 64 && nearRegexp.hasMatch(v);
          }

        default:
          return true;
      }
    }

    return validation() ? null : "Wallet address invalid";
  }
}
