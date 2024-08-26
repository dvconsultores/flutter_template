import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/models/country_model.dart';
import 'package:flutter_detextre4/utils/general/input_formatters.dart';
import 'package:flutter_detextre4/utils/helper_widgets/validator_field.dart';
import 'package:flutter_detextre4/widgets/form_fields/selectable_input_field.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    this.phonePrefix,
    required this.phone,
    this.phoneList,
    this.mask,
    this.length,
    this.lengthAreaCode,
    this.loading = false,
    this.disabled = false,
    this.onFieldSubmitted,
    this.onTap,
    this.initialPrefixValue,
    this.dropdownBottomWidget,
    this.dropdownInitialChildSize = 0.8,
    this.dropdownMaxChildSize = 0.8,
    this.dropdownMinChildSize = 0.2,
    this.dropdownSearchFunction,
    this.dropdownSearchHintText,
    this.dropdownSearchLabelText,
    this.dropdownTitle,
    this.dropdownTitleStyle,
    this.dropdownTitleText,
  });
  final ValueNotifier<String?>? phonePrefix;
  final TextEditingController phone;
  final List<CountryModel>? phoneList;
  final String? mask;
  final int? length;
  final int? lengthAreaCode;
  final bool loading;
  final bool disabled;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final String? initialPrefixValue;
  final Widget? dropdownBottomWidget;
  final double dropdownInitialChildSize;
  final double dropdownMaxChildSize;
  final double dropdownMinChildSize;
  final bool Function(int index, String search)? dropdownSearchFunction;
  final String? dropdownSearchHintText;
  final String? dropdownSearchLabelText;
  final Widget? dropdownTitle;
  final TextStyle? dropdownTitleStyle;
  final String? dropdownTitleText;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final maskFormatter = MaskPhoneInputFormatter();

  CountryModel? get currentCountry => widget.phoneList?.singleWhereOrNull(
        (element) => element.prefix == widget.phonePrefix?.value,
      );

  @override
  Widget build(BuildContext context) {
    final lengthAreaCode = widget.lengthAreaCode ??
        currentCountry?.lengthAreaCode ??
        maskFormatter.lengthAreaCode!;

    final startsWithCero = RegExp(r'^\(0').hasMatch(widget.phone.text);

    widget.phone.value = maskFormatter.updateMask(
      newValue: widget.phone.value.copyWith(text: widget.phone.text),
      mask: widget.mask ??
          MaskPhoneInputFormatter.getPhoneMask(
            lengthDigits: widget.length ?? currentCountry?.length,
            lengthAreaCode:
                startsWithCero && lengthAreaCode == 3 ? 4 : lengthAreaCode,
          ),
    );

    return SelectableInputField(
      selectWidth: (widget.phonePrefix?.value?.length ?? 0) > 3 ? 110 : 100,
      inputController: widget.phone,
      selectController: widget.phonePrefix,
      loading: widget.loading,
      disabled: widget.disabled,
      initialPrefixValue: widget.initialPrefixValue,
      hideSelectable: widget.phoneList == null,
      items: widget.phoneList
              ?.map((e) => DropdownMenuItem(
                    value: e.prefix,
                    child: Text(
                      '${e.flag} ${e.prefix}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList() ??
          [],
      hintText: "(123) 1234567",
      inputFormatters: [maskFormatter],
      dropdownBottomWidget: widget.dropdownBottomWidget,
      dropdownInitialChildSize: widget.dropdownInitialChildSize,
      dropdownMaxChildSize: widget.dropdownMaxChildSize,
      dropdownMinChildSize: widget.dropdownMinChildSize,
      dropdownSearchFunction: widget.dropdownSearchFunction,
      dropdownSearchHintText: widget.dropdownSearchHintText,
      dropdownSearchLabelText: widget.dropdownSearchLabelText,
      dropdownTitle: widget.dropdownTitle,
      dropdownTitleStyle: widget.dropdownTitleStyle,
      dropdownTitleText: widget.dropdownTitleText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.phone,
      validator: (value) => ValidatorField.evaluate(
        value,
        (instance) =>
            [() => instance.isValidPhoneNumber(maskFormatter.getMask())],
      ),
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: widget.onTap,
    );
  }
}
