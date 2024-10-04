import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/error_text.dart';
import 'package:flutter_detextre4/widgets/form_fields/checkbox.dart';
import 'package:flutter_detextre4/widgets/form_fields/radio_group_field.dart';

enum MultipleRadioGroupMode {
  standard,
  selectAllbackward;
}

class MultipleRadioGroupField<T> extends StatefulWidget {
  const MultipleRadioGroupField({
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
    this.labelBuilder,
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
    this.scrollDirection = Axis.vertical,
    this.scrollable = false,
    this.width,
    this.height,
    this.separatorBuilder,
    this.itemBuilder,
    this.mode = MultipleRadioGroupMode.standard,
  });
  final List<RadioGroupItem<T>> items;
  final String? restorationId;
  final void Function(List<T>? value)? onSaved;
  final String? Function(List<T>? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<List<T>?>? controller;
  final void Function(List<T>? value)? onChanged;
  final List<T>? initialValue;
  final bool disabled;
  final double splashRadius;
  final double? radioSize;
  final Widget Function(BuildContext context, String? itemText)? labelBuilder;
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
  final Axis scrollDirection;
  final bool scrollable;
  final double? width;
  final double? height;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(
    BuildContext context,
    int index,
    bool value,
    void Function(int index) onPressed,
  )? itemBuilder;
  final MultipleRadioGroupMode mode;

  @override
  State<MultipleRadioGroupField<T>> createState() =>
      _MultipleRadioGroupFieldState<T>();
}

class _MultipleRadioGroupFieldState<T>
    extends State<MultipleRadioGroupField<T>> {
  FormFieldState<List<T>?>? formState;

  List<T>? getValue(FormFieldState<List<T>?> state) => state.value;

  void onPressed(int index) {
    final item = widget.items[index], currentState = formState?.value ?? <T>[];

    switch (widget.mode) {
      case MultipleRadioGroupMode.selectAllbackward:
        {
          final stateIndex = currentState.indexOf(item.value);

          if (stateIndex.isNegative) {
            currentState
                .addAll(widget.items.take(index + 1).map((e) => e.value));
          } else {
            currentState.removeRange(stateIndex, currentState.length);
          }
        }
        break;

      default:
        {
          if (!currentState.remove(item.value)) {
            currentState.add(item.value);
          }
        }
    }

    formState!.didChange(currentState);
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(currentState);
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
    return FormField<List<T>?>(
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
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: ListView.separated(
              padding: widget.padding,
              scrollDirection: widget.scrollDirection,
              shrinkWrap: !widget.scrollable,
              physics: widget.scrollable
                  ? null
                  : const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              separatorBuilder: (context, index) =>
                  widget.separatorBuilder != null
                      ? widget.separatorBuilder!(context, index)
                      : const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final item = widget.items[index];

                if (widget.itemBuilder != null) {
                  return widget.itemBuilder!(
                    context,
                    index,
                    state.value?.contains(item.value) ?? false,
                    onPressed,
                  );
                }

                return CheckboxV2(
                  controller:
                      ValueNotifier(state.value?.contains(item.value) ?? false),
                  onChanged: (_) => onPressed(index),
                  disabled: widget.disabled,
                  splashRadius: widget.splashRadius,
                  size: widget.radioSize,
                  label: widget.labelBuilder != null
                      ? widget.labelBuilder!(context, item.labelText)
                      : null,
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
              },
            ),
          ),

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
