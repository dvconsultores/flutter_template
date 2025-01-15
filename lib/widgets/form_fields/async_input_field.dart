import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/input_formatters.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/async_text_form_field.dart';
import 'package:flutter_detextre4/utils/painters/decorated_input_border.dart';

class AsyncInputField extends AsyncTextFormField {
  AsyncInputField({
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
    int maxDecimals = Vars.maxDecimals,
    EdgeInsetsGeometry? prefixPadding,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius10)),
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
          keyboardType: buildWidget(() {
            if (!numeric) return keyboardType;

            if (!kIsWeb && Platform.isIOS) {
              return const TextInputType.numberWithOptions(decimal: true);
            }

            return TextInputType.number;
          }),
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
          decoration: buildWidget<InputDecoration>(() {
            final colors = ThemeApp.of(context).colors,
                theme = Theme.of(context);

            final ts = textStyle ?? _ts,
                hs = hintStyle ??
                    ts.copyWith(
                      color: colors.text.withAlpha(179),
                      fontSize: 13,
                    ),
                ls = labelStyle ??
                    ts.copyWith(
                      color: colors.text,
                      fontSize: 13,
                    ),
                fls = floatingLabelStyle ?? ls;

            InputBorder checkBorder(BorderSide border) => DecoratedInputBorder(
                  child: underline
                      ? UnderlineInputBorder(
                          borderSide: border,
                          borderRadius: borderRadius,
                        )
                      : OutlineInputBorder(
                          borderSide: border,
                          borderRadius: borderRadius,
                        ),
                  shadow: shadow ?? Vars.boxShadow2,
                );

            final defaultBorder =
                    border ?? const BorderSide(color: Colors.transparent),
                disabledBorder = borderDisabled ??
                    const BorderSide(color: Colors.transparent),
                errorBorder =
                    borderError ?? BorderSide(color: theme.colorScheme.error),
                focusedBorder =
                    borderFocused ?? BorderSide(color: theme.focusColor);

            return InputDecoration(
              prefixIconConstraints: decoration?.prefixIconConstraints ??
                  BoxConstraints(maxWidth: maxWidthPrefix),
              enabled: decoration?.enabled ?? !disabled,
              counterText: decoration?.counterText ?? counterText,
              hintText: decoration?.hintText ?? hintText,
              hintStyle: decoration?.hintStyle ?? hs,
              labelText: decoration?.labelText ?? labelText,
              labelStyle: decoration?.labelStyle ?? ls,
              floatingLabelStyle: decoration?.floatingLabelStyle ?? fls,
              floatingLabelBehavior:
                  decoration?.floatingLabelBehavior ?? floatingLabelBehavior,
              filled: decoration?.filled ?? filled,
              fillColor: decoration?.fillColor ?? color,
              border: decoration?.border ?? checkBorder(defaultBorder),
              enabledBorder:
                  decoration?.enabledBorder ?? checkBorder(defaultBorder),
              disabledBorder:
                  decoration?.disabledBorder ?? checkBorder(disabledBorder),
              errorBorder: decoration?.errorBorder ?? checkBorder(errorBorder),
              focusedBorder:
                  decoration?.focusedBorder ?? checkBorder(focusedBorder),
              errorMaxLines: decoration?.errorMaxLines ?? errorMaxLines,
              prefix: decoration?.prefix ?? prefix,
              prefixIcon: decoration?.prefixIcon ??
                  (prefixIcon != null
                      ? IntrinsicWidth(
                          child: Padding(
                            padding: prefixPadding ??
                                const EdgeInsets.symmetric(
                                  horizontal: Vars.gapMedium,
                                ),
                            child: prefixIcon,
                          ),
                        )
                      : null),
              suffix: decoration?.suffix ?? suffix,
              suffixIcon: decoration?.suffixIcon ?? suffixIcon,
              suffixIconConstraints:
                  decoration?.suffixIconConstraints ?? suffixIconConstraints,
              isCollapsed: decoration?.isCollapsed ?? isCollapsed,
              isDense: decoration?.isDense ?? true,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: Vars.gapMedium,
                    vertical: Vars.gapMax,
                  ),
              alignLabelWithHint: decoration?.alignLabelWithHint,
              constraints: decoration?.constraints,
              counter: decoration?.counter,
              counterStyle: decoration?.counterStyle,
              error: decoration?.error,
              errorStyle: decoration?.errorStyle,
              errorText: decoration?.errorText,
              floatingLabelAlignment: decoration?.floatingLabelAlignment,
              focusColor: decoration?.focusColor,
              focusedErrorBorder: decoration?.focusedErrorBorder,
              helperMaxLines: decoration?.helperMaxLines,
              helperStyle: decoration?.helperStyle,
              helperText: decoration?.helperText,
              hintFadeDuration: decoration?.hintFadeDuration,
              hintMaxLines: decoration?.hintMaxLines,
              hintTextDirection: decoration?.hintTextDirection,
              hoverColor: decoration?.hoverColor,
              icon: decoration?.icon,
              iconColor: decoration?.iconColor,
              label: decoration?.label,
              prefixIconColor: decoration?.prefixIconColor,
              prefixStyle: decoration?.prefixStyle,
              prefixText: decoration?.prefixText,
              semanticCounterText: decoration?.semanticCounterText,
              suffixIconColor: decoration?.suffixIconColor,
              suffixStyle: decoration?.suffixStyle,
              suffixText: decoration?.suffixText,
            );
          }),
        );
  static final context = ContextUtility.context!,
      _ts = Theme.of(context).textTheme.bodyMedium!;

  static Widget sizedBox({
    Key? key,
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
    Future<String?> Function(String? value)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    EdgeInsetsGeometry? prefixPadding,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius10)),
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
    int maxEntires = 10,
    int maxDecimals = Vars.maxDecimals,
  }) {
    final expanded = maxLines == null;

    return SizedBox(
      key: key,
      width: width,
      height: height ?? (dense ? Vars.minInputHeight : Vars.maxInputHeight),
      child: AsyncInputField(
        onTapOutside: onTapOutside,
        onTap: onTap,
        onChanged: onChanged,
        focusNode: focusNode,
        controller: controller,
        hintText: hintText,
        disabled: disabled,
        expands: expanded,
        keyboardType: buildWidget(() {
          if (!numeric) {
            return expanded && keyboardType == null
                ? TextInputType.text
                : keyboardType;
          }

          if (!kIsWeb && Platform.isIOS) {
            return const TextInputType.numberWithOptions(decimal: true);
          }

          return TextInputType.number;
        }),
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
        maxEntires: maxEntires,
        maxDecimals: maxDecimals,
      ),
    );
  }
}
