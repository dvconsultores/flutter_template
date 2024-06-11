import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/form_fields/input_field.dart';

class TimePickerField extends InputField {
  TimePickerField({
    super.key,
    required super.controller,
    super.validator,
    super.autovalidateMode,
    super.obscureText,
    super.expands,
    super.focusNode,
    VoidCallback? onTap,
    super.onTapOutside,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.textAlign,
    super.onFieldSubmitted,
    super.autocorrect,
    super.autofocus,
    super.labelText,
    super.hintText,
    super.disabled,
    super.prefixIcon,
    super.prefix,
    Widget? suffixIcon,
    super.maxWidthPrefix,
    super.numeric,
    super.inputFormatters,
    super.maxEntires,
    super.maxDecimals,
    super.prefixPadding,
    super.borderRadius,
    super.border,
    super.borderDisabled,
    super.borderError,
    super.borderFocused,
    super.underline,
    super.floatingLabelBehavior,
    super.textStyle,
    super.hintStyle,
    super.labelStyle,
    super.floatingLabelStyle,
    super.filled,
    super.color,
    super.keyboardType,
    super.decoration,
    super.errorMaxLines,
    super.shadow,
    super.counterText,
    super.isCollapsed,
    super.suffixIconConstraints,
    bool toLocal = true,
    required TimeOfDay initialTime,
    Offset? anchorPoint,
    Color? barrierColor,
    bool barrierDismissible = true,
    String? barrierLabel,
    EdgeInsets? contentPadding,
    Widget Function(BuildContext context, Widget? child)? pickerBuilder,
    String? cancelText,
    String? confirmText,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    String? helpText,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    TextInputType? pickerKeyboardType,
    Locale? locale,
    void Function(TimePickerEntryMode timePickerEntryMode)?
        onTimePickerModeChange,
    RouteSettings? routeSettings,
    Icon? switchToCalendarEntryModeIcon,
    Icon? switchToInputEntryModeIcon,
    TextDirection? textDirection,
    bool useRootNavigator = true,
  }) : super(
          readOnly: true,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                vertical: Vars.gapXLarge,
                horizontal: Vars.gapMedium,
              ),
          suffix: IntrinsicWidth(
            child: Transform.translate(
              offset: const Offset(0, 4),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.timer_outlined),
                if (suffixIcon != null) suffixIcon,
              ]),
            ),
          ),
          onTap: () async {
            if (onTap != null) onTap();

            final time = await showTimePicker(
              context: globalNavigatorKey.currentContext!,
              initialTime: initialTime,
              anchorPoint: anchorPoint,
              barrierColor: barrierColor,
              barrierDismissible: barrierDismissible,
              barrierLabel: barrierLabel,
              builder: pickerBuilder,
              cancelText: cancelText,
              confirmText: confirmText,
              errorInvalidText: errorInvalidText,
              helpText: helpText,
              initialEntryMode: initialEntryMode,
              routeSettings: routeSettings,
              useRootNavigator: useRootNavigator,
            );
            unfocus(globalNavigatorKey.currentContext!);
            if (time == null || !globalNavigatorKey.currentContext!.mounted) {
              return;
            }

            controller!.text = time.format(globalNavigatorKey.currentContext!);
          },
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
    bool toLocal = true,
    Offset? anchorPoint,
    Color? barrierColor,
    bool barrierDismissible = true,
    String? barrierLabel,
    Widget Function(BuildContext context, Widget? child)? pickerBuilder,
    String? cancelText,
    String? confirmText,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    String? helpText,
    required TimeOfDay initialTime,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    TextInputType? pickerKeyboardType,
    Locale? locale,
    void Function(TimePickerEntryMode timePickerEntryMode)?
        onTimePickerModeChange,
    RouteSettings? routeSettings,
    Icon? switchToCalendarEntryModeIcon,
    Icon? switchToInputEntryModeIcon,
    TextDirection? textDirection,
    bool useRootNavigator = true,
  }) {
    final expanded = maxLines == null;

    return SizedBox(
      width: width,
      height: height ?? (dense ? Vars.minInputHeight : Vars.maxInputHeight),
      child: TimePickerField(
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
        initialTime: initialTime,
        anchorPoint: anchorPoint,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        pickerBuilder: pickerBuilder,
        cancelText: cancelText,
        confirmText: confirmText,
        errorFormatText: errorFormatText,
        errorInvalidText: errorInvalidText,
        fieldHintText: fieldHintText,
        fieldLabelText: fieldLabelText,
        helpText: helpText,
        initialEntryMode: initialEntryMode,
        pickerKeyboardType: pickerKeyboardType,
        locale: locale,
        onTimePickerModeChange: onTimePickerModeChange,
        routeSettings: routeSettings,
        switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
        switchToInputEntryModeIcon: switchToInputEntryModeIcon,
        textDirection: textDirection,
        useRootNavigator: useRootNavigator,
      ),
    );
  }
}