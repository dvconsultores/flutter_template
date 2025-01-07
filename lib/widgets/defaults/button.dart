import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ButtonListenable extends StatefulWidget {
  const ButtonListenable({super.key, required this.button});
  final Button Function(BuildContext context, bool hasHover) button;

  @override
  State<ButtonListenable> createState() => _ButtonListenableState();
}

class _ButtonListenableState extends State<ButtonListenable> {
  bool hasHover = false;

  @override
  Widget build(BuildContext context) {
    final button = widget.button(context, hasHover);

    return button.copyWith(
      onHover: (value) {
        setState(() => hasHover = value);
        if (button.onHover != null) button.onHover!(value);
      },
    );
  }
}

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
    this.autofocus = false,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.statesController,
    this.clipBehavior = Clip.none,
  });

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
  final bool autofocus;
  final void Function(bool value)? onHover;
  final void Function(bool value)? onFocusChange;
  final FocusNode? focusNode;
  final MaterialStatesController? statesController;
  final Clip clipBehavior;

  Button copyWith({
    String? text,
    void Function()? onPressed,
    void Function()? onLongPress,
    TextStyle? textStyle,
    bool? loading,
    bool? disabled,
    double? width,
    double? height,
    double? loaderSize,
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    OutlinedBorder? shape,
    List<BoxShadow>? boxShadow,
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
    bool? leadingSpacer,
    bool? trailingSpacer,
    Widget? leading,
    Widget? trailing,
    bool? textSoftWrap,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    bool? textExpanded,
    BoxFit? textFitted,
    Widget? customLoader,
    Widget? content,
    Widget? child,
    bool? autofocus,
    void Function(bool value)? onHover,
    void Function(bool value)? onFocusChange,
    FocusNode? focusNode,
    MaterialStatesController? statesController,
    Clip? clipBehavior,
  }) =>
      Button(
        text: text ?? this.text,
        onPressed: onPressed ?? this.onPressed,
        onLongPress: onLongPress ?? this.onLongPress,
        textStyle: textStyle ?? this.textStyle,
        loading: loading ?? this.loading,
        disabled: disabled ?? this.disabled,
        width: width ?? this.width,
        height: height ?? this.height,
        loaderSize: loaderSize ?? this.loaderSize,
        constraints: constraints ?? this.constraints,
        borderRadius: borderRadius ?? this.borderRadius,
        borderSide: borderSide ?? this.borderSide,
        shape: shape ?? this.shape,
        boxShadow: boxShadow ?? this.boxShadow,
        color: color ?? this.color,
        bgColor: bgColor ?? this.bgColor,
        bgColorDisabled: bgColorDisabled ?? this.bgColorDisabled,
        splashFactory: splashFactory ?? this.splashFactory,
        overlayColor: overlayColor ?? this.overlayColor,
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
        customLoader: customLoader ?? this.customLoader,
        content: content ?? this.content,
        autofocus: autofocus ?? this.autofocus,
        onHover: onHover ?? this.onHover,
        onFocusChange: onFocusChange ?? this.onFocusChange,
        focusNode: focusNode ?? this.focusNode,
        statesController: statesController ?? this.statesController,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        child: child ?? this.child,
      );

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.of(context).colors;

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
      key: key,
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
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        focusNode: focusNode,
        onFocusChange: onFocusChange,
        onHover: onHover,
        statesController: statesController,
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

final _themeApp = ThemeApp.of(null);

class ButtonVariant extends Button {
  ButtonVariant({
    super.key,
    required super.onPressed,
    Color? bgColorDisabled,
    super.customLoader,
    Color? bgColor,
    super.autofocus,
    super.borderRadius,
    super.borderSide,
    super.boxShadow = const [Vars.boxShadow3],
    super.buttonAxisAlignment,
    super.child,
    super.clipBehavior,
    super.color,
    super.constraints,
    super.content,
    super.disabled,
    super.focusNode,
    super.gap,
    super.height,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.loaderSize,
    super.loading,
    super.margin,
    super.onFocusChange,
    super.onHover,
    super.onLongPress,
    super.overlayColor,
    super.padding,
    super.shape,
    super.splashFactory,
    super.statesController,
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
  }) : super(
          bgColor: backgroundColor(bgColor),
          bgColorDisabled:
              bgColorDisabled ?? backgroundColor(bgColor).withOpacity(.4),
        );

