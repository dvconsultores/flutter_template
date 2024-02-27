import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class ValidatorField {
  const ValidatorField(this.value);
  final Object? value;

  /// Main method used to inizialize [ValidatorField] and get the instance
  static String? validate(Object? value,
      List<String? Function()> Function(ValidatorField instance) validators) {
    for (final validator in validators(ValidatorField(value))) {
      if (validator() == null) continue;
      return validator();
    }

    return null;
  }

  bool get _isIterable => value is Iterable?;
  Iterable? get _iterableValue => value as Iterable?;

  //* Validators
  String? required([String? customMessage]) {
    bool sentence;

    if (_isIterable) {
      sentence = _iterableValue.hasNotValue;
    } else {
      sentence = value?.toString().isEmpty ?? true;
    }

    return sentence ? customMessage ?? "Required field" : null;
  }

  String? minLength(int l, [String? customMessage]) {
    bool sentence;

    if (_isIterable) {
      sentence = (_iterableValue?.length ?? 0) >= l;
    } else {
      sentence = (value?.toString().length ?? 0) >= l;
    }

    return sentence
        ? null
        : customMessage ??
            (_isIterable
                ? "Join at least $l options"
                : "Join at least $l characters");
  }

  String? maxLength(int l, [String? customMessage]) {
    bool sentence;

    if (_isIterable) {
      sentence = (_iterableValue?.length ?? 0) <= l;
    } else {
      sentence = (value?.toString().length ?? 0) <= l;
    }

    return sentence
        ? null
        : customMessage ??
            (_isIterable ? "Options limit is $l" : "Characters limit is $l");
  }

  String? email() => RegExp(r'^[a-zA-Z\-\_0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
          .hasMatch(value as String? ?? '')
      ? null
      : 'Join a valid email';

  String? password() => RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%&*-]).{6,}$')
          .hasMatch(value as String? ?? '')
      ? null
      : 'The password must have at least one uppercase letter, one lowercase letter, one number, and one special character';

  String? walletValidator(String blockchainAsset, [String? customMessage]) {
    final v = value as String? ?? '';

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

    return validation() ? null : customMessage ?? "Wallet address invalid";
  }
}
