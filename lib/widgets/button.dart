import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/widgets/loaders/custom_circular_progress_indicator.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.loading = false,
    this.disabled = false,
    this.width = 100,
    this.height = 45,
    this.shape,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.boxShadow = const [
      BoxShadow(
        offset: Offset(-1, 6),
        blurRadius: 3,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.2),
      ),
    ],
    this.color = Colors.white,
    this.bgColor,
    this.bgColorDisabled,
    this.padding,
    this.child,
  });
  final String text;
  final void Function()? onPressed;
  final TextStyle? textStyle;
  final bool loading;
  final bool disabled;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final OutlinedBorder? shape;
  final List<BoxShadow> boxShadow;
  final Color color;
  final Color? bgColor;
  final Color? bgColorDisabled;
  final EdgeInsets? padding;
  final Widget? child;

  static Button icon({
    required void Function()? onPressed,
    bool loading = false,
    bool disabled = false,
    double size = 45,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    OutlinedBorder? shape = const CircleBorder(),
    List<BoxShadow> boxShadow = const [
      BoxShadow(
        offset: Offset(0, 6),
        blurRadius: 3,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.2),
      ),
    ],
    Color color = Colors.white,
    Color? bgColor,
    Color? bgColorDisabled,
    EdgeInsets padding = const EdgeInsets.all(0),
    required Widget? icon,
  }) =>
      Button(
        text: "",
        width: size,
        height: size,
        shape: shape,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        loading: loading,
        disabled: disabled,
        color: color,
        bgColor: bgColor,
        bgColorDisabled: bgColorDisabled,
        padding: padding,
        onPressed: onPressed,
        child: icon,
      );

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
        TextStyle(
          letterSpacing: 3.9,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.lato("700"),
        );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: ElevatedButton(
        onPressed: disabled || loading ? null : onPressed,
        style: ButtonStyle(
          padding: MaterialStatePropertyAll(padding),
          foregroundColor: MaterialStatePropertyAll(color),
          backgroundColor: disabled
              ? MaterialStatePropertyAll(
                  bgColorDisabled ?? ThemeApp.colors(context).disabledColor)
              : MaterialStatePropertyAll(
                  bgColor ?? ThemeApp.colors(context).primary),
          shape: MaterialStatePropertyAll(
              shape ?? RoundedRectangleBorder(borderRadius: borderRadius)),
        ),
        child: loading
            ? SizedBox(
                width: height / 2,
                height: height / 2,
                child: const CustomCircularProgressIndicator(strokeWidth: 3),
              )
            : child ?? Text(text, style: ts),
      ),
    );
  }
}
