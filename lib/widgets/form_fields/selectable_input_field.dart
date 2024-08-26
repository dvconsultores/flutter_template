import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/custom_focus_node.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/form_fields/bottom_select_field.dart';
import 'package:flutter_detextre4/widgets/form_fields/input_field.dart';
import 'package:flutter_detextre4/widgets/sheets/bottom_sheet_card.dart';

class SelectableInputField extends StatefulWidget {
  const SelectableInputField({
    super.key,
    this.selectController,
    this.inputController,
    required this.items,
    this.selectWidth = 80,
    this.hintText,
    this.inputFormatters,
    this.autovalidateMode,
    this.keyboardType,
    this.validator,
    this.loading = false,
    this.disabled = false,
    this.onFieldSubmitted,
    this.onTap,
    this.hideSelectable = false,
    this.initialPrefixValue,
  });
  final double selectWidth;
  final ValueNotifier<String?>? selectController;
  final TextEditingController? inputController;
  final List<DropdownMenuItem> items;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool loading;
  final bool disabled;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final bool hideSelectable;
  final String? initialPrefixValue;

  @override
  State<SelectableInputField> createState() => _SelectableInputFieldState();
}

class _SelectableInputFieldState extends State<SelectableInputField> {
  final focusNodePhonePrefix = CustomFocusNode(), focusNodePhone = FocusNode();

  final _selectController = ValueNotifier<String?>(null);

  ValueNotifier<String?> get selectController =>
      widget.selectController ?? _selectController;

  @override
  Widget build(BuildContext context) {
    return InputField(
      prefixPadding: widget.hideSelectable
          ? null
          : const EdgeInsets.only(right: Vars.gapMedium),
      prefixIcon: widget.hideSelectable
          ? null
          : BottomSelectField(
              width: widget.selectWidth,
              controller: selectController,
              focusNode: focusNodePhonePrefix,
              items: widget.items,
              initialValue: widget.initialPrefixValue,
              dropdownScrollable: false,
              dropDownItemBuilder: (context, child) =>
                  BottomDropdownItem(child: child),
              disabled: widget.disabled,
              loading: widget.loading,
              onChanged: (value) {
                setState(() {});
                if (value != null) focusNodePhone.requestFocus();
              },
            ),
      disabled: widget.disabled || widget.loading,
      controller: widget.inputController,
      focusNode: focusNodePhone,
      hintText: widget.hintText,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: () {
        if (!widget.hideSelectable && selectController.value.hasNotValue) {
          focusNodePhone.unfocus();
          focusNodePhonePrefix.focus();
        }

        if (widget.onTap != null) widget.onTap!();
      },
    );
  }
}
