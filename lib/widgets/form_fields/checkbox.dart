import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/error_text.dart';
import 'package:flutter_gap/flutter_gap.dart';

class CheckboxField extends StatefulWidget {
  const CheckboxField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.initialValue,
    this.disabled = false,
    this.onChanged,
    this.splashRadius = 16,
    this.size,
    this.label,
    this.labelText,
    this.textStyle,
    this.errorText,
    this.errorStyle,
    this.errorWidth,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.gap = Vars.gapMedium,
    this.expanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.borderRadius = Vars.radius40,
  });
  final String? restorationId;
  final void Function(bool? value)? onSaved;
  final String? Function(bool? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<bool>? controller;
  final void Function(bool? value)? onChanged;
  final bool? initialValue;
  final bool disabled;
  final double splashRadius;
  final double? size;
  final Widget? label;
  final String? labelText;
  final TextStyle? textStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final double? errorWidth;
  final EdgeInsetsGeometry padding;
  final double gap;
  final bool expanded;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double borderRadius;

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  FormFieldState<bool>? formState;

  bool getValue(FormFieldState<bool> state) => state.value ?? false;

  void onPressed() {
    formState!.didChange(!getValue(formState!));
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(getValue(formState!));
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
    return FormField(
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

        final labelWidget = widget.label ?? Text(widget.labelText ?? '');

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // field
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              padding: MaterialStatePropertyAll(widget.padding),
              textStyle: MaterialStatePropertyAll(
                  widget.textStyle ?? const TextStyle(fontSize: 12)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius)),
              )),
              overlayColor: MaterialStatePropertyAll(
                  ThemeApp.of(context).colors.secondary.withOpacity(.3)),
              foregroundColor: MaterialStatePropertyAll(
                  widget.textStyle?.color ?? ThemeApp.of(context).colors.text),
            ),
            child: Row(
                crossAxisAlignment: widget.crossAxisAlignment,
                mainAxisAlignment: widget.mainAxisAlignment,
                children: [
                  SizedBox(
                    width: widget.size != null ? widget.size! * 2 : null,
                    height: widget.size != null ? widget.size! * 2 : null,
                    child: Material(
                        elevation: 3,
                        shadowColor: ThemeApp.of(context).colors.secondary,
                        shape: const CircleBorder(),
                        child: Checkbox(
                          value: getValue(state),
                          onChanged: null,
                          side: BorderSide.none,
                          splashRadius: widget.splashRadius,
                          fillColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          checkColor: ThemeApp.of(context).colors.secondary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )),
                  ),
                  if (widget.label != null || widget.labelText != null) ...[
                    Gap(widget.gap).row,
                    widget.expanded
                        ? Expanded(child: labelWidget)
                        : labelWidget,
                  ]
                ]),
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

/// version without formState
class CheckboxV2 extends StatefulWidget {
  const CheckboxV2({
    super.key,
    this.controller,
    this.disabled = false,
    this.onChanged,
    this.splashRadius = 16,
    this.size,
    this.label,
    this.labelText,
    this.textStyle,
    this.errorWidth,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.gap = Vars.gapMedium,
    this.expanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.borderRadius = Vars.radius40,
  });
  final ValueNotifier<bool>? controller;
  final void Function(bool? value)? onChanged;
  final bool disabled;
  final double splashRadius;
  final double? size;
  final Widget? label;
  final String? labelText;
  final TextStyle? textStyle;
  final double? errorWidth;
  final EdgeInsetsGeometry padding;
  final double gap;
  final bool expanded;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double borderRadius;

  @override
  State<CheckboxV2> createState() => _CheckboxFieldV2State();
}

class _CheckboxFieldV2State extends State<CheckboxV2> {
  bool get getValue => widget.controller?.value ?? false;

  void onPressed() {
    widget.controller?.value = !getValue;
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(getValue);
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = widget.label ?? Text(widget.labelText ?? '');

    return TextButton(
      onPressed: widget.disabled ? null : onPressed,
      style: ButtonStyle(
        padding: MaterialStatePropertyAll(widget.padding),
        textStyle: MaterialStatePropertyAll(
            widget.textStyle ?? const TextStyle(fontSize: 12)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        )),
        overlayColor: MaterialStatePropertyAll(
            ThemeApp.of(context).colors.secondary.withOpacity(.3)),
        foregroundColor: MaterialStatePropertyAll(
            widget.textStyle?.color ?? ThemeApp.of(context).colors.text),
      ),
      child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          children: [
            SizedBox(
              width: widget.size != null ? widget.size! * 2 : null,
              height: widget.size != null ? widget.size! * 2 : null,
              child: Material(
                  elevation: 3,
                  shadowColor: ThemeApp.of(context).colors.secondary,
                  shape: const CircleBorder(),
                  child: Checkbox(
                    value: getValue,
                    onChanged: null,
                    side: BorderSide.none,
                    splashRadius: widget.splashRadius,
                    fillColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    checkColor: ThemeApp.of(context).colors.secondary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )),
            ),
            if (widget.label != null || widget.labelText != null) ...[
              Gap(widget.gap).row,
              widget.expanded ? Expanded(child: labelWidget) : labelWidget,
            ]
          ]),
    );
  }
}
