import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ValidatorField {
  const ValidatorField(this.value, [this.validators]);
  final Object? value;
  final List<String? Function()> Function(ValidatorField instance)? validators;

  /// Main method used to inizialize [ValidatorField] and get the instance
  String? validate() {
    for (final validator in validators!(ValidatorField(value))) {
      if (validator() == null) continue;
      return validator();
    }

    return null;
  }

  /// Main method used to inizialize [ValidatorField] and get the instance
  static String? evaluate(
    Object? value,
    List<String? Function()> Function(ValidatorField instance) validators,
  ) {
    for (final validator in validators(ValidatorField(value))) {
      if (validator() == null) continue;
      return validator();
    }

    return null;
  }

  /// Main method used to validate multiple [ValidatorField] instance
  static String? evaluateMultiple(List<ValidatorField> validations) {
    for (final validation in validations) {
      for (final validator
          in validation.validators!(ValidatorField(validation.value))) {
        if (validator() == null) continue;
        return validator();
      }
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

  String? maxFileLength([int bytes = 3000000]) {
    late int fileLength;
    if (value is PlatformFile?) {
      fileLength = (value as PlatformFile?)?.size ?? 0;
    } else if (value is File?) {
      fileLength = (value as File?)?.lengthSync() ?? 0;
    }

    return fileLength > bytes
        ? "maximum file size is ${bytes.formatBytes()}"
        : null;
  }

  String? email() => Vars.emailRegExp.hasMatch(value as String? ?? '')
      ? null
      : 'Join a valid email';

  String? password() => Vars.passwordRegExp.hasMatch(value as String? ?? '')
      ? null
      : 'The password must have at least one uppercase letter, one lowercase letter, one number, and one special character';

  String? isValidPhoneNumber({
    String? mask,
    int length = 11,
    int lengthAreaCode = 3,
    bool enableStartCeroValidation = false,
  }) {
    final text =
        MaskTextInputFormatter(mask: mask).unmaskText(value as String? ?? '');

    if (!text.startsWith('0') && enableStartCeroValidation) length -= 1;

    return Vars.phoneRegExp(length: length, lengthAreaCode: lengthAreaCode)
            .hasMatch(text)
        ? null
        : "Phone invalid";
  }

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
