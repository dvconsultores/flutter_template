import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/Variables.dart';

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
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius15)),
    this.border,
    this.borderDisabled,
    this.borderError,
    this.borderFocused,
    this.iconEnabledColor,
    this.underline = false,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapLarge,
    ),
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
    this.boxShadow,
    this.customButton,
    this.alignment = AlignmentDirectional.centerStart,
    this.loading = false,
    this.loaderHeight = 20,
    this.openedIcon,
    this.closedIcon,
  });
  static final _context = globalNavigatorKey.currentContext!;

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
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderError;
  final BorderSide? borderFocused;
  final Color? iconEnabledColor;
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
  final List<BoxShadow>? boxShadow;
  final Widget? customButton;
  final AlignmentGeometry alignment;
  final bool loading;
  final double loaderHeight;
  final Widget? openedIcon;
  final Widget? closedIcon;

  static SelectField<T> variant<T>({
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
    bool isExpanded = true,
    ButtonStyleData? buttonStyleData,
    bool filled = true,
    Color? color,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius15)),
    BorderSide? border,
    BorderSide? borderDisabled,
    BorderSide? borderError,
    BorderSide? borderFocused,
    Color? iconEnabledColor,
    bool underline = false,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapLarge,
    ),
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
    List<BoxShadow>? boxShadow,
    Widget? customButton,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    bool loading = false,
    double loaderHeight = 20,
    Widget? openedIcon,
    Widget? closedIcon,
  }) =>
      SelectField<T>(
        value: value,
        textStyle: textStyle,
        items: items,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        validator: validator,
        focusNode: focusNode,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        floatingLabelStyle: floatingLabelStyle,
        floatingLabelBehavior: floatingLabelBehavior,
        isExpanded: isExpanded,
        buttonStyleData: buttonStyleData,
        filled: filled,
        color: color,
        iconEnabledColor: iconEnabledColor,
        borderRadius: borderRadius,
        border: border ?? BorderSide(color: ThemeApp.colors(_context).primary),
        borderDisabled: borderDisabled,
        borderError: borderError,
        borderFocused: borderFocused,
        underline: underline,
        contentPadding: contentPadding,
        prefixPadding: prefixPadding,
        maxWidthPrefix: maxWidthPrefix,
        prefixIcon: prefixIcon,
        prefix: prefix,
        suffixIcon: suffixIcon,
        suffix: suffix,
        disabled: disabled,
        onMenuStateChange: onMenuStateChange,
        dropdownStyleData: dropdownStyleData,
        menuItemStyleData: menuItemStyleData,
        boxShadow: boxShadow,
        customButton: customButton,
        alignment: alignment,
        loading: loading,
        loaderHeight: loaderHeight,
        openedIcon: openedIcon,
        closedIcon: closedIcon,
      );

  static Widget sizedBox<T>({
    double? width,
    double? height,
    bool dense = false,
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
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius15)),
    BorderSide? border,
    BorderSide? borderDisabled,
    BorderSide? borderError,
    BorderSide? borderFocused,
    Color? iconEnabledColor,
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
    List<BoxShadow>? boxShadow,
    Widget? customButton,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    bool loading = false,
    double loaderHeight = 20,
    Widget? openedIcon,
    Widget? closedIcon,
  }) {
    return SizedBox(
      width: width,
      height: height ?? (dense ? Vars.minInputHeight : Vars.maxInputHeight),
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
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          width: buttonStyleData?.width,
          height: buttonStyleData?.height ?? double.maxFinite,
          elevation: buttonStyleData?.elevation,
          overlayColor: buttonStyleData?.overlayColor,
          padding: buttonStyleData?.padding,
          decoration: buttonStyleData?.decoration,
        ),
        filled: filled,
        color: color,
        iconEnabledColor: iconEnabledColor,
        underline: underline,
        borderRadius: borderRadius,
        border: border,
        borderDisabled: borderDisabled,
        borderError: borderError,
        borderFocused: borderFocused,
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
        boxShadow: boxShadow,
        customButton: customButton,
        alignment: alignment,
        loading: loading,
        loaderHeight: loaderHeight,
        openedIcon: openedIcon,
        closedIcon: closedIcon,
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
            : ThemeApp.colors(context).text,
        ts = widget.textStyle ?? Theme.of(context).textTheme.bodyMedium!,
        hs = widget.hintStyle ??
            ts.copyWith(
              color: ThemeApp.colors(context).text.withOpacity(.7),
              fontFamily: FontFamily.lato("400"),
              fontWeight: FontWeight.w400,
            ),
        ls =
            widget.labelStyle ?? ts.copyWith(color: colorSwither, fontSize: 12),
        fls = widget.floatingLabelStyle ?? ls;

    InputBorder checkBorder(BorderSide border) => widget.underline
        ? UnderlineInputBorder(
            borderSide: border, borderRadius: widget.borderRadius)
        : OutlineInputBorder(
            borderSide: border, borderRadius: widget.borderRadius);

    final defaultBorder =
            widget.border ?? const BorderSide(color: Colors.transparent),
        disabledBorder = widget.borderDisabled ??
            const BorderSide(color: Colors.transparent),
        errorBorder = widget.borderError ??
            BorderSide(color: Theme.of(context).colorScheme.error),
        focusedBorder = widget.borderFocused ??
            BorderSide(color: Theme.of(context).focusColor);

    return IgnorePointer(
      ignoring: widget.loading || widget.disabled,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: widget.boxShadow ?? [Vars.boxShadow2],
          borderRadius: widget.borderRadius,
        ),
        child: DropdownButtonFormField2<T>(
          value: widget.value,
          alignment: widget.alignment,
          hint: widget.hintText.hasValue
              ? Text(widget.hintText!, style: hs)
              : null,
          isExpanded: widget.isExpanded,
          focusNode: widget.focusNode,
          customButton: widget.loading
              ? LinearProgressIndicator(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(Vars.radius10)),
                  color: ThemeApp.colors(context).primary,
                  minHeight: widget.loaderHeight,
                )
              : widget.customButton,
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
            iconEnabledColor: widget.iconEnabledColor ?? colorSwither,
            icon:
                widget.openedIcon ?? const Icon(Icons.arrow_drop_down_rounded),
            openMenuIcon:
                widget.closedIcon ?? const Icon(Icons.arrow_drop_up_rounded),
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
            border: checkBorder(defaultBorder),
            enabledBorder: checkBorder(defaultBorder),
            disabledBorder: checkBorder(disabledBorder),
            errorBorder: checkBorder(errorBorder),
            focusedBorder: checkBorder(focusedBorder),
            prefixIconConstraints:
                BoxConstraints(maxWidth: widget.maxWidthPrefix),
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon != null
                ? IntrinsicWidth(
                    child: Padding(
                      padding: widget.prefixPadding ??
                          const EdgeInsets.symmetric(
                            horizontal: Vars.gapMedium,
                          ),
                      child: widget.prefixIcon,
                    ),
                  )
                : null,
            suffix: widget.suffix,
            suffixIcon: widget.suffixIcon,
            isDense: true,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: Vars.gapMedium,
                  vertical: Vars.gapMedium,
                ),
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
              useRootNavigator:
                  widget.dropdownStyleData?.useRootNavigator ?? false,
              useSafeArea: widget.dropdownStyleData?.useSafeArea ?? true,
              decoration: widget.dropdownStyleData?.decoration ??
                  BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Vars.radius10)),
                    border: Border.all(color: ThemeApp.colors(context).primary),
                  )),
          menuItemStyleData: widget.menuItemStyleData,
          items: widget.items,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          onMenuStateChange: (isOpen) {
            setState(() => isMenuOpen = isOpen);

            if (widget.onMenuStateChange != null) {
              widget.onMenuStateChange!(isOpen);
            }
          },
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
