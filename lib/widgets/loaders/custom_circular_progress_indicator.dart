import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    super.key,
    this.backgroundColor,
    this.color,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 4.0,
    this.value,
    this.valueColor,
    this.defaultColor = false,
  });

  final Color? backgroundColor;
  final Color? color;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final double? value;
  final Animation<Color?>? valueColor;
  final bool defaultColor;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      key: key,
      backgroundColor: defaultColor
          ? null
          : backgroundColor ?? ThemeApp.colors(context).secondary,
      color: defaultColor ? null : color ?? ThemeApp.colors(context).primary,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      strokeWidth: strokeWidth,
      value: value,
      valueColor: valueColor,
    );
  }
}
