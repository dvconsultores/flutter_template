import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ButtonAspect extends StatelessWidget {
  const ButtonAspect({
    super.key,
    this.text,
    this.textStyle,
    this.width,
    this.height = Vars.buttonHeight,
    this.constraints,
    this.shape,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius40)),
    this.borderSide = BorderSide.none,
    this.boxShadow = const [Vars.boxShadow3],
    this.color,
    this.bgColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
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
    this.textFitted,
  });
  static final context = globalNavigatorKey.currentContext!;

  final String? text;
  final TextStyle? textStyle;
  final double? width;
  final double height;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final BoxShape? shape;
  final List<BoxShadow> boxShadow;
  final Color? color;
  final Color? bgColor;
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
  final BoxFit? textFitted;
  final Widget? content;
  final Widget? child;

  static ButtonAspect variant({
    String? text,
    TextStyle? textStyle,
    double? width,
    double height = Vars.buttonHeight,
    BoxConstraints? constraints,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius40)),
    BoxShape? shape,
    BorderSide borderSide = BorderSide.none,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color? bgColor,
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
    BoxFit? textFitted,
    Widget? content,
    Widget? child,
  }) =>
      ButtonAspect(
        text: text,
        textStyle: textStyle,
        width: width,
        height: height,
        constraints: constraints,
        shape: shape,
        borderRadius: borderRadius,
        borderSide: borderSide,
        boxShadow: boxShadow,
        color: color ?? ThemeApp.colors(context).text,
        bgColor: bgColor ?? ThemeApp.colors(context).tertiary,
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
        textFitted: textFitted,
        child: child,
      );

  static ButtonAspect variant2({
    String? text,
    TextStyle? textStyle,
    double? width,
    double height = Vars.buttonHeight,
    BoxConstraints? constraints,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius40)),
    BoxShape? shape,
    BorderSide? borderSide,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color bgColor = Colors.white,
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
    BoxFit? textFitted,
    Widget? content,
    Widget? child,
  }) =>
      ButtonAspect(
        text: text,
        textStyle: textStyle,
        width: width,
        height: height,
        constraints: constraints,
        shape: shape,
        borderRadius: borderRadius,
        borderSide: borderSide ??
            BorderSide(width: 1, color: ThemeApp.colors(context).primary),
        boxShadow: boxShadow,
        color: color ?? ThemeApp.colors(context).primary,
        bgColor: bgColor,
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
        textFitted: textFitted,
        child: child,
      );

  static ButtonAspect icon({
    double size = Vars.buttonHeight,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BoxShape shape = BoxShape.circle,
    BorderSide borderSide = BorderSide.none,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color? bgColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    required Widget? icon,
  }) =>
      ButtonAspect(
        width: size,
        height: size,
        shape: shape,
        borderSide: borderSide,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        color: color,
        bgColor: bgColor,
        padding: padding,
        constraints: constraints,
        child: icon,
      );

  static ButtonAspect iconVariant({
    double size = Vars.buttonHeight,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BorderSide borderSide = const BorderSide(width: 1),
    BoxShape shape = BoxShape.circle,
    List<BoxShadow> boxShadow = const [],
    Color? color,
    Color? bgColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    required Widget? icon,
  }) =>
      ButtonAspect(
        width: size,
        height: size,
        shape: shape,
        borderSide: borderSide,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        color: color ?? ThemeApp.colors(context).text,
        bgColor: bgColor ?? ThemeApp.colors(context).tertiary,
        padding: padding,
        constraints: constraints,
        child: icon,
      );

  static ButtonAspect iconVariant2({
    double size = Vars.buttonHeight,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BorderSide borderSide = BorderSide.none,
    BoxShape shape = BoxShape.circle,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color? bgColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    required Widget? icon,
  }) =>
      ButtonAspect(
        width: size,
        height: size,
        shape: shape,
        borderSide: borderSide,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        color: color ?? ThemeApp.colors(context).primary,
        bgColor: bgColor ?? Colors.white,
        padding: padding,
        constraints: constraints,
        child: icon,
      );

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
            TextStyle(
              color: color ?? Colors.white,
              fontSize: 14,
              letterSpacing: 3.9,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.lato("500"),
            ),
        textWidget = Text(
          text ?? '',
          textAlign: textAlign,
          softWrap: textSoftWrap,
          overflow: textOverflow,
          style: ts,
        );

    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        color: bgColor ?? ThemeApp.colors(context).primary,
        border: borderSide != null
            ? Border.all(
                width: borderSide!.width,
                color: borderSide!.color,
                strokeAlign: borderSide!.strokeAlign,
                style: borderSide!.style,
              )
            : null,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: child ??
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
                  textExpanded || textFitted != null
                      ? Expanded(
                          child: textFitted != null
                              ? FittedBox(
                                  fit: textFitted!,
                                  child: textWidget,
                                )
                              : textWidget,
                        )
                      : textWidget,
                //
                if (trailingSpacer)
                  const Spacer()
                else if (trailingGap != null || gap != null)
                  Gap(trailingGap ?? gap!).row,
                //
                if (trailing != null) trailing!,
              ]),
    );
  }
}
