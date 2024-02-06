import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class CustomValidator {
  const CustomValidator(this.value);
  final String? value;

  /// Main method used to inizialize [CustomValidator] and get the instance
  static String? validate(String? value,
      List<String? Function()> Function(CustomValidator instance) validators) {
    for (final validator in validators(CustomValidator(value))) {
      if (validator() == null) continue;
      return validator();
    }

    return null;
  }

  //* Validators
  String? required([String? customMessage]) =>
      value.hasNotValue ? customMessage ?? "Required field" : null;

  String? minLength(int l) =>
      (value?.length ?? 0) >= l ? null : "Join at least $l characters";

  String? maxLength(int l) =>
      (value?.length ?? 0) <= l ? null : "characters limit is $l ";

  String? walletValidator(String blockchainAsset) {
    final v = value ?? '';

    bool validation() {
      switch (blockchainAsset) {
        // TRON
        case "Tron (TRC20)":
          {
            final tronRegexp = RegExp(r'^T[A-Za-z1-9]{33}');
            return tronRegexp.hasMatch(v);
          }

        // NEAR
        case "Near Protocol":
          {
            final nearEval = RegExp(r'.near'),
                lengthEval = v.length - 5,
                nearMatch = lengthEval.isNegative
                    ? null
                    : nearEval.matchAsPrefix(v, lengthEval),
                nearRegexp = RegExp(
                    r'^(([a-z\d]+[-_])*[a-z\d]+\.)*([a-z\d]+[-_])*[a-z\d]+$');

            return nearMatch != null ||
                (v.length == 64 && nearRegexp.hasMatch(v));
          }

        default:
          return true;
      }
    }

    return validation() ? null : "Wallet address invalid";
  }
}
