import 'package:flutter/material.dart';
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
  });

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

  ButtonAspect copyWith({
    String? text,
    TextStyle? textStyle,
    double? width,
    double? height,
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    BoxShape? shape,
    List<BoxShadow>? boxShadow,
    Color? color,
    Color? bgColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    MainAxisAlignment? buttonAxisAlignment,
    double? gap,
    double? leadingGap,
    double? trailingGap,
    bool? leadingSpacer,
    bool? trailingSpacer,
    Widget? leading,
    Widget? trailing,
    bool? textSoftWrap,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    bool? textExpanded,
    BoxFit? textFitted,
    Widget? content,
    Widget? child,
  }) =>
      ButtonAspect(
        text: text ?? this.text,
        textStyle: textStyle ?? this.textStyle,
        width: width ?? this.width,
        height: height ?? this.height,
        constraints: constraints ?? this.constraints,
        borderRadius: borderRadius ?? this.borderRadius,
        borderSide: borderSide ?? this.borderSide,
        shape: shape ?? this.shape,
        boxShadow: boxShadow ?? this.boxShadow,
        color: color ?? this.color,
        bgColor: bgColor ?? this.bgColor,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        buttonAxisAlignment: buttonAxisAlignment ?? this.buttonAxisAlignment,
        gap: gap ?? this.gap,
        leadingGap: leadingGap ?? this.leadingGap,
        trailingGap: trailingGap ?? this.trailingGap,
        leadingSpacer: leadingSpacer ?? this.leadingSpacer,
        trailingSpacer: trailingSpacer ?? this.trailingSpacer,
        leading: leading ?? this.leading,
        trailing: trailing ?? this.trailing,
        textSoftWrap: textSoftWrap ?? this.textSoftWrap,
        textOverflow: textOverflow ?? this.textOverflow,
        textAlign: textAlign ?? this.textAlign,
        textExpanded: textExpanded ?? this.textExpanded,
        textFitted: textFitted ?? this.textFitted,
        content: content ?? this.content,
        child: child ?? this.child,
      );

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
            TextStyle(
              color: color ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        color: bgColor ?? ThemeApp.of(context).colors.primary,
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

final _themeApp = ThemeApp.of(null);

class ButtonAspectVariant extends ButtonAspect {
  ButtonAspectVariant({
    super.key,
    Color? bgColorDisabled,
    Widget? customLoader,
    Color? bgColor,
    super.borderRadius,
    super.borderSide,
    super.boxShadow = const [Vars.boxShadow3],
    super.buttonAxisAlignment,
    super.child,
    super.color,
    super.constraints,
    super.content,
    super.gap,
    super.height,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.margin,
    super.padding,
    super.shape,
    super.text,
    super.textAlign,
    super.textExpanded,
    super.textFitted,
    super.textOverflow,
    super.textSoftWrap,
    super.textStyle,
    super.trailing,
    super.trailingGap,
    super.trailingSpacer,
    super.width,
  }) : super(bgColor: backgroundColor(bgColor));

  static Color backgroundColor(Color? bgColor) =>
      bgColor ?? _themeApp.colors.secondary;
}

class ButtonAspectIcon extends ButtonAspect {
  const ButtonAspectIcon({
    super.key,
    required Widget icon,
    double size = Vars.buttonHeight,
    Color? bgColorDisabled,
    super.borderRadius = const BorderRadius.all(Radius.circular(100)),
    super.borderSide,
    super.boxShadow = const [Vars.boxShadow3],
    super.buttonAxisAlignment,
    super.color,
    super.constraints,
    super.content,
    super.gap,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.margin,
    super.padding = EdgeInsets.zero,
    super.shape = BoxShape.circle,
    super.text,
    super.textAlign,
    super.textExpanded,
    super.textFitted,
    super.textOverflow,
    super.textSoftWrap,
    super.textStyle,
    super.trailing,
    super.trailingGap,
    super.trailingSpacer,
    super.bgColor,
  }) : super(
          child: icon,
          width: size,
          height: size,
        );
}

class ButtonAspectIconVariant extends ButtonAspect {
  ButtonAspectIconVariant({
    super.key,
    required Widget icon,
    double size = Vars.buttonHeight,
    Color? bgColorDisabled,
    Widget? customLoader,
    super.borderRadius = const BorderRadius.all(Radius.circular(100)),
    super.borderSide = const BorderSide(),
    super.boxShadow = const [],
    super.buttonAxisAlignment,
    Color? color,
    super.constraints,
    super.content,
    super.gap,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.margin,
    super.padding = EdgeInsets.zero,
    super.shape = BoxShape.circle,
    super.text,
    super.textAlign,
    super.textExpanded,
    super.textFitted,
    super.textOverflow,
    super.textSoftWrap,
    super.textStyle,
    super.trailing,
    super.trailingGap,
    super.trailingSpacer,
    Color? bgColor,
  }) : super(
          child: icon,
          width: size,
          height: size,
          color: color ?? _themeApp.colors.text,
          bgColor: backgroundColor(bgColor),
        );

  static Color backgroundColor(Color? bgColor) =>
      bgColor ?? _themeApp.colors.tertiary;
}
