import 'package:flutter/services.dart';

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
    final isCommaOrDot = formatByComma ? "," : ".";
    final regEx =
        RegExp('^\\d{0,$maxEntires}\\$isCommaOrDot?\\d{0,$maxDecimals}');
    final String newString = regEx.stringMatch(newValue.text) ?? "";

    // if string match to format
    if (newString == newValue.text) {
      // if string match start with dot or comma
      if (RegExp("^\\$isCommaOrDot").hasMatch(newValue.text)) {
        return newValue.copyWith(
            text: '0$isCommaOrDot${newValue.text.substring(1)}',
            selection: TextSelection.collapsed(
              offset: newValue.text.length + 1,
            ));
        // else if string match start with 0 followed by other digit
      } else if (RegExp("^0[0-9]").hasMatch(newValue.text)) {
        return newValue.copyWith(
            text: newValue.text.split("0").join(""),
            selection: TextSelection.collapsed(
              offset: newValue.text.split("0").join("").length,
            ));
      }

      // return without mutation
      return newValue;
    }

    // if string not matching retrun oldValue
    return oldValue;
  }
}
