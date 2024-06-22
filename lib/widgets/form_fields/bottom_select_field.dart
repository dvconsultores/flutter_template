import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/error_text.dart';
import 'package:flutter_detextre4/widgets/sheets/bottom_sheet_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class BottomSelectField<T> extends StatefulWidget {
  const BottomSelectField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    required this.items,
    this.controller,
    this.initialValue,
    this.width = double.maxFinite,
    this.height,
    this.decoration,
    this.leading,
    this.trailing,
    this.dialogTittle,
    this.disabled = false,
    this.loading = false,
    this.loaderHeight = 20,
    this.emptyDataMessage,
    this.hideTrailing = false,
    this.hintText,
    this.textAlignHint,
    this.hintStyle,
    this.errorText,
    this.errorStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius10)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.bgColor,
    this.boxShadow,
    this.gap = 5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.dense = false,
    this.dropdownInitialChildSize = .45,
    this.dropdownMaxChildSize = .45,
    this.dropdownMinChildSize = .2,
    this.isExpanded = false,
    this.dropdownScrollable = true,
  });
  final String? restorationId;
  final void Function(T? value)? onSaved;
  final String? Function(T? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final Function(T? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final ValueNotifier<T?>? controller;
  final T? initialValue;
  final double width;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final String? dialogTittle;
  final bool disabled;
  final bool loading;
  final String? emptyDataMessage;
  final bool hideTrailing;
  final String? hintText;
  final TextAlign? textAlignHint;
  final TextStyle? hintStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderFocused;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;
  final double gap;
  final EdgeInsetsGeometry padding;
  final double loaderHeight;
  final bool dense;
  final double dropdownInitialChildSize;
  final double dropdownMaxChildSize;
  final double dropdownMinChildSize;
  final bool isExpanded;
  final bool dropdownScrollable;

  @override
  State<BottomSelectField<T>> createState() => _BottomSelectFieldState<T>();
}

class _BottomSelectFieldState<T> extends State<BottomSelectField<T>>
    with SingleTickerProviderStateMixin {
  FormFieldState<T>? formState;

  late final AnimationController animation;

  final localController = ValueNotifier<T?>(null);

  ValueNotifier<T?> get getController => widget.controller ?? localController;

  Future<void> onTap() async {
    if (widget.loading) return;

    animation.forward();

    final item = await BottomSheetList.showModal<T>(
      context,
      items: widget.items,
      emptyDataText: widget.emptyDataMessage,
      initialChildSize: widget.dropdownInitialChildSize,
      maxChildSize: widget.dropdownMaxChildSize,
      minChildSize: widget.dropdownMinChildSize,
      scrollable: widget.dropdownScrollable,
    );

    getController.value = item?.value ?? formState!.value;
    animation.reverse();
  }

  void onListen() {
    if (formState!.value == getController.value) return;

    formState!.didChange(getController.value);

    if (widget.onChanged != null) widget.onChanged!(formState!.value);
  }

  @override
  void initState() {
    animation = AnimationController(vsync: this, duration: Durations.short1);
    getController.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    getController.removeListener(onListen);
    localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      restorationId: widget.restorationId,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: !widget.disabled,
      builder: (state) {
        // set values
        formState ??= state;
        widget.controller?.value = state.value;

        final hintWidget = Text(
              widget.hintText ?? "",
              textAlign: widget.textAlignHint,
              style: widget.hintStyle ??
                  TextStyle(
                    color: ThemeApp.colors(context).text.withOpacity(.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.lato("400"),
                  ),
            ),
            contentWidget = widget.loading
                ? SizedBox(
                    width: widget.width,
                    child: LinearProgressIndicator(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: ThemeApp.colors(context).primary,
                      minHeight: widget.loaderHeight,
                    ),
                  )
                :
                // value
                widget.items
                        .singleWhereOrNull(
                            (element) => element.value == state.value)
                        ?.child ??
                    // hintText
                    hintWidget;

        return SizedBox(
          width: widget.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // field
            AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final isOpen = animation.isCompleted;

                  return GestureDetector(
                    onTap: onTap,
                    child: Container(
                        width: widget.width,
                        height: widget.height ??
                            (widget.dense
                                ? Vars.minInputHeight
                                : Vars.maxInputHeight),
                        padding: widget.padding,
                        decoration: widget.decoration ??
                            BoxDecoration(
                                borderRadius: widget.borderRadius,
                                color: widget.bgColor ??
                                    Theme.of(context).colorScheme.background,
                                boxShadow:
                                    widget.boxShadow ?? [Vars.boxShadow2],
                                border: Border.fromBorderSide(
                                  widget.disabled
                                      ? widget.borderDisabled ??
                                          const BorderSide(
                                              color: Colors.transparent)
                                      : isOpen
                                          ? widget.borderFocused ??
                                              BorderSide(
                                                  color: Theme.of(context)
                                                      .focusColor)
                                          : widget.border ??
                                              const BorderSide(
                                                  color: Colors.transparent),
                                )),
                        child: Row(children: [
                          if (widget.leading != null) ...[
                            widget.leading!,
                            Gap(widget.gap).row,
                          ],
                          widget.isExpanded
                              ? Expanded(child: contentWidget)
                              : contentWidget,
                          if (!widget.isExpanded) const Spacer(),
                          if (!widget.hideTrailing) ...[
                            Gap(widget.gap).row,
                            widget.trailing ??
                                (isOpen
                                    ? const Icon(Icons.arrow_drop_up_rounded)
                                    : const Icon(Icons.arrow_drop_down_rounded))
                          ]
                        ])),
                  );
                }),

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
          ]),
        );
      },
    );
  }
}
