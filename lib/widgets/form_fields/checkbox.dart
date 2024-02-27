import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_animated_builder.dart';
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
      horizontal: Variables.gapMedium,
      vertical: Variables.gapMedium,
    ),
    this.gap = Variables.gapMedium,
    this.expanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.borderRadius = Variables.radius40,
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
  State<CheckboxField> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<CheckboxField> {
  FormFieldState<bool>? formState;

  bool getValue(FormFieldState<bool> state) => state.value ?? false;

  void onPressed() {
    formState!.didChange(!getValue(formState!));
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(getValue(formState!));
  }

  void initNotifierListener() => widget.controller?.addListener(() {
        if (getValue(formState!) == widget.controller!.value) return;

        formState!.didChange(widget.controller!.value);
      });

  @override
  void initState() {
    initNotifierListener();
    super.initState();
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

        final labelWidget = widget.label ?? Text(widget.labelText ?? ''),
            errorWidget = Text(
              widget.errorText ?? state.errorText ?? '',
              style: widget.errorStyle ??
                  Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
            );

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
                  ThemeApp.colors(context).secondary.withOpacity(.3)),
              foregroundColor: MaterialStatePropertyAll(
                  widget.textStyle?.color ?? ThemeApp.colors(context).text),
            ),
            child: Row(
                crossAxisAlignment: widget.crossAxisAlignment,
                mainAxisAlignment: widget.mainAxisAlignment,
                children: [
                  SizedBox(
                    width: widget.size != null ? widget.size! * 2 : null,
                    height: widget.size != null ? widget.size! * 2 : null,
                    child: Material(
                        elevation: 7,
                        shadowColor: ThemeApp.colors(context).secondary,
                        shape: const CircleBorder(),
                        child: Checkbox(
                          value: getValue(state),
                          onChanged: null,
                          side: BorderSide.none,
                          splashRadius: widget.splashRadius,
                          fillColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          checkColor: ThemeApp.colors(context).secondary,
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
          if (state.hasError && (widget.errorText?.isNotEmpty ?? true)) ...[
            SingleAnimatedBuilder(
              animationSettings: CustomAnimationSettings(
                duration: Durations.short4,
              ),
              builder: (context, child, parent) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -.2),
                    end: const Offset(0, 0),
                  ).animate(parent),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(parent),
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: widget.errorWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.padding.horizontal / 2),
                  child: Column(children: [const Gap(8).column, errorWidget]),
                ),
              ),
            ),
          ]
        ]);
      },
    );
  }
}
