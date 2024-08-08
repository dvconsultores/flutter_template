import 'package:flutter_detextre4/models/country_model.dart';
import 'package:flutter_detextre4/utils/helper_widgets/validator_field.dart';
import 'package:flutter_detextre4/widgets/form_fields/selectable_input_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.phonePrefix,
    required this.phone,
    required this.phoneList,
    this.mask,
    this.onFieldSubmitted,
    this.onTap,
  });
  final ValueNotifier<String?> phonePrefix;
  final TextEditingController phone;
  final List<CountryModel> phoneList;
  final String? mask;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final maskFormatter = MaskTextInputFormatter(
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  CountryModel? get currentCountry => widget.phoneList.singleWhereOrNull(
        (element) => element.prefix == widget.phonePrefix.value,
      );

  @override
  Widget build(BuildContext context) {
    widget.phone.value = maskFormatter.updateMask(
      mask: widget.mask ??
          '(${"#" * (currentCountry?.lengthAreaCode ?? 0)}) ${"#" * ((currentCountry?.length ?? 0) - (currentCountry?.lengthAreaCode ?? 0))}',
    );

    return SelectableInputField(
      selectWidth: (widget.phonePrefix.value?.length ?? 0) > 3 ? 110 : 100,
      inputController: widget.phone,
      selectController: widget.phonePrefix,
      items: widget.phoneList
          .map((e) => DropdownMenuItem(
                value: e.prefix,
                child: Text(
                  '${e.flag} ${e.prefix}',
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      hintText: "(123) 1234567",
      inputFormatters: [maskFormatter],
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
