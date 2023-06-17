import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    this.style,
    this.gradient = const LinearGradient(colors: [Colors.indigo, Colors.pink]),
    this.color = Colors.white,
    this.borderRadius = 10.0,
    this.textColor = Colors.white,
    this.fontSize = 15,
    this.fontWeight = FontWeight.normal,
    required this.onPressed,
    this.isLoading = false,
    this.loadingSize = 28,
    this.loadingColor,
    this.disabled = false,
  });
  final String text;
  final ButtonStyle? style;
  final LinearGradient? gradient;
  final Color? color;
  final double borderRadius;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final bool isLoading;
  final double loadingSize;
  final Color? loadingColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: OutlinedButton(
        onPressed: (disabled || isLoading) ? null : onPressed,
        style: style,
        child: isLoading
            ? SizedBox(
                width: loadingSize,
                height: loadingSize,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loadingColor ?? ThemeApp.colors(context).primary,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}
