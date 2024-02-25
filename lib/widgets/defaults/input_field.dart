import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/painters/decorated_input_border.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/input_formatters.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

class InputField extends TextFormField {
  InputField({
    super.key,
    super.controller,
    super.validator,
    super.autovalidateMode,
    super.obscureText,
    super.readOnly,
    super.expands,
    super.focusNode,
    super.onTap,
    super.onTapOutside,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.textAlign = TextAlign.start,
    super.onFieldSubmitted,
    super.autocorrect,
    super.autofocus,
    this.keyboardType,
    this.inputFormatters,
    this.labelText,
    this.hintText,
    this.disabled = false,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.maxWidthPrefix = double.infinity,
    this.numeric = false,
    this.formatByComma = false,
    this.maxEntires = 10,
    this.maxDecimals = 2,
    this.prefixPadding,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.borderWidth = 1,
    this.borderColor,
    this.disabledBorderColor,
    this.errorBorderColor,
    this.focusedBorderColor,
    this.underline = false,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.floatingLabelStyle,
    this.filled = true,
    this.color,
    this.decoration,
    this.errorMaxLines,
    this.shadow,
    this.counterText,
    this.isCollapsed = false,
  }) : super(
          style: textStyle ?? _ts,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(
                  signed: true, decimal: true)
              : keyboardType,
          inputFormatters: [
            if (numeric) ...[
              DecimalTextInputFormatter(
                formatByComma: formatByComma,
                maxEntires: maxEntires,
                maxDecimals: maxDecimals,
              ),
            ],
            if (inputFormatters != null && inputFormatters.isNotEmpty)
              ...inputFormatters
          ],
          decoration: decoration ??
              buildWidget<InputDecoration>(() {
                final ts = textStyle ?? _ts;

                final hs = hintStyle ??
                    ts.copyWith(
                        color: ThemeApp.colors(context).text.withOpacity(.7),
                        fontSize: 13);
                final ls = labelStyle ??
                    ts.copyWith(
                        color: ThemeApp.colors(context).text, fontSize: 13);
                final fls = floatingLabelStyle ?? ls;

                InputBorder checkBorder(Color color) => DecoratedInputBorder(
                      child: underline
                          ? UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: borderWidth, color: color),
                              borderRadius: borderRadius,
                            )
                          : OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: borderWidth, color: color),
                              borderRadius: borderRadius,
                            ),
                      shadow: shadow ??
                          const BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 6),
                            blurRadius: 10,
                          ),
                    );

                final border =
                    borderColor ?? Theme.of(context).colorScheme.outline;
                final disabledBorder =
                    disabledBorderColor ?? Theme.of(context).disabledColor;
                final errorBorder =
                    errorBorderColor ?? Theme.of(context).colorScheme.error;
                final focusedBorder =
                    focusedBorderColor ?? Theme.of(context).focusColor;

                return InputDecoration(
                  prefixIconConstraints:
                      BoxConstraints(maxWidth: maxWidthPrefix),
                  enabled: !disabled,
                  counterText: counterText,
                  hintText: hintText,
                  hintStyle: hs,
                  labelText: labelText,
                  labelStyle: ls,
                  floatingLabelStyle: fls,
                  floatingLabelBehavior: floatingLabelBehavior,
                  filled: filled,
                  fillColor: color ?? ThemeApp.colors(context).background,
                  border: checkBorder(border),
                  enabledBorder: checkBorder(border),
                  disabledBorder: checkBorder(disabledBorder),
                  errorBorder: checkBorder(errorBorder),
                  focusedBorder: checkBorder(focusedBorder),
                  errorMaxLines: errorMaxLines,
                  prefix: prefix,
                  prefixIcon: prefixIcon != null
                      ? IntrinsicWidth(
                          child: Padding(
                            padding: prefixPadding ??
                                const EdgeInsets.symmetric(
                                    horizontal: Variables.gapMedium),
                            child: prefixIcon,
                          ),
                        )
                      : null,
                  suffix: suffix,
                  suffixIcon: suffixIcon,
                  isCollapsed: isCollapsed,
                  isDense: true,
                  contentPadding: contentPadding ??
                      const EdgeInsets.symmetric(
                          horizontal: Variables.gapMedium,
                          vertical: Variables.gapMedium),
                );
              }),
        );
  static final context = globalNavigatorKey.currentContext!;
  static final _ts = TextStyle(
    color: ThemeApp.colors(context).text.withOpacity(.75),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.lato("400"),
  );

  final String? labelText;
  final String? hintText;
  final bool disabled;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;
  final double maxWidthPrefix;
  final bool numeric;
  final List<TextInputFormatter>? inputFormatters;
  final bool formatByComma;
  final int maxEntires;
  final int maxDecimals;
  final EdgeInsetsGeometry? prefixPadding;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final Color? errorBorderColor;
  final Color? focusedBorderColor;
  final bool underline;
  final FloatingLabelBehavior floatingLabelBehavior;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final bool filled;
  final Color? color;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final int? errorMaxLines;
  final BoxShadow? shadow;
  final String? counterText;
  final bool isCollapsed;

  static Widget sizedBox({
    double? width,
    double? height,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    bool disabled = false,
    bool readOnly = false,
    bool numeric = false,
    TextAlign textAlign = TextAlign.start,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLines = 1,
    int? minLines,
    int? maxLength,
    FocusNode? focusNode,
    void Function(String value)? onChanged,
    void Function()? onTap,
    void Function(PointerDownEvent event)? onTapOutside,
    AutovalidateMode? autovalidateMode,
    Widget? prefix,
    Widget? suffix,
    String? Function(String? value)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    EdgeInsetsGeometry? prefixPadding,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(15)),
    double borderWidth = 1,
    Color? borderColor,
    Color? disabledBorderColor,
    Color? errorBorderColor,
    Color? focusedBorderColor,
    bool underline = false,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    EdgeInsets? contentPadding,
    bool formatByComma = true,
    double maxWidthPrefix = double.infinity,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    bool filled = true,
    Color? color,
    InputDecoration? decoration,
    int? errorMaxLines,
    void Function(String value)? onFieldSubmitted,
    bool autocorrect = true,
    BoxShadow? shadow,
    bool autofocus = false,
    String? counterText,
    bool isCollapsed = false,
  }) {
    final expanded = height != null;

    return SizedBox(
      width: width,
      height: height,
      child: InputField(
        onTapOutside: onTapOutside,
        onTap: onTap,
        onChanged: onChanged,
        focusNode: focusNode,
        controller: controller,
        hintText: hintText,
        disabled: disabled,
        expands: expanded,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(signed: true, decimal: true)
            : expanded && keyboardType == null
                ? TextInputType.text
                : keyboardType,
        maxLines: expanded ? null : maxLines,
        minLines: minLines,
        labelText: labelText,
        maxLength: maxLength,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textAlign: textAlign,
        autovalidateMode: autovalidateMode,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        borderColor: borderColor,
        disabledBorderColor: disabledBorderColor,
        errorBorderColor: errorBorderColor,
        focusedBorderColor: focusedBorderColor,
        underline: underline,
        contentPadding: contentPadding,
        floatingLabelBehavior: floatingLabelBehavior,
        formatByComma: formatByComma,
        inputFormatters: inputFormatters,
        maxWidthPrefix: maxWidthPrefix,
        numeric: numeric,
        obscureText: obscureText,
        prefix: prefix,
        prefixPadding: prefixPadding,
        readOnly: readOnly,
        suffix: suffix,
        validator: validator,
        textStyle: textStyle,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        floatingLabelStyle: floatingLabelStyle,
        filled: filled,
        color: color,
        decoration: decoration,
        errorMaxLines: errorMaxLines,
        onFieldSubmitted: onFieldSubmitted,
        autocorrect: autocorrect,
        shadow: shadow,
        autofocus: autofocus,
        counterText: counterText,
        isCollapsed: isCollapsed,
      ),
    );
  }
}
