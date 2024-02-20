import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class TextDecimal extends StatelessWidget {
  const TextDecimal(
    this.value, {
    super.key,
    this.symbol,
    this.textStyle,
    this.textStyleDecimals,
    this.customPatterm,
    this.locale = 'es_ES',
    this.recognizer,
  });
  final String value;
  final String? symbol;
  final TextStyle? textStyle;
  final TextStyle? textStyleDecimals;
  final String? customPatterm;
  final String? locale;
  final GestureRecognizer? recognizer;

  @override
  Widget build(BuildContext context) {
    final decimalSeparator = LanguageList.get(locale).decimalSeparator;

    final [integers, decimals] = value
        .amountFormatterCurrency(
            symbol: symbol, customPattern: customPatterm, locale: locale)
        .split(decimalSeparator);

    return Text.rich(TextSpan(
      text: "$integers,",
      children: [
        TextSpan(
          text: decimals,
          style: textStyleDecimals ??
              textStyle?.copyWith(
                fontSize:
                    textStyle!.fontSize != null ? textStyle!.fontSize! - 2 : 14,
              ),
        ),
      ],
      recognizer: recognizer,
      style: textStyle,
    ));
  }
}
