import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

/// Widget to transform [Text] to decimal format with currency or not.
///
/// note: can use [SelectionArea] widget to do all [Text] wrapped selectable
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
    this.minimumFractionDigits = 3,
    this.defaultDecimalRedux = 2,
    this.recognizer,
    this.decimalRecognizer,
    this.useUnitFormat = false,
  });
  final String value;
  final String? symbol;
  final TextStyle? style;
  final TextStyle? styleDecimals;
  final String? customPatterm;
  final String? locale;
  final int maxDecimals;
  final int minimumFractionDigits;
  final int defaultDecimalRedux;
  final GestureRecognizer? recognizer;
  final GestureRecognizer? decimalRecognizer;
  final bool useUnitFormat;

  @override
  Widget build(BuildContext context) {
    final decimalSeparator = LanguageList.get(locale).decimalSeparator,
        defaultDecimalsSize = 14.0,
        formatted = value.formatAmount(
          symbol: symbol,
          customPattern: customPatterm,
          locale: locale,
          maxDecimals: maxDecimals,
          minimumFractionDigits: minimumFractionDigits,
          useUnitFormat: useUnitFormat,
        );

    final [integers, decimals] = minimumFractionDigits > 0
        ? formatted.split(decimalSeparator)
        : [formatted, null];

    return Text.rich(TextSpan(
      text: integers,
      children: [
        TextSpan(
          text: decimals != null ? "$decimalSeparator$decimals" : null,
          recognizer: decimalRecognizer,
          style: styleDecimals ??
              style?.copyWith(
                fontSize: style!.fontSize != null
                    ? style!.fontSize! - defaultDecimalRedux
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
