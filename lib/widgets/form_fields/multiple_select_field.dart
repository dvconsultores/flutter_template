// TODO troubles on selections, give error on select item and accepts

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/error_text.dart';
import 'package:flutter_detextre4/widgets/sheets/bottom_sheet_card.dart';
import 'package:flutter_gap/flutter_gap.dart';

class MultipleSelectField<T> extends StatefulWidget {
  const MultipleSelectField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    required this.items,
    this.itemforegroundColor,
    this.controller,
    this.initialValue,
    this.width = double.maxFinite,
    this.height,
    this.intrinsictWidth = false,
    this.decoration,
    this.leading,
    this.trailing,
    this.dropdownTitle,
    this.indicator = false,
    this.disabled = false,
    this.loading = false,
    this.loaderHeight = 20,
    this.maxLenght,
    this.emptyDataMessage,
    this.hideOpenIcon = false,
    this.hintStyle,
    this.hintText,
    this.textAlignHint,
    this.errorText,
    this.errorStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius15)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.bgColor,
    this.boxShadow,
    this.gap = Vars.gapLow,
    this.padding = const EdgeInsets.symmetric(horizontal: Vars.gapMedium),
    this.dense = false,
    this.dropdownInitialChildSize = .45,
    this.dropdownMaxChildSize = .45,
    this.dropdownMinChildSize = .2,
    this.dropdownTopWidget,
    this.dropdownChildAspectRatio = 20 / 4.8,
  });
  final String? restorationId;
  final void Function(List<T>? value)? onSaved;
  final String? Function(List<T>? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final Function(List<T>? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final Color? itemforegroundColor;
  final List<T>? initialValue;
  final ValueNotifier<List<T>>? controller;
  final double width;
  final double? height;
  final bool intrinsictWidth;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final String? dropdownTitle;
  final bool indicator;
  final bool loading;
  final bool disabled;
  final int? maxLenght;
  final String? emptyDataMessage;
  final bool hideOpenIcon;
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
  final Widget? dropdownTopWidget;
  final double dropdownChildAspectRatio;

  @override
  State<MultipleSelectField<T>> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultipleSelectField<T>>
    with SingleTickerProviderStateMixin {
  FormFieldState<List<T>>? formState;

  late final AnimationController animation;

  final localController = ValueNotifier<List<T>>([]);

  ValueNotifier<List<T>> get getController =>
      widget.controller ?? localController;

  List<T> selectedItems() {
    if (widget.maxLenght == null) return formState!.value ?? [];

    return formState!.value
            ?.slices(widget.maxLenght!)
            .elementAtOrNull(0)
            ?.toList() ??
        [];
  }

  Future<void> onTap() async {
    if (widget.loading) return;

    animation.forward();

    final items = await BottomSheetListMultiple.showModal(
      context,
      items: widget.items,
      initialItems: selectedItems(),
      labelText: widget.dropdownTitle,
      maxLenght: widget.maxLenght,
      emptyDataText: widget.emptyDataMessage,
      itemforegroundColor: widget.itemforegroundColor,
      topWidget: widget.dropdownTopWidget,
      minChildSize: widget.dropdownMinChildSize,
      initialChildSize: widget.dropdownInitialChildSize,
      maxChildSize: widget.dropdownMaxChildSize,
      childAspectRatio: widget.dropdownChildAspectRatio,
    );

    getController.value =
        items?.map((e) => e.value!).toList() ?? formState!.value ?? [];
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
    return FormField<List<T>>(
      restorationId: widget.restorationId,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: !widget.disabled,
      builder: (state) {
        // set values
        formState ??= state;
        if (state.value != null) getController.value = state.value!;

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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Vars.radius10),
                      ),
                      color: ThemeApp.colors(context).primary,
                      minHeight: widget.loaderHeight,
                    ),
                  )
                : state.value.hasNotValue || widget.indicator
                    // hint text
                    ? hintWidget
                    // value
                    : buildWidget(
                        () {
                          final items = selectedItems()
                              .expand((item) => widget.items
                                  .where((element) => element.value == item))
                              .toList();

                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const VerticalDivider(
                              thickness: 2,
                              indent: Vars.gapMedium,
                              endIndent: Vars.gapMedium,
                              width: Vars.gapXLarge,
                            ),
                            itemBuilder: (context, index) =>
                                Center(child: items[index].child),
                          );
                        },
                      ),
            widgetField = SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // field
                    AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          final isOpen = animation.isCompleted;

                          return GestureDetector(
                            onTap: onTap,
                            child: Container(
                              width:
                                  widget.intrinsictWidth ? null : widget.width,
                              height: widget.height ??
                                  (widget.dense
                                      ? Vars.minInputHeight
                                      : Vars.maxInputHeight),
                              padding: widget.padding,
                              decoration: widget.decoration ??
                                  BoxDecoration(
                                      borderRadius: widget.borderRadius,
                                      color: widget.bgColor ??
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
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
                                                        color:
                                                            Colors.transparent),
                                      )),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (widget.leading != null) ...[
                                      widget.leading!,
                                      Gap(widget.gap).row,
                                    ] else if (widget.indicator) ...[
                                      Icon(
                                        Icons.filter_alt_rounded,
                                        size: 16,
                                        color: state.value.hasValue
                                            ? Theme.of(context).focusColor
                                            : null,
                                      ),
                                      Gap(widget.gap).row,
                                    ],
                                    Expanded(child: contentWidget),
                                    if (!widget.hideOpenIcon) ...[
                                      Gap(widget.gap).row,
                                      isOpen
                                          ? const Icon(
                                              Icons.arrow_drop_up_rounded)
                                          : const Icon(
                                              Icons.arrow_drop_down_rounded)
                                    ],
                                    if (widget.trailing != null)
                                      widget.trailing!
                                  ]),
                            ),
                          );
                        }),

                    // error text
                    if (state.hasError &&
                        (widget.errorText?.isNotEmpty ?? true))
                      ErrorText(
                        widget.errorText ?? state.errorText ?? '',
                        style: widget.errorStyle ??
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error),
                      )
                  ]),
            );

        // final render
        return widget.intrinsictWidth
            ? IntrinsicWidth(child: widgetField)
            : widgetField;
      },
    );
  }
}
