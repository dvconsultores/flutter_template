import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class TextDecimal extends StatelessWidget {
  const TextDecimal(
    this.value, {
    super.key,
    this.symbol,
    this.style,
    this.styleDecimals,
    this.customPatterm = '#,##0.00 ¤',
    this.locale = 'en_US',
    this.maxDecimals = 3,
    this.minimumFractionDigits = 0,
    this.recognizer,
  });
  final String value;
  final String? symbol;
  final TextStyle? style;
  final TextStyle? styleDecimals;
  final String? customPatterm;
  final String? locale;
  final int maxDecimals;
  final int minimumFractionDigits;
  final GestureRecognizer? recognizer;

  @override
  Widget build(BuildContext context) {
    final decimalSeparator = LanguageList.get(locale).decimalSeparator,
        defaultDecimalsSize = 14.0,
        formatted = value.amountFormatterCurrency(
          symbol: symbol,
          customPattern: customPatterm,
          locale: locale,
          maxDecimals: maxDecimals,
          minimumFractionDigits: minimumFractionDigits,
        );

    final [integers, decimals] = minimumFractionDigits > 0
        ? formatted.split(decimalSeparator)
        : [formatted, null];

    return Text.rich(TextSpan(
      text: integers,
      children: [
        TextSpan(
          text: decimals != null ? "$decimalSeparator$decimals" : null,
          style: styleDecimals ??
              style?.copyWith(
                fontSize: style!.fontSize != null
                    ? style!.fontSize! - 2
                    : defaultDecimalsSize,
              ) ??
              TextStyle(fontSize: defaultDecimalsSize),
        ),
      ],
      recognizer: recognizer,
      style: style,
    ));
  }
}
