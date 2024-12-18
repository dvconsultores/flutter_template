import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/form_fields/input_field.dart';
import 'package:flutter_gap/flutter_gap.dart';

class DatePickerField extends InputField {
  DatePickerField({
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
    super.suffix,
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
    super.contentPadding,
    bool toLocal = true,
    required DateTime firstDate,
    required DateTime lastDate,
    Offset? anchorPoint,
    Color? barrierColor,
    bool barrierDismissible = true,
    String? barrierLabel,
    String? cancelText,
    String? confirmText,
    DateTime? currentDate,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    String? helpText,
    DateTime? initialDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    TextInputType? pickerKeyboardType,
    Locale? locale,
    void Function(DatePickerEntryMode datePickerEntryMode)?
        onDatePickerModeChange,
    RouteSettings? routeSettings,
    bool Function(DateTime dateTime)? selectableDayPredicate,
    Icon? switchToCalendarEntryModeIcon,
    Icon? switchToInputEntryModeIcon,
    TextDirection? textDirection,
    bool useRootNavigator = true,
    VoidCallback? onTapClear,
    Color? pickerHeaderBackgroundColor,
    Color? pickerHeaderForegroundColor,
    MaterialStateProperty<Color?>? pickerDayForegroundColor,
    Color? pickerBackgroundColor,
    MaterialStateProperty<Color?>? pickerTodayBackgroundColor,
    Color? pickerShadowColor,
    Color? pickerDividerColor,
    MaterialStateProperty<Color?>? pickerDayOverlayColor,
    Color? pickerSurfaceTintColor,
    MaterialStateProperty<Color?>? pickerYearOverlayColor,
    MaterialStateProperty<Color?>? pickerDayBackgroundColor,
    MaterialStateProperty<Color?>? pickerYearBackgroundColor,
    MaterialStateProperty<Color?>? pickerYearForegroundColor,
    MaterialStateProperty<Color?>? pickerTodayForegroundColor,
    Color? pickerRangePickerShadowColor,
    Color? pickerRangePickerBackgroundColor,
    MaterialStateProperty<Color?>? pickerRangeSelectionOverlayColor,
    Color? pickerRangePickerSurfaceTintColor,
    Color? pickerRangeSelectionBackgroundColor,
    Color? pickerRangePickerHeaderBackgroundColor,
    Color? pickerRangePickerHeaderForegroundColor,
    TextStyle? pickerWeekdayStyle,
  }) : super(
          readOnly: true,
          suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: Vars.buttonHeight / 2,
                  child: VerticalDivider(thickness: 1),
                ),
                if (onTapClear != null && controller!.text.isNotEmpty)
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: IconButton(
                        onPressed: onTapClear,
                        padding: const EdgeInsets.all(0),
                        visualDensity: VisualDensity.compact,
                        splashRadius: 30,
                        icon: const Icon(Icons.close),
                      )),
                const Icon(Icons.calendar_month_outlined, size: 24),
                if (suffixIcon != null) suffixIcon,
                Gap(contentPadding?.right ?? Vars.gapMedium).row,
              ]),
          onTap: () async {
            if (onTap != null) onTap();

            final dateTime = await showDatePicker(
              context: ContextUtility.context!,
              builder: (context, child) {
                final theme = Theme.of(context);

                return Theme(
                  data: theme.copyWith(
                    datePickerTheme: theme.datePickerTheme.copyWith(
                      headerBackgroundColor: pickerHeaderBackgroundColor,
                      headerForegroundColor: pickerHeaderForegroundColor,
                      dayForegroundColor: pickerDayForegroundColor,
                      backgroundColor: pickerBackgroundColor,
                      todayBackgroundColor: pickerTodayBackgroundColor,
                      shadowColor: pickerShadowColor,
                      dividerColor: pickerDividerColor,
                      dayOverlayColor: pickerDayOverlayColor,
                      surfaceTintColor: pickerSurfaceTintColor,
                      yearOverlayColor: pickerYearOverlayColor,
                      dayBackgroundColor: pickerDayBackgroundColor,
                      yearBackgroundColor: pickerYearBackgroundColor,
                      yearForegroundColor: pickerYearForegroundColor,
                      todayForegroundColor: pickerTodayForegroundColor,
                      rangePickerShadowColor: pickerRangePickerShadowColor,
                      rangePickerBackgroundColor:
                          pickerRangePickerBackgroundColor,
                      rangeSelectionOverlayColor:
                          pickerRangeSelectionOverlayColor,
                      rangePickerSurfaceTintColor:
                          pickerRangePickerSurfaceTintColor,
                      rangeSelectionBackgroundColor:
                          pickerRangeSelectionBackgroundColor,
                      rangePickerHeaderBackgroundColor:
                          pickerRangePickerHeaderBackgroundColor,
                      rangePickerHeaderForegroundColor:
                          pickerRangePickerHeaderForegroundColor,
                      weekdayStyle: pickerWeekdayStyle,
                    ),
                  ),
                  child: child!,
                );
              },
              firstDate: firstDate,
              lastDate: lastDate,
              anchorPoint: anchorPoint,
              barrierColor: barrierColor,
              barrierDismissible: barrierDismissible,
              barrierLabel: barrierLabel,
              cancelText: cancelText,
              confirmText: confirmText,
              currentDate: currentDate,
              errorFormatText: errorFormatText,
              errorInvalidText: errorInvalidText,
              fieldHintText: fieldHintText,
              fieldLabelText: fieldLabelText,
              helpText: helpText,
              initialDate: initialDate,
              initialDatePickerMode: initialDatePickerMode,
              initialEntryMode: initialEntryMode,
              keyboardType: pickerKeyboardType,
              locale: locale,
              onDatePickerModeChange: onDatePickerModeChange,
              routeSettings: routeSettings,
              selectableDayPredicate: selectableDayPredicate,
              switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
              switchToInputEntryModeIcon: switchToInputEntryModeIcon,
              textDirection: textDirection,
              useRootNavigator: useRootNavigator,
            );
            unfocus(ContextUtility.context!);
            if (dateTime == null) return;

            controller!.text =
                dateTime.formatTime(pattern: 'dd/MM/yyyy', toLocal: toLocal);
          },
        );

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
    String? Function(String? value)? validator,
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
    bool toLocal = true,
    required DateTime firstDate,
    required DateTime lastDate,
    Offset? anchorPoint,
    Color? barrierColor,
    bool barrierDismissible = true,
    String? barrierLabel,
    String? cancelText,
    String? confirmText,
    DateTime? currentDate,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    String? helpText,
    DateTime? initialDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    TextInputType? pickerKeyboardType,
    Locale? locale,
    void Function(DatePickerEntryMode datePickerEntryMode)?
        onDatePickerModeChange,
    RouteSettings? routeSettings,
    bool Function(DateTime dateTime)? selectableDayPredicate,
    Icon? switchToCalendarEntryModeIcon,
    Icon? switchToInputEntryModeIcon,
    TextDirection? textDirection,
    bool useRootNavigator = true,
    VoidCallback? onTapClear,
    Color? pickerHeaderBackgroundColor,
    Color? pickerHeaderForegroundColor,
    MaterialStateProperty<Color?>? pickerDayForegroundColor,
    Color? pickerBackgroundColor,
    MaterialStateProperty<Color?>? pickerTodayBackgroundColor,
    Color? pickerShadowColor,
    Color? pickerDividerColor,
    MaterialStateProperty<Color?>? pickerDayOverlayColor,
    Color? pickerSurfaceTintColor,
    MaterialStateProperty<Color?>? pickerYearOverlayColor,
    MaterialStateProperty<Color?>? pickerDayBackgroundColor,
    MaterialStateProperty<Color?>? pickerYearBackgroundColor,
    MaterialStateProperty<Color?>? pickerYearForegroundColor,
    MaterialStateProperty<Color?>? pickerTodayForegroundColor,
    Color? pickerRangePickerShadowColor,
    Color? pickerRangePickerBackgroundColor,
    MaterialStateProperty<Color?>? pickerRangeSelectionOverlayColor,
    Color? pickerRangePickerSurfaceTintColor,
    Color? pickerRangeSelectionBackgroundColor,
    Color? pickerRangePickerHeaderBackgroundColor,
    Color? pickerRangePickerHeaderForegroundColor,
    TextStyle? pickerWeekdayStyle,
  }) {
    final expanded = maxLines == null;

    return SizedBox(
      key: key,
      width: width,
      height: height ?? (dense ? Vars.minInputHeight : Vars.maxInputHeight),
      child: DatePickerField(
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
        firstDate: firstDate,
        lastDate: lastDate,
        anchorPoint: anchorPoint,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        cancelText: cancelText,
        confirmText: confirmText,
        currentDate: currentDate,
        errorFormatText: errorFormatText,
        errorInvalidText: errorInvalidText,
        fieldHintText: fieldHintText,
        fieldLabelText: fieldLabelText,
        helpText: helpText,
        initialDate: initialDate,
        initialDatePickerMode: initialDatePickerMode,
        initialEntryMode: initialEntryMode,
        pickerKeyboardType: pickerKeyboardType,
        locale: locale,
        onDatePickerModeChange: onDatePickerModeChange,
        routeSettings: routeSettings,
        selectableDayPredicate: selectableDayPredicate,
        switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
        switchToInputEntryModeIcon: switchToInputEntryModeIcon,
        textDirection: textDirection,
        useRootNavigator: useRootNavigator,
        onTapClear: onTapClear,
        pickerHeaderBackgroundColor: pickerHeaderBackgroundColor,
        pickerHeaderForegroundColor: pickerHeaderForegroundColor,
        pickerDayForegroundColor: pickerDayForegroundColor,
        pickerBackgroundColor: pickerBackgroundColor,
        pickerTodayBackgroundColor: pickerTodayBackgroundColor,
        pickerShadowColor: pickerShadowColor,
        pickerDividerColor: pickerDividerColor,
        pickerDayOverlayColor: pickerDayOverlayColor,
        pickerSurfaceTintColor: pickerSurfaceTintColor,
        pickerYearOverlayColor: pickerYearOverlayColor,
        pickerDayBackgroundColor: pickerDayBackgroundColor,
        pickerYearBackgroundColor: pickerYearBackgroundColor,
        pickerYearForegroundColor: pickerYearForegroundColor,
        pickerTodayForegroundColor: pickerTodayForegroundColor,
        pickerRangePickerShadowColor: pickerRangePickerShadowColor,
        pickerRangePickerBackgroundColor: pickerRangePickerBackgroundColor,
        pickerRangeSelectionOverlayColor: pickerRangeSelectionOverlayColor,
        pickerRangePickerSurfaceTintColor: pickerRangePickerSurfaceTintColor,
        pickerRangeSelectionBackgroundColor:
            pickerRangeSelectionBackgroundColor,
        pickerRangePickerHeaderBackgroundColor:
            pickerRangePickerHeaderBackgroundColor,
        pickerRangePickerHeaderForegroundColor:
            pickerRangePickerHeaderForegroundColor,
        pickerWeekdayStyle: pickerWeekdayStyle,
      ),
    );
  }
}
