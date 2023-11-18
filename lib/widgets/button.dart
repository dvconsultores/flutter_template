import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/helper_widgets/gap.dart';
import 'package:flutter_detextre4/widgets/loaders/custom_circular_progress_indicator.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    this.text,
    this.textStyle,
    this.loading = false,
    this.disabled = false,
    this.width,
    this.height = 45,
    this.constraints,
    this.shape,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.borderSide = BorderSide.none,
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
    this.splashFactory,
    this.overlayColor,
    this.padding,
    this.margin,
    this.child,
    this.leading,
    this.trailing,
    this.buttonAxisAlignment,
    this.gap,
    this.leadingGap,
    this.trailingGap,
    this.leadingSpacer = false,
    this.trailingSpacer = false,
    this.textSoftWrap,
    this.textOverflow,
    this.content,
    this.textAlign = TextAlign.center,
    this.textExpanded = false,
  });
  static final context = globalNavigatorKey.currentContext!;

  final String? text;
  final void Function()? onPressed;
  final TextStyle? textStyle;
  final bool loading;
  final bool disabled;
  final double? width;
  final double height;
  final BoxConstraints? constraints;
  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final OutlinedBorder? shape;
  final List<BoxShadow> boxShadow;
  final Color color;
  final Color? bgColor;
  final Color? bgColorDisabled;
  final InteractiveInkFeatureFactory? splashFactory;
  final Color? overlayColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final MainAxisAlignment? buttonAxisAlignment;
  final double? gap;
  final double? leadingGap;
  final double? trailingGap;
  final bool leadingSpacer;
  final bool trailingSpacer;
  final Widget? leading;
  final Widget? trailing;
  final bool? textSoftWrap;
  final TextOverflow? textOverflow;
  final TextAlign textAlign;
  final bool textExpanded;
  final Widget? content;
  final Widget? child;

  static Button variant({
    String? text,
    void Function()? onPressed,
    TextStyle? textStyle,
    bool loading = false,
    bool disabled = false,
    double? width,
    double height = 45,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(40)),
    BorderSide borderSide = const BorderSide(width: 1),
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [],
    Color? color,
    Color? bgColor,
    Color? bgColorDisabled,
    InteractiveInkFeatureFactory? splashFactory,
    Color? overlayColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    MainAxisAlignment? buttonAxisAlignment,
    double? gap,
    double? leadingGap,
    double? trailingGap,
    bool leadingSpacer = false,
    bool trailingSpacer = false,
    Widget? leading,
    Widget? trailing,
    bool? textSoftWrap,
    TextOverflow? textOverflow,
    TextAlign textAlign = TextAlign.center,
    bool textExpanded = false,
    Widget? content,
    Widget? child,
  }) =>
      Button(
        onPressed: onPressed,
        text: text,
        textStyle: textStyle,
        loading: loading,
        disabled: disabled,
        width: width,
        height: height,
        constraints: constraints,
        shape: shape,
        borderRadius: borderRadius,
        borderSide: borderSide,
        boxShadow: boxShadow,
        color: color ?? ThemeApp.colors(context).text,
        bgColor: bgColor ?? ThemeApp.colors(context).tertiary,
        bgColorDisabled: bgColorDisabled,
        splashFactory: splashFactory,
        overlayColor: overlayColor,
        padding: padding,
        margin: margin,
        leading: leading,
        trailing: trailing,
        buttonAxisAlignment: buttonAxisAlignment,
        gap: gap,
        leadingGap: leadingGap,
        trailingGap: trailingGap,
        leadingSpacer: leadingSpacer,
        trailingSpacer: trailingSpacer,
        textSoftWrap: textSoftWrap,
        textOverflow: textOverflow,
        content: content,
        textAlign: textAlign,
        textExpanded: textExpanded,
        child: child,
      );

  static Button icon({
    required void Function()? onPressed,
    bool loading = false,
    bool disabled = false,
    double size = 45,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BorderSide borderSide = BorderSide.none,
    OutlinedBorder? shape,
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
    InteractiveInkFeatureFactory? splashFactory,
    Color? overlayColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    required Widget? icon,
  }) =>
      Button(
        width: size,
        height: size,
        shape: shape ?? CircleBorder(side: borderSide),
        borderSide: borderSide,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        loading: loading,
        disabled: disabled,
        color: color,
        bgColor: bgColor,
        bgColorDisabled: bgColorDisabled,
        splashFactory: splashFactory,
        overlayColor: overlayColor,
        padding: padding,
        onPressed: onPressed,
        constraints: constraints,
        child: icon,
      );

  static Button iconVariant({
    required void Function()? onPressed,
    bool loading = false,
    bool disabled = false,
    double size = 45,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BorderSide borderSide = const BorderSide(width: 1),
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [],
    Color? color,
    Color? bgColor,
    Color? bgColorDisabled,
    InteractiveInkFeatureFactory? splashFactory,
    Color? overlayColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    required Widget? icon,
  }) =>
      Button(
        width: size,
        height: size,
        shape: shape ?? CircleBorder(side: borderSide),
        borderSide: borderSide,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        loading: loading,
        disabled: disabled,
        color: color ?? ThemeApp.colors(context).text,
        bgColor: bgColor ?? ThemeApp.colors(context).tertiary,
        bgColorDisabled: bgColorDisabled,
        splashFactory: splashFactory,
        overlayColor: overlayColor,
        padding: padding,
        onPressed: onPressed,
        constraints: constraints,
        child: icon,
      );

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
        TextStyle(
          fontSize: 14,
          letterSpacing: 3.9,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.lato("700"),
        );

    final widgetText = Text(
      text ?? '',
      textAlign: textAlign,
      softWrap: textSoftWrap,
      overflow: textOverflow,
      style: ts,
    );

    return Container(
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: ElevatedButton(
        onPressed: disabled || loading ? null : onPressed,
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          padding: MaterialStatePropertyAll(padding),
          foregroundColor: MaterialStatePropertyAll(color),
          splashFactory: splashFactory,
          overlayColor: MaterialStatePropertyAll(overlayColor),
          backgroundColor: disabled
              ? MaterialStatePropertyAll(
                  bgColorDisabled ?? ThemeApp.colors(context).disabledColor)
              : MaterialStatePropertyAll(
                  bgColor ?? ThemeApp.colors(context).primary),
          shape: MaterialStatePropertyAll(
            shape ??
                RoundedRectangleBorder(
                    borderRadius: borderRadius, side: borderSide),
          ),
        ),
        child: loading
            ? SizedBox(
                width: height / 2,
                height: height / 2,
                child: const CustomCircularProgressIndicator(strokeWidth: 3),
              )
            : child ??
                Row(
                    mainAxisAlignment:
                        buttonAxisAlignment ?? MainAxisAlignment.center,
                    children: [
                      if (leading != null) leading!,
                      //
                      if (leadingSpacer)
                        const Spacer()
                      else if (leadingGap != null || gap != null)
                        Gap(leadingGap ?? gap!).row,
                      //
                      if (content != null)
                        content!
                      else if (text.hasValue)
                        textExpanded ? Expanded(child: widgetText) : widgetText,
                      //
                      if (trailingSpacer)
                        const Spacer()
                      else if (trailingGap != null || gap != null)
                        Gap(trailingGap ?? gap!).row,
                      //
                      if (trailing != null) trailing!,
                    ]),
      ),
    );
  }
}
