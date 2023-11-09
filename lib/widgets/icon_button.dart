import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.style,
    this.splashColor,
    this.splashRadius = 25,
    this.gradient = const LinearGradient(colors: [Colors.indigo, Colors.pink]),
    this.color = Colors.white,
    this.borderRadius = 50.0,
    required this.onPressed,
    this.isLoading = false,
    this.loadingSize = 26,
    this.loadingColor,
    this.disabled = false,
  });
  final Widget icon;
  final double? splashRadius;
  final Color? splashColor;
  final ButtonStyle? style;
  final LinearGradient? gradient;
  final Color? color;
  final double borderRadius;
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
      child: IconButton(
        splashColor: splashColor,
        splashRadius: splashRadius,
        onPressed: (disabled || isLoading) ? null : onPressed,
        style: style,
        icon: isLoading
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
            : icon,
      ),
    );
  }
}
