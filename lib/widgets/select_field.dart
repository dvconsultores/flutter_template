import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class SelectField<T> extends StatefulWidget {
  const SelectField({
    super.key,
    this.value,
    this.textStyle,
    required this.items,
    required this.onChanged,
    this.autovalidateMode,
    this.validator,
    this.focusNode,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.isExpanded = false,
    this.buttonStyleData,
    this.filled = true,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.borderWidth = 1,
    this.borderColor,
    this.disabledBorderColor,
    this.errorBorderColor,
    this.focusedBorderColor,
    this.underline = false,
    this.contentPadding,
    this.prefixPadding,
    this.maxWidthPrefix = double.infinity,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.disabled = false,
    this.onMenuStateChange,
    this.dropdownStyleData,
    this.menuItemStyleData = const MenuItemStyleData(),
    this.shadow,
    this.customButton,
    this.alignment = AlignmentDirectional.centerStart,
  });
  final T? value;
  final TextStyle? textStyle;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T? value)? onChanged;
  final String? Function(T? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool isExpanded;
  final ButtonStyleData? buttonStyleData;
  final bool filled;
  final Color? color;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final Color? errorBorderColor;
  final Color? focusedBorderColor;
  final bool underline;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? prefixPadding;
  final double maxWidthPrefix;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;
  final bool disabled;
  final void Function(bool isOpen)? onMenuStateChange;
  final DropdownStyleData? dropdownStyleData;
  final MenuItemStyleData menuItemStyleData;
  final BoxShadow? shadow;
  final Widget? customButton;
  final AlignmentGeometry alignment;

  static Widget sizedBox<T>({
    double? width,
    double? height,
    T? value,
    TextStyle? textStyle,
    List<DropdownMenuItem<T>>? items,
    void Function(T? value)? onChanged,
    String? Function(T? value)? validator,
    AutovalidateMode? autovalidateMode,
    FocusNode? focusNode,
    String? hintText,
    TextStyle? hintStyle,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.never,
    ButtonStyleData? buttonStyleData,
    bool filled = true,
    Color? color,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(40)),
    double borderWidth = 1,
    Color? borderColor,
    Color? disabledBorderColor,
    Color? errorBorderColor,
    Color? focusedBorderColor,
    bool underline = false,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? prefixPadding,
    double maxWidthPrefix = double.infinity,
    Widget? prefixIcon,
    Widget? prefix,
    Widget? suffixIcon,
    Widget? suffix,
    bool disabled = false,
    void Function(bool isOpen)? onMenuStateChange,
    DropdownStyleData? dropdownStyleData,
    MenuItemStyleData menuItemStyleData = const MenuItemStyleData(),
    BoxShadow? shadow,
    Widget? customButton,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) {
    final expanded = height != null;

    return SizedBox(
      width: width,
      height: height,
      child: SelectField<T>(
        value: value,
        focusNode: focusNode,
        validator: validator,
        autovalidateMode: autovalidateMode,
        textStyle: textStyle,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        floatingLabelStyle: floatingLabelStyle,
        floatingLabelBehavior: floatingLabelBehavior,
        isExpanded: expanded,
        buttonStyleData: ButtonStyleData(
          width: buttonStyleData?.width,
          height:
              buttonStyleData?.height ?? (expanded ? double.maxFinite : null),
          elevation: buttonStyleData?.elevation,
          overlayColor: buttonStyleData?.overlayColor,
          padding: buttonStyleData?.padding,
          decoration: buttonStyleData?.decoration,
        ),
        filled: filled,
        color: color,
        underline: underline,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        borderColor: borderColor,
        disabledBorderColor: disabledBorderColor,
        errorBorderColor: errorBorderColor,
        focusedBorderColor: focusedBorderColor,
        contentPadding: contentPadding,
        prefixPadding: prefixPadding,
        maxWidthPrefix: maxWidthPrefix,
        prefixIcon: prefixIcon,
        prefix: prefix,
        suffixIcon: suffixIcon,
        suffix: suffix,
        disabled: disabled,
        items: items,
        onChanged: onChanged,
        onMenuStateChange: onMenuStateChange,
        dropdownStyleData: dropdownStyleData,
        menuItemStyleData: menuItemStyleData,
        shadow: shadow,
        customButton: customButton,
        alignment: alignment,
      ),
    );
  }

  @override
  State<SelectField<T>> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<SelectField<T>> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final colorSwither = isMenuOpen
        ? ThemeApp.colors(context).primary
        : ThemeApp.colors(context).text;

    final ts = widget.textStyle ??
        TextStyle(
          color: colorSwither,
          fontSize: 12,
          letterSpacing: 3.9,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.lato("700"),
        );

    final hs = widget.hintStyle ??
        ts.copyWith(color: ThemeApp.colors(context).text.withOpacity(.7));
    final ls =
        widget.labelStyle ?? ts.copyWith(color: colorSwither, fontSize: 12);
    final fls = widget.floatingLabelStyle ?? ls;

    InputBorder checkBorder(Color color) => widget.underline
        ? UnderlineInputBorder(
            borderSide: BorderSide(width: widget.borderWidth, color: color),
            borderRadius: widget.borderRadius,
          )
        : OutlineInputBorder(
            borderSide: BorderSide(width: widget.borderWidth, color: color),
            borderRadius: widget.borderRadius,
          );

    final border = widget.borderColor ?? Theme.of(context).colorScheme.outline;
    final disabledBorder =
        widget.disabledBorderColor ?? Theme.of(context).disabledColor;
    final errorBorder =
        widget.errorBorderColor ?? Theme.of(context).colorScheme.error;
    final focusedBorder =
        widget.focusedBorderColor ?? Theme.of(context).focusColor;

    return DropdownButtonFormField2<T>(
      value: widget.value,
      alignment: widget.alignment,
      hint: widget.hintText.hasValue ? Text(widget.hintText!, style: hs) : null,
      isExpanded: widget.isExpanded,
      focusNode: widget.focusNode,
      customButton: widget.customButton,
      buttonStyleData: ButtonStyleData(
        width: widget.buttonStyleData?.width ?? 100,
        height: widget.buttonStyleData?.height,
        elevation: widget.buttonStyleData?.elevation,
        overlayColor: widget.buttonStyleData?.overlayColor,
        padding: widget.buttonStyleData?.padding,
        decoration: widget.buttonStyleData?.decoration,
      ),
      style: ts,
      iconStyleData: IconStyleData(
        iconEnabledColor: colorSwither,
        icon: const Icon(Icons.arrow_drop_down_rounded),
        openMenuIcon: const Icon(Icons.arrow_drop_up_rounded),
      ),
      decoration: InputDecoration(
        enabled: !widget.disabled,
        hintText: widget.hintText,
        hintStyle: hs,
        labelText: widget.labelText,
        labelStyle: ls,
        floatingLabelStyle: fls,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        fillColor: widget.color ?? ThemeApp.colors(context).background,
        filled: widget.filled,
        border: checkBorder(border),
        enabledBorder: checkBorder(border),
        disabledBorder: checkBorder(disabledBorder),
        errorBorder: checkBorder(errorBorder),
        focusedBorder: checkBorder(focusedBorder),
        prefixIconConstraints: BoxConstraints(maxWidth: widget.maxWidthPrefix),
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon != null
            ? IntrinsicWidth(
                child: Padding(
                  padding: widget.prefixPadding ??
                      const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.prefixIcon,
                ),
              )
            : null,
        suffix: widget.suffix,
        suffixIcon: widget.suffixIcon,
        isDense: true,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      dropdownStyleData: DropdownStyleData(
          direction: widget.dropdownStyleData?.direction ??
              DropdownDirection.textDirection,
          elevation: widget.dropdownStyleData?.elevation ?? 8,
          isOverButton: widget.dropdownStyleData?.isOverButton ?? false,
          width: widget.dropdownStyleData?.width,
          maxHeight: widget.dropdownStyleData?.maxHeight ?? 300,
          offset: widget.dropdownStyleData?.offset ?? Offset.zero,
          openInterval: widget.dropdownStyleData?.openInterval ??
              const Interval(0.25, 0.5),
          padding: widget.dropdownStyleData?.padding,
          scrollPadding: widget.dropdownStyleData?.scrollPadding,
          scrollbarTheme: widget.dropdownStyleData?.scrollbarTheme ??
              ScrollbarThemeData(
                thumbColor: MaterialStatePropertyAll(
                    ThemeApp.colors(context).secondary),
              ),
          useRootNavigator: widget.dropdownStyleData?.useRootNavigator ?? false,
          useSafeArea: widget.dropdownStyleData?.useSafeArea ?? true,
          decoration: widget.dropdownStyleData?.decoration ??
              BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                    width: 1, color: ThemeApp.colors(context).primary),
              )),
      menuItemStyleData: widget.menuItemStyleData,
      items: widget.items,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onMenuStateChange: (isOpen) {
        setState(() => isMenuOpen = isOpen);

        if (widget.onMenuStateChange != null) widget.onMenuStateChange!(isOpen);
      },
      onChanged: widget.onChanged,
    );
  }
}
