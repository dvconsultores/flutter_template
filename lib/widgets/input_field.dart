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
    this.readOnly = false,
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
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.contentPadding,
    this.height,
  });
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool disabled;
  final bool readOnly;
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
  final FloatingLabelBehavior floatingLabelBehavior;
  final EdgeInsets? contentPadding;
  final double? height;

  static InputField textBox({
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
    required int? maxLines,
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
    bool? obscureText,
    EdgeInsetsGeometry? prefixPadding,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(40)),
    double borderWidth = 1,
    Color borderColor = Colors.black,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.never,
    EdgeInsets? contentPadding,
    bool formatByComma = true,
    int maxEntires = 4,
    int maxDecimals = 2,
    double maxWidthPrefix = double.infinity,
    double? height,
  }) =>
      InputField(
        onTapOutside: onTapOutside,
        onTap: onTap,
        onChanged: onChanged,
        focusNode: focusNode,
        controller: controller,
        hintText: hintText,
        disabled: disabled,
        keyboardType: height != null ? TextInputType.multiline : keyboardType,
        labelText: labelText,
        maxLines: maxLines,
        maxLength: maxLength,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textAlign: textAlign,
        autovalidateMode: autovalidateMode,
        borderColor: borderColor,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        contentPadding: contentPadding,
        floatingLabelBehavior: floatingLabelBehavior,
        formatByComma: formatByComma,
        inputFormatters: inputFormatters,
        maxDecimals: maxDecimals,
        maxEntires: maxEntires,
        maxWidthPrefix: maxWidthPrefix,
        numeric: numeric,
        obscureText: obscureText,
        prefix: prefix,
        prefixPadding: prefixPadding,
        readOnly: readOnly,
        suffix: suffix,
        validator: validator,
        height: height,
      );

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.lato("400"),
    );

    final hintStyle = textStyle.copyWith(color: Colors.black, fontSize: 12);

    final labelStyle = textStyle.copyWith(color: Colors.black, fontSize: 12);

    final floatingLabelStyle = labelStyle;

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: borderWidth),
      borderRadius: borderRadius,
    );

    final expanded = height != null;

    return SizedBox(
      height: height,
      child: TextFormField(
          onTapOutside: onTapOutside,
          onTap: onTap,
          focusNode: focusNode,
          obscureText: obscureText ?? false,
          controller: controller,
          enabled: !disabled,
          readOnly: readOnly,
          textAlign: textAlign,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(
                  signed: true, decimal: true)
              : expanded && keyboardType == null
                  ? TextInputType.text
                  : keyboardType,
          maxLines: expanded ? null : maxLines,
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
          style: textStyle,
          expands: expanded,
          decoration: InputDecoration(
            prefixIconConstraints: BoxConstraints(maxWidth: maxWidthPrefix),
            enabled: !disabled,
            hintText: hintText,
            hintStyle: hintStyle,
            labelText: labelText,
            labelStyle: labelStyle,
            floatingLabelStyle: floatingLabelStyle,
            floatingLabelBehavior: floatingLabelBehavior,
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
            isDense: true,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
          )),
    );
  }
}
