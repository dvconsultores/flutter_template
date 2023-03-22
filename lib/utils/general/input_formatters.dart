import 'package:flutter/services.dart';

// ? Decimal text input formatter
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.formatByComma});
  final bool? formatByComma;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExBycomma = RegExp(r'^\d*\,?\d*');
    final regExByDot = RegExp(r'^\d*\.?\d*');
    final regEx = formatByComma ?? false ? regExBycomma : regExByDot;

    final String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
