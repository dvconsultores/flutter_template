import 'package:flutter/services.dart';

// ? Decimal text input formatter
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    this.formatByComma = false,
    this.maxEntires = 4,
    this.maxDecimals = 2,
  });
  final bool formatByComma;
  final int maxEntires;
  final int maxDecimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regEx = RegExp(
        '^\\d{0,$maxEntires}\\${formatByComma ? "," : "."}?\\d{0,$maxDecimals}');

    final String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}

// ? Remove first zero input formatter
class RemoveFirstZeroInputFormatter extends TextInputFormatter {
  RemoveFirstZeroInputFormatter({this.formatByComma});
  final bool? formatByComma;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newString = newValue.text.replaceAll(RegExp("^0"), "");
    return newString == newValue.text ? newValue : oldValue;
  }
}

// ? Separator input formatter
class SeparatorInputFormatter extends TextInputFormatter {
  SeparatorInputFormatter({
    required this.sample,
    required this.separator,
  });

  /// 🥇Example: [xxx-xxx-xxx]
  final String sample;

  /// 🥇Example: [-]
  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isNotEmpty &&
        newValue.text.length > oldValue.text.length) {
      if (newValue.text.length > sample.length) return oldValue;

      if (newValue.text.length < sample.length &&
          sample[newValue.text.length - 1] == separator) {
        return TextEditingValue(
          text:
              '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
          selection:
              TextSelection.collapsed(offset: newValue.selection.end + 1),
        );
      }
    }

    return newValue;
  }
}