  static Color backgroundColor(Color? bgColor) =>
      bgColor ?? _themeApp.colors.secondary;
}

class ButtonTextVariant extends Button {
  ButtonTextVariant({
    super.key,
    required super.onPressed,
    Color? bgColorDisabled,
    super.customLoader,
    super.autofocus,
    super.borderRadius,
    super.borderSide,
    super.boxShadow = const [],
    super.buttonAxisAlignment,
    super.child,
    super.clipBehavior,
    Color? color,
    super.constraints,
    super.content,
    super.disabled,
    super.focusNode,
    super.gap,
    super.height,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.loaderSize,
    super.loading,
    super.margin,
    super.onFocusChange,
    super.onHover,
    super.onLongPress,
    super.overlayColor = Colors.black12,
    super.padding,
    super.shape,
    super.splashFactory,
    super.statesController,
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
    super.bgColor = Colors.transparent,
  }) : super(
          color: color ?? _themeApp.colors.text,
          bgColorDisabled: bgColorDisabled ?? Colors.transparent,
        );
}

class ButtonIcon extends Button {
  ButtonIcon({
    super.key,
    required Widget icon,
    double size = Vars.buttonHeight,
    required super.onPressed,
    Color? bgColorDisabled,
    super.customLoader,
    super.autofocus,
    super.borderRadius = const BorderRadius.all(Radius.circular(100)),
    super.borderSide,
    super.boxShadow = const [Vars.boxShadow3],
    super.buttonAxisAlignment,
    super.clipBehavior,
    super.color,
    super.constraints,
    super.content,
    super.disabled,
    super.focusNode,
    super.gap,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.loaderSize,
    super.loading,
    super.margin,
    super.onFocusChange,
    super.onHover,
    super.onLongPress,
    super.overlayColor,
    super.padding = EdgeInsets.zero,
    OutlinedBorder? shape,
    super.splashFactory,
    super.statesController,
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
          shape: shape ?? CircleBorder(side: borderSide),
          bgColorDisabled: bgColorDisabled ?? bgColor?.withOpacity(.4),
        );
}

class ButtonIconVariant extends Button {
  ButtonIconVariant({
    super.key,
    required Widget icon,
    double size = Vars.buttonHeight,
    required super.onPressed,
    Color? bgColorDisabled,
    super.customLoader,
    super.autofocus,
    super.borderRadius = const BorderRadius.all(Radius.circular(100)),
    super.borderSide = const BorderSide(),
    super.boxShadow = const [],
    super.buttonAxisAlignment,
    super.clipBehavior,
    Color? color,
    super.constraints,
    super.content,
    super.disabled,
    super.focusNode,
    super.gap,
    super.leading,
    super.leadingGap,
    super.leadingSpacer,
    super.loaderSize,
    super.loading,
    super.margin,
    super.onFocusChange,
    super.onHover,
    super.onLongPress,
    super.overlayColor,
    super.padding = EdgeInsets.zero,
    OutlinedBorder? shape,
    super.splashFactory,
    super.statesController,
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
          shape: shape ?? CircleBorder(side: borderSide),
          color: color ?? _themeApp.colors.text,
          bgColor: backgroundColor(bgColor),
          bgColorDisabled:
              bgColorDisabled ?? backgroundColor(bgColor).withOpacity(.4),
        );

  static Color backgroundColor(Color? bgColor) =>
      bgColor ?? _themeApp.colors.tertiary;
}
