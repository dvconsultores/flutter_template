import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

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
    this.customPattern = '#,##0.00 ¤',
    this.locale,
    this.maxDecimals = Vars.maxDecimals,
    this.minimumFractionDigits = Vars.maxDecimals,
    this.defaultDecimalRedux = 3,
    this.recognizer,
    this.decimalRecognizer,
    this.compact = false,
    this.textAlign,
    this.overflow,
  });
  final String value;
  final String? symbol;
  final TextStyle? style;
  final TextStyle? styleDecimals;
  final String? customPattern;
  final String? locale;
  final int maxDecimals;
  final int minimumFractionDigits;
  final double defaultDecimalRedux;
  final GestureRecognizer? recognizer;
  final GestureRecognizer? decimalRecognizer;
  final bool compact;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    const defaultDecimalsSize = 13.0;

    final defaultLocale = AppLocale.locale.languageCode,
        decimalSeparator =
            LanguageList.get(locale ?? defaultLocale).decimalSeparator,
        formatted = value.formatAmount(
          symbol: symbol,
          customPattern: customPattern,
          locale: locale ?? defaultLocale,
          maxDecimals: maxDecimals,
          minimumFractionDigits: minimumFractionDigits,
          compact: compact,
        ),
        values = formatted.split(decimalSeparator),
        integers = values.first.replaceFirst('--', '-'),
        decimals = values.elementAtOrNull(1);

    return Text.rich(
      TextSpan(
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
                  fontWeight: FontWeight.normal,
                ) ??
                const TextStyle(
                  fontSize: defaultDecimalsSize,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
        recognizer: recognizer,
      ),
      overflow: overflow,
      textAlign: textAlign,
      style: style,
    );
  }
}
