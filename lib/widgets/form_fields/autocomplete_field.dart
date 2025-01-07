import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/form_fields/input_field.dart';
import 'package:flutter_detextre4/widgets/sheets/card_widget.dart';
import 'package:flutter_gap/flutter_gap.dart';

class AutocompleteField extends StatefulWidget {
  const AutocompleteField({
    super.key,
    this.controller,
    this.initialValue,
    required this.optionsBuilder,
    this.onChanged,
    this.topWidget,
    this.contextualMenuOffset = 10,
    this.contextualMenuPadding = EdgeInsets.zero,
    this.insetHorizontalPadding,
    this.hintText,
    this.autocorrect = true,
    this.autofocus = false,
    this.autovalidateMode,
    this.border,
    this.borderDisabled,
    this.borderError,
    this.borderFocused,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius50)),
    this.color,
    this.contentPadding,
    this.counterText,
    this.decoration,
    this.disabled = false,
    this.errorMaxLines,
    this.expands = false,
    this.filled = true,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.floatingLabelStyle,
    this.hintStyle,
    this.inputFormatters,
    this.isCollapsed = false,
    this.keyboardType,
    this.labelStyle,
    this.labelText,
    this.maxDecimals = Vars.maxDecimals,
    this.maxEntires = 10,
    this.maxLength,
    this.maxLines = 1,
    this.maxWidthPrefix = double.infinity,
    this.minLines,
    this.numeric = false,
    this.obscureText = false,
    this.onTap,
    this.onTapOutside,
    this.prefix,
    this.prefixIcon,
    this.prefixPadding,
    this.readOnly = false,
    this.shadow,
    this.suffix,
    this.suffixIconConstraints,
    this.textAlign = TextAlign.left,
    this.textStyle,
    this.underline = false,
    this.validator,
  });

  final TextEditingController? controller;
  final TextEditingValue? initialValue;
  final FutureOr<Iterable<DropdownMenuItem<String>>> Function(
      TextEditingValue textEditingValue) optionsBuilder;
  final void Function(String? value)? onChanged;
  final Widget? topWidget;
  final double contextualMenuOffset;
  final EdgeInsets contextualMenuPadding;
  final double? insetHorizontalPadding;
  final String? hintText;
  final bool autocorrect;
  final bool autofocus;
  final AutovalidateMode? autovalidateMode;
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderError;
  final BorderSide? borderFocused;
  final BorderRadius borderRadius;
  final Color? color;
  final EdgeInsets? contentPadding;
  final String? counterText;
  final InputDecoration? decoration;
  final bool disabled;
  final int? errorMaxLines;
  final bool expands;
  final bool filled;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextStyle? floatingLabelStyle;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool isCollapsed;
  final TextInputType? keyboardType;
  final TextStyle? labelStyle;
  final String? labelText;
  final int maxDecimals;
  final int maxEntires;
  final int? maxLength;
  final int? maxLines;
  final double maxWidthPrefix;
  final int? minLines;
  final bool numeric;
  final bool obscureText;
  final void Function()? onTap;
  final void Function(PointerDownEvent pointerDownEvent)? onTapOutside;
  final Widget? prefix;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? prefixPadding;
  final bool readOnly;
  final BoxShadow? shadow;
  final Widget? suffix;
  final BoxConstraints? suffixIconConstraints;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final bool underline;
  final String? Function(String? value)? validator;

  @override
  State<AutocompleteField> createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<AutocompleteField> {
  void updateState() => EasyDebounce.debounce(
        "updateState",
        Durations.medium1,
        () => setState(() {}),
      );

  void selectHandler(
    void Function(DropdownMenuItem<String> value) onSelected,
    DropdownMenuItem<String> item,
  ) {
    widget.controller?.text = item.toString();
    onSelected(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<DropdownMenuItem<String>>(
      initialValue: widget.initialValue,
      displayStringForOption: (option) => (option as DropdownMenuItem).value,
      optionsBuilder: widget.optionsBuilder,
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.contextualMenuOffset,
              right: widget.insetHorizontalPadding ??
                  Vars.paddingScaffold.horizontal,
            ),
            child: Material(
              color: Colors.transparent,
              child: CardWidgetV2(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 3,
                ),
                clipBehavior: Clip.hardEdge,
                child: CustomScrollView(shrinkWrap: true, slivers: [
                  if (widget.topWidget != null)
                    SliverToBoxAdapter(child: widget.topWidget),
                  SliverPadding(
                    padding: widget.contextualMenuPadding,
                    sliver: SliverList.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final item = options.toList()[index];

                          return TextButton(
                            style: const ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(
                                Size(double.maxFinite, Vars.buttonHeight),
                              ),
                            ),
                            onPressed: () => selectHandler(onSelected, item),
                            child: item.child,
                          );
                        }),
                  )
                ]),
              ),
            ),
          ),
        );
      },
      onSelected: (option) {
        updateState();
        if (widget.onChanged != null) widget.onChanged!(option.value);
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        widget.controller?.value = textEditingController.value;

        return InputField(
          controller: textEditingController,
          focusNode: focusNode,
          hintText: widget.hintText,
          autocorrect: widget.autocorrect,
          autofocus: widget.autofocus,
          autovalidateMode: widget.autovalidateMode,
          border: widget.border,
          borderDisabled: widget.borderDisabled,
          borderError: widget.borderError,
          borderFocused: widget.borderFocused,
          borderRadius: widget.borderRadius,
          color: widget.color,
          contentPadding: widget.contentPadding,
          counterText: widget.counterText,
          decoration: widget.decoration,
          disabled: widget.disabled,
          errorMaxLines: widget.errorMaxLines,
          expands: widget.expands,
          filled: widget.filled,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          floatingLabelStyle: widget.floatingLabelStyle,
          hintStyle: widget.hintStyle,
          inputFormatters: widget.inputFormatters,
          isCollapsed: widget.isCollapsed,
          keyboardType: widget.keyboardType,
          labelStyle: widget.labelStyle,
          labelText: widget.labelText,
          maxDecimals: widget.maxDecimals,
          maxEntires: widget.maxEntires,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          maxWidthPrefix: widget.maxWidthPrefix,
          minLines: widget.minLines,
          numeric: widget.numeric,
          obscureText: widget.obscureText,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon,
          prefixPadding: widget.prefixPadding,
          readOnly: widget.readOnly,
          shadow: widget.shadow,
          suffix: widget.suffix,
          suffixIconConstraints: widget.suffixIconConstraints,
          textAlign: widget.textAlign,
          textStyle: widget.textStyle,
          underline: widget.underline,
          validator: widget.validator,
          suffixIcon: textEditingController.text.isNotEmpty
              ? ButtonIcon(
                  onPressed: () {
                    textEditingController.clear();
                    setState(() {});
                  },
                  size: 32,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  icon: const Icon(Icons.close_rounded),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Gap(32),
                ),
          onChanged: (value) => updateState(),
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }
}
