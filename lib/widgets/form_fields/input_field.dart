import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/painters/decorated_input_border.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/input_formatters.dart';

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
    void Function(String value)? onChanged,
    super.textAlign = TextAlign.start,
    super.onFieldSubmitted,
    super.autocorrect,
    super.autofocus,
    String? labelText,
    String? hintText,
    bool disabled = false,
    Widget? prefixIcon,
    Widget? prefix,
    Widget? suffixIcon,
    Widget? suffix,
    double maxWidthPrefix = double.infinity,
    bool numeric = false,
    List<TextInputFormatter>? inputFormatters,
    int maxEntires = 10,
    int maxDecimals = 3,
    EdgeInsetsGeometry? prefixPadding,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius15)),
    BorderSide? border,
    BorderSide? borderDisabled,
    BorderSide? borderError,
    BorderSide? borderFocused,
    bool underline = false,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.never,
    EdgeInsets? contentPadding,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    bool filled = true,
    Color? color,
    TextInputType? keyboardType,
    InputDecoration? decoration,
    int? errorMaxLines,
    BoxShadow? shadow,
    String? counterText,
    bool isCollapsed = false,
    BoxConstraints? suffixIconConstraints,
  }) : super(
          style: textStyle ?? _ts,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(
                  signed: true, decimal: true)
              : keyboardType,
          inputFormatters: [
            if (numeric) ...[
              DecimalTextInputFormatter(
                maxEntires: maxEntires,
                maxDecimals: maxDecimals,
              ),
            ],
            if (inputFormatters != null && inputFormatters.isNotEmpty)
              ...inputFormatters
          ],
          onChanged: (value) {
            if (onChanged == null) return;

            final haveDecimals =
                (keyboardType?.decimal ?? numeric) && value.contains(',');

            onChanged(haveDecimals ? value.split(',').join('.') : value);
          },
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
                      shadow: shadow ?? Vars.boxShadow2,
                    );

                final defaultBorder =
                        border ?? const BorderSide(color: Colors.transparent),
                    disabledBorder = borderDisabled ??
                        const BorderSide(color: Colors.transparent),
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
                                  horizontal: Vars.gapMedium,
                                ),
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
                        horizontal: Vars.gapMedium,
                        vertical: Vars.gapMax,
                      ),
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

  static Widget sizedBox({
    double? width,
    double? height,
    bool dense = false,
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
    int? maxLines,
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
        const BorderRadius.all(Radius.circular(Vars.radius15)),
    BorderSide? border,
    BorderSide? borderDisabled,
    BorderSide? borderError,
    BorderSide? borderFocused,
    bool underline = false,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    EdgeInsets? contentPadding = const EdgeInsets.symmetric(
      vertical: Vars.gapMedium,
      horizontal: Vars.gapMedium,
    ),
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
    final expanded = maxLines == null;

    return SizedBox(
      width: width,
      height: height ?? (dense ? Vars.minInputHeight : Vars.maxInputHeight),
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
        maxLines: maxLines,
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
