import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/error_text.dart';
import 'package:flutter_detextre4/widgets/form_fields/checkbox.dart';
import 'package:flutter_gap/flutter_gap.dart';

class RadioGroupItem<T> {
  const RadioGroupItem({
    this.labelText,
    required this.value,
  });
  final String? labelText;
  final T value;
}

class RadioGroupField<T> extends StatefulWidget {
  const RadioGroupField({
    super.key,
    required this.items,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.initialValue,
    this.disabled = false,
    this.onChanged,
    this.splashRadius = 16,
    this.radioSize,
    this.textStyle,
    this.errorText,
    this.errorStyle,
    this.errorWidth,
    this.radioPadding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.radioGap = Vars.gapMedium,
    this.radioExpanded = false,
    this.radioCrossAxisAlignment = CrossAxisAlignment.center,
    this.radioMainAxisAlignment = MainAxisAlignment.start,
    this.radioBorderRadius = Vars.radius40,
    this.padding = const EdgeInsets.all(0),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.direction = Axis.vertical,
  });
  final List<RadioGroupItem<T>> items;
  final String? restorationId;
  final void Function(T? value)? onSaved;
  final String? Function(T? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<T?>? controller;
  final void Function(T? value)? onChanged;
  final T? initialValue;
  final bool disabled;
  final double splashRadius;
  final double? radioSize;
  final TextStyle? textStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final double? errorWidth;
  final EdgeInsetsGeometry radioPadding;
  final double radioGap;
  final bool radioExpanded;
  final CrossAxisAlignment radioCrossAxisAlignment;
  final MainAxisAlignment radioMainAxisAlignment;
  final double radioBorderRadius;
  final EdgeInsets padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Axis direction;

  @override
  State<RadioGroupField<T>> createState() => _RadioGroupFieldState<T>();
}

class _RadioGroupFieldState<T> extends State<RadioGroupField<T>> {
  FormFieldState<T?>? formState;

  T? getValue(FormFieldState<T?> state) => state.value;

  void onPressed(RadioGroupItem<T> item) {
    formState!.didChange(item.value);
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(item.value);
  }

  void onListen() {
    if (getValue(formState!) == widget.controller!.value) return;

    formState!.didChange(widget.controller!.value);
  }

  @override
  void initState() {
    widget.controller?.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T?>(
      restorationId: widget.restorationId,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: !widget.disabled,
      builder: (state) {
        // set values
        formState ??= state;

        widget.controller?.value = getValue(state);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // field
          Section(
              padding: widget.padding,
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisAlignment: widget.mainAxisAlignment,
              mainAxisSize: widget.mainAxisSize,
              direction: widget.direction,
              children: widget.items.map((item) {
                return CheckboxV2(
                  controller: ValueNotifier(state.value == item.value),
                  onChanged: (_) => onPressed(item),
                  disabled: widget.disabled,
                  splashRadius: widget.splashRadius,
                  size: widget.radioSize,
                  labelText: item.labelText,
                  textStyle: widget.textStyle,
                  errorWidth: widget.errorWidth,
                  padding: widget.radioPadding,
                  gap: widget.radioGap,
                  expanded: widget.radioExpanded,
                  crossAxisAlignment: widget.radioCrossAxisAlignment,
                  mainAxisAlignment: widget.radioMainAxisAlignment,
                  borderRadius: widget.radioBorderRadius,
                );
              }).toList()),

          // error text
          if (state.hasError && (widget.errorText?.isNotEmpty ?? true))
            ErrorText(
              widget.errorText ?? state.errorText ?? '',
              style: widget.errorStyle ??
                  Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
            )
        ]);
      },
    );
  }
}
