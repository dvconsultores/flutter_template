import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_gap/flutter_gap.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.text,
    this.textStyle,
    this.loading = false,
    this.loaderSize = 30,
    this.disabled = false,
    this.width,
    this.height = Vars.buttonHeight,
    this.constraints,
    this.shape,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius40)),
    this.borderSide = BorderSide.none,
    this.boxShadow = const [Vars.boxShadow3],
    this.color,
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
    this.textFitted,
    this.customLoader,
  });
  static final context = ContextUtility.context!;

  final String? text;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final TextStyle? textStyle;
  final bool loading;
  final bool disabled;
  final double? width;
  final double? height;
  final double? loaderSize;
  final BoxConstraints? constraints;
  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final OutlinedBorder? shape;
  final List<BoxShadow> boxShadow;
  final Color? color;
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
  final BoxFit? textFitted;
  final Widget? customLoader;
  final Widget? content;
  final Widget? child;

  static Button variant({
    String? text,
    void Function()? onPressed,
    void Function()? onLongPress,
    TextStyle? textStyle,
    bool loading = false,
    bool disabled = false,
    double? width,
    double? height = Vars.buttonHeight,
    double? loaderSize = 30,
    BoxConstraints? constraints,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius40)),
    BorderSide borderSide = BorderSide.none,
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
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
    BoxFit? textFitted,
    Widget? customLoader,
    Widget? content,
    Widget? child,
  }) {
    final colors = ThemeApp.colors(context),
        backgroundColor = bgColor ?? colors.secondary;

    return Button(
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      textStyle: textStyle,
      loading: loading,
      disabled: disabled,
      loaderSize: loaderSize,
      width: width,
      height: height,
      constraints: constraints,
      shape: shape,
      borderRadius: borderRadius,
      borderSide: borderSide,
      boxShadow: boxShadow,
      color: color,
      bgColor: backgroundColor,
      bgColorDisabled: bgColorDisabled ?? backgroundColor.withOpacity(.4),
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
      textFitted: textFitted,
      customLoader: customLoader ?? const CircularProgressIndicator(),
      child: child,
    );
  }

  static Button variant2({
    String? text,
    void Function()? onPressed,
    void Function()? onLongPress,
    TextStyle? textStyle,
    bool loading = false,
    bool disabled = false,
    double? width,
    double? height = Vars.buttonHeight,
    double? loaderSize = 30,
    BoxConstraints? constraints,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius40)),
    BorderSide? borderSide,
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color bgColor = Colors.white,
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
    BoxFit? textFitted,
    Widget? customLoader,
    Widget? content,
    Widget? child,
  }) {
    final colors = ThemeApp.colors(context);

    return Button(
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      textStyle: textStyle,
      loading: loading,
      disabled: disabled,
      loaderSize: loaderSize,
      width: width,
      height: height,
      constraints: constraints,
      shape: shape,
      borderRadius: borderRadius,
      borderSide: borderSide ?? BorderSide(width: 1, color: colors.primary),
      boxShadow: boxShadow,
      color: color ?? colors.primary,
      bgColor: bgColor,
      bgColorDisabled: bgColorDisabled ?? bgColor.withOpacity(.2),
      splashFactory: splashFactory,
      overlayColor: overlayColor ?? colors.primary.withOpacity(.2),
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
      customLoader: customLoader ?? const CircularProgressIndicator(),
      child: child,
    );
  }

  static Button textVariant({
    String? text,
    void Function()? onPressed,
    void Function()? onLongPress,
    TextStyle? textStyle,
    bool loading = false,
    bool disabled = false,
    double? width,
    double? height = Vars.buttonHeight,
    double? loaderSize = 30,
    BoxConstraints? constraints,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius40)),
    BorderSide borderSide = BorderSide.none,
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [],
    Color? color,
    Color bgColor = Colors.transparent,
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
    BoxFit? textFitted,
    Widget? customLoader,
    Widget? content,
    Widget? child,
  }) {
    final colors = ThemeApp.colors(context);

    return Button(
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      textStyle: textStyle,
      loading: loading,
      disabled: disabled,
      loaderSize: loaderSize,
      width: width,
      height: height,
      constraints: constraints,
      shape: shape,
      borderRadius: borderRadius,
      borderSide: borderSide,
      boxShadow: boxShadow,
      color: color ?? colors.text,
      bgColor: bgColor,
      bgColorDisabled: bgColorDisabled ?? Colors.transparent,
      splashFactory: splashFactory,
      overlayColor: overlayColor ?? colors.secondary.withOpacity(.4),
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
      customLoader: customLoader ?? const CircularProgressIndicator(),
      child: child,
    );
  }

  static Button icon({
    required void Function()? onPressed,
    void Function()? onLongPress,
    bool loading = false,
    bool disabled = false,
    double? loaderSize = 30,
    double size = Vars.buttonHeight,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BorderSide borderSide = BorderSide.none,
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color? bgColor,
    Color? bgColorDisabled,
    InteractiveInkFeatureFactory? splashFactory,
    Color? overlayColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    Widget? customLoader,
    required Widget? icon,
  }) =>
      Button(
        width: size,
        height: size,
        loaderSize: loaderSize,
        shape: shape ?? CircleBorder(side: borderSide),
        borderSide: borderSide,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        loading: loading,
        disabled: disabled,
        color: color,
        bgColor: bgColor,
        bgColorDisabled: bgColorDisabled ?? bgColor?.withOpacity(.4),
        splashFactory: splashFactory,
        overlayColor: overlayColor,
        padding: padding,
        onPressed: onPressed,
        onLongPress: onLongPress,
        constraints: constraints,
        customLoader: customLoader,
        child: icon,
      );

  static Button iconVariant({
    required void Function()? onPressed,
    void Function()? onLongPress,
    bool loading = false,
    bool disabled = false,
    double size = Vars.buttonHeight,
    double? loaderSize = 30,
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
    Widget? customLoader,
    required Widget? icon,
  }) {
    final colors = ThemeApp.colors(context),
        backgroundColor = bgColor ?? colors.tertiary;

    return Button(
      width: size,
      height: size,
      loaderSize: loaderSize,
      shape: shape ?? CircleBorder(side: borderSide),
      borderSide: borderSide,
      margin: margin,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      loading: loading,
      disabled: disabled,
      color: color ?? colors.text,
      bgColor: backgroundColor,
      bgColorDisabled: bgColorDisabled ?? backgroundColor.withOpacity(.4),
      splashFactory: splashFactory,
      overlayColor: overlayColor,
      padding: padding,
      onPressed: onPressed,
      onLongPress: onLongPress,
      constraints: constraints,
      customLoader: customLoader ?? const CircularProgressIndicator(),
      child: icon,
    );
  }

  static Button iconVariant2({
    required void Function()? onPressed,
    void Function()? onLongPress,
    bool loading = false,
    bool disabled = false,
    double size = Vars.buttonHeight,
    double? loaderSize = 30,
    BoxConstraints? constraints,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
    BorderSide borderSide = BorderSide.none,
    OutlinedBorder? shape,
    List<BoxShadow> boxShadow = const [Vars.boxShadow3],
    Color? color,
    Color? bgColor,
    Color? bgColorDisabled,
    InteractiveInkFeatureFactory? splashFactory,
    Color? overlayColor,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets? margin,
    Widget? customLoader,
    required Widget? icon,
  }) {
    final colors = ThemeApp.colors(context),
        backgroundColor = bgColor ?? Colors.white;

    return Button(
      width: size,
      height: size,
      loaderSize: loaderSize,
      shape: shape ?? CircleBorder(side: borderSide),
      borderSide: borderSide,
      margin: margin,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      loading: loading,
      disabled: disabled,
      color: color ?? colors.primary,
      bgColor: backgroundColor,
      bgColorDisabled: bgColorDisabled ?? backgroundColor.withOpacity(.4),
      splashFactory: splashFactory,
      overlayColor: overlayColor ?? colors.primary.withAlpha(50),
      padding: padding,
      onPressed: onPressed,
      onLongPress: onLongPress,
      constraints: constraints,
      customLoader: customLoader ?? const CircularProgressIndicator(),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context);

    final ts = textStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
        textWidget = Text(
          text ?? '',
          textAlign: textAlign,
          softWrap: textSoftWrap,
          overflow: textOverflow,
          style: ts,
        ),
        backgroundColor = bgColor ?? colors.primary;

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
        onLongPress: disabled || loading ? null : onLongPress,
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          padding: MaterialStatePropertyAll(
            padding ?? const EdgeInsets.all(Vars.gapMedium),
          ),
          foregroundColor: MaterialStatePropertyAll(color ?? Colors.white),
          splashFactory: splashFactory,
          overlayColor: MaterialStatePropertyAll(overlayColor),
          backgroundColor: disabled
              ? MaterialStatePropertyAll(
                  bgColorDisabled ?? backgroundColor.withOpacity(.4),
                )
              : MaterialStatePropertyAll(backgroundColor),
          shape: MaterialStatePropertyAll(
            shape ??
                RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: borderSide,
                ),
          ),
        ),
        child: loading
            ? SizedBox(
                width: loaderSize ?? (width! / 2),
                height: loaderSize ?? (height! / 2),
                child: customLoader ?? const CircularProgressIndicator(),
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
      ),
    );
  }
}
