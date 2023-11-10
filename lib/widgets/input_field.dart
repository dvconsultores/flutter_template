import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/input_formatters.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.disabled = false,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.maxWidthPrefix = double.infinity,
    this.numeric = false,
    this.inputFormatters,
    this.formatByComma = true,
    this.maxEntires = 4,
    this.maxDecimals = 2,
    this.autovalidateMode,
    this.obscureText,
    this.prefixPadding,
    this.focusNode,
    this.onTap,
    this.onTapOutside,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.borderWidth = 1,
    this.borderColor = Colors.black,
  });
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool disabled;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final double maxWidthPrefix;
  final bool numeric;
  final List<TextInputFormatter>? inputFormatters;
  final bool formatByComma;
  final int maxEntires;
  final int maxDecimals;
  final bool? obscureText;
  final EdgeInsetsGeometry? prefixPadding;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(PointerDownEvent event)? onTapOutside;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black45,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.lato("400"),
    );

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: borderWidth),
      borderRadius: borderRadius,
    );

    return TextFormField(
        onTapOutside: onTapOutside,
        onTap: onTap,
        focusNode: focusNode,
        obscureText: obscureText ?? false,
        controller: controller,
        enabled: !disabled,
        textAlign: textAlign,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(signed: true, decimal: true)
            : keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: autovalidateMode,
        inputFormatters: [
          if (numeric) ...[
            DecimalTextInputFormatter(
              formatByComma: formatByComma,
              maxEntires: maxEntires,
              maxDecimals: maxDecimals,
            ),
          ],
          if (inputFormatters != null && inputFormatters!.isNotEmpty)
            ...inputFormatters!
        ],
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(maxWidth: maxWidthPrefix),
          hintText: hintText,
          hintStyle: textStyle,
          labelText: labelText,
          labelStyle: textStyle,
          filled: true,
          fillColor: ThemeApp.colors(context).tertiary,
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          prefix: prefix,
          prefixIcon: prefixIcon != null
              ? IntrinsicWidth(
                  child: Padding(
                    padding: prefixPadding ??
                        const EdgeInsets.symmetric(horizontal: 10),
                    child: prefixIcon,
                  ),
                )
              : null,
          suffix: suffix,
          suffixIcon: suffixIcon,
        ));
  }

  static InputField textBox({
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    bool disabled = false,
    TextAlign textAlign = TextAlign.start,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    required int maxLines,
    int? maxLength,
    FocusNode? focusNode,
    void Function(String value)? onChanged,
    void Function()? onTap,
    void Function(PointerDownEvent event)? onTapOutside,
  }) =>
      InputField(
        onTapOutside: onTapOutside,
        onTap: onTap,
        onChanged: onChanged,
        focusNode: focusNode,
        controller: controller,
        hintText: hintText,
        disabled: disabled,
        keyboardType: keyboardType,
        labelText: labelText,
        maxLines: maxLines,
        maxLength: maxLength,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textAlign: textAlign,
      );
}
