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
    this.formatByComma = true,
    this.maxEntires = 10,
    this.maxDecimals = 3,
    this.prefixPadding,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(Variables.radius15)),
    this.border,
    this.borderDisabled,
    this.borderError,
    this.borderFocused,
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
    this.suffixIconConstraints,
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
                final ts = textStyle ?? _ts,
                    hs = hintStyle ??
                        ts.copyWith(
                            color:
                                ThemeApp.colors(context).text.withOpacity(.7),
                            fontSize: 13),
                    ls = labelStyle ??
                        ts.copyWith(
                            color: ThemeApp.colors(context).text, fontSize: 13),
                    fls = floatingLabelStyle ?? ls;

                InputBorder checkBorder(BorderSide border) =>
                    DecoratedInputBorder(
                      child: underline
                          ? UnderlineInputBorder(
                              borderSide: border, borderRadius: borderRadius)
                          : OutlineInputBorder(
                              borderSide: border, borderRadius: borderRadius),
                      shadow: shadow ?? Variables.boxShadow2,
                    );

                final defaultBorder = border ??
                        BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                    disabledBorder = borderDisabled ??
                        BorderSide(color: Theme.of(context).disabledColor),
                    errorBorder = borderError ??
                        BorderSide(color: Theme.of(context).colorScheme.error),
                    focusedBorder = borderFocused ??
                        BorderSide(color: Theme.of(context).focusColor);

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
                  border: checkBorder(defaultBorder),
                  enabledBorder: checkBorder(defaultBorder),
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
                  suffixIconConstraints: suffixIconConstraints,
                  isCollapsed: isCollapsed,
                  isDense: true,
                  contentPadding: contentPadding ??
                      const EdgeInsets.symmetric(
                          horizontal: Variables.gapMedium,
                          vertical: Variables.gapMedium),
                );
              }),
        );
  static final context = globalNavigatorKey.currentContext!,
      _ts = TextStyle(
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
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderError;
  final BorderSide? borderFocused;
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
  final BoxConstraints? suffixIconConstraints;

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
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Variables.radius15)),
    BorderSide? border,
    BorderSide? borderDisabled,
    BorderSide? borderError,
    BorderSide? borderFocused,
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
    BoxConstraints? suffixIconConstraints,
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
        border: border,
        borderDisabled: borderDisabled,
        borderError: borderError,
        borderFocused: borderFocused,
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
        suffixIconConstraints: suffixIconConstraints,
      ),
    );
  }
}
