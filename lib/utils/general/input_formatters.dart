import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:intl/intl.dart';

// ? Decimal text input formatter
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    this.locale,
    this.maxEntires = 4,
    this.maxDecimals = Vars.maxDecimals,
  });
  final String? locale;
  final int maxEntires;
  final int maxDecimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final language = LanguageList.get(locale ?? AppLocale.locale.languageCode),
        decimalSeparator = language.decimalSeparator,
        thousandsSeparator = language.thousandsSeparator,
        regEx = RegExp('^\\d{0,$maxEntires}[\\.\\,]?\\d{0,$maxDecimals}'),
        newString = regEx.stringMatch(newValue.text) ?? "";

    // if string match to format.
    if (newString == newValue.text) {
      // if string match start with dot or comma.
      if (RegExp("^[\\.\\,]").hasMatch(newValue.text)) {
        return newValue.copyWith(
            text: '0$decimalSeparator${newValue.text.substring(1)}',
            selection: TextSelection.collapsed(
              offset: newValue.text.length + 1,
            ));
        // else if string match start with 0 followed by other digit.
      } else if (RegExp("^0[0-9]").hasMatch(newValue.text)) {
        return newValue.copyWith(
            text: newValue.text.split("0").join(""),
            selection: TextSelection.collapsed(
              offset: newValue.text.split("0").join("").length,
            ));
        // else if contains contrary to [decimalSeparator].
      } else if (newValue.text.contains(thousandsSeparator)) {
        return newValue.copyWith(
            text:
                newValue.text.replaceAll(thousandsSeparator, decimalSeparator),
            selection: TextSelection.collapsed(
              offset: newValue.text.length,
            ));
      }

      // return without mutation.
      return newValue;
    }

    // if string not matching retrun oldValue.
    return oldValue;
  }
}

// ? Currency input formatter
class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({
    this.locale,
    this.name,
    this.symbol,
    this.decimalDigits = Vars.maxDecimals,
    this.customPattern,
    this.turnOffGrouping = false,
    this.enableNegative = true,
  });

  /// Defaults `locale` is null.
  ///
  /// Put 'en' or 'es' for locale
  final String? locale;

  /// Defaults `name` is null.
  ///
  /// the currency with that ISO 4217 name will be used.
  /// Otherwise we will use the default currency name for the current locale.
  /// If no [symbol] is specified, we will use the currency name in the formatted result.
  /// e.g. var f = NumberFormat.currency(locale: 'en_US', name: 'EUR') will format currency like "EUR1.23".
  /// If we did not specify the name, it would format like "USD1.23".
  final String? name;

  /// Defaults `symbol` is null.
  ///
  /// Put '\$' for symbol
  final String? symbol;

  /// Defaults `decimalDigits` is null.
  final int? decimalDigits;

  /// Defaults `customPattern` is null.
  ///
  /// Can be used to specify a particular format.
  /// This is useful if you have your own locale data which includes unsupported formats
  /// (e.g. accounting format for currencies.)
  final String? customPattern;

  /// Defaults `turnOffGrouping` is false.
  ///
  /// Explicitly turn off any grouping (e.g. by thousands) in this format.
  /// This is used in compact number formatting, where we omit the normal grouping.
  /// Best to know what you're doing if you call it.
  final bool turnOffGrouping;

  /// Defaults `enableNegative` is true.
  ///
  /// Set to false if you want to disable negative numbers.
  final bool enableNegative;

  num _newNum = 0;
  String _newString = '';
  bool _isNegative = false;

  void _formatter(String newText) {
    final NumberFormat format = NumberFormat.currency(
      locale: locale ?? AppLocale.locale.languageCode,
      name: name ?? "",
      symbol: symbol,
      decimalDigits: decimalDigits,
      customPattern: customPattern,
    );
    if (turnOffGrouping) {
      format.turnOffGrouping();
    }

    _newNum = num.tryParse(newText) ?? 0;
    if (format.decimalDigits! > 0) {
      _newNum /= pow(10, format.decimalDigits!);
    }

    // ! trying to modify logic
    // final number = format
    //     .format(_newNum)
    //     .trim()
    //     .split(symbol ?? name ?? "EUR")
    //     .first
    //     .trim()
    //     .removeTraillingZeros();

    // _newString =
    //     '${_isNegative ? '-' : ''}$number ${(symbol ?? name ?? "EUR")}';
    // ! trying to modify logic

    _newString = (_isNegative ? '-' : '') + format.format(_newNum).trim();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // final bool isInsertedCharacter =
    //     oldValue.text.length + 1 == newValue.text.length &&
    //         newValue.text.startsWith(oldValue.text);
    final bool isRemovedCharacter =
        oldValue.text.length - 1 == newValue.text.length &&
            oldValue.text.startsWith(newValue.text);
    // Apparently, Flutter has a bug where the framework calls
    // formatEditUpdate twice, or even four times, after a backspace press (see
    // https://github.com/gtgalone/currency_text_input_formatter/issues/11).
    // However, only the first of these calls has inputs which are consistent
    // with a character insertion/removal at the end (which is the most common
    // use case of editing the TextField - the others being insertion/removal
    // in the middle, or pasting text onto the TextField). This condition
    // fixes a problem where a character wasn't properly erased after a
    // backspace press, when this Flutter bug was present. This comes at the
    // cost of losing insertion/removal in the middle and pasting text.
    // if (!isInsertedCharacter && !isRemovedCharacter) {
    //   return oldValue;
    // }

    if (enableNegative) {
      _isNegative = newValue.text.startsWith('-');
    } else {
      _isNegative = false;
    }

    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // If the user wants to remove a digit, but the last character of the
    // formatted text is not a digit (for example, "1,00 €"), we need to remove
    // the digit manually.
    if (isRemovedCharacter && !_lastCharacterIsDigit(oldValue.text)) {
      final int length = newText.length - 1;
      newText = newText.substring(0, length > 0 ? length : 0);
    }

    _formatter(newText);

    if (newText.trim() == '' || newText == '00' || newText == '000') {
      return TextEditingValue(
        text: _isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: _isNegative ? 1 : 0),
      );
    }

    return TextEditingValue(
      text: _newString,
      selection: TextSelection.collapsed(offset: _newString.length),
    );
  }

  static bool _lastCharacterIsDigit(String text) {
    final String lastChar = text.substring(text.length - 1);
    return RegExp('[0-9]').hasMatch(lastChar);
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class RestrictedCharactersFormatter extends TextInputFormatter {
  const RestrictedCharactersFormatter(this.restrictedCharacters);
  final Set<String> restrictedCharacters;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String replaced = '';
    int cursorPosition = newValue.selection.end;
    int offset = 0;

    for (final char in newValue.text.characters) {
      if (!restrictedCharacters.contains(char)) {
        replaced += char;
      } else {
        if (cursorPosition > newValue.text.indexOf(char) - offset) {
          // Si el caracter restringido está antes del cursor, ajustamos el offset
          cursorPosition--;
        }
        offset++;
      }
    }

    return TextEditingValue(
      text: replaced,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
