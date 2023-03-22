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

// ? RemoveFirstZero input formatter
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
