import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_animated_builder.dart';
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
    this.value,
    this.initialValue,
    this.width = double.maxFinite,
    this.height,
    this.decoration,
    this.leading,
    this.trailing,
    this.dialogTittle,
    this.indicator = false,
    this.disabled = false,
    this.loading = false,
    this.loaderHeight = 20,
    this.maxLenght,
    this.emptyDataMessage,
    this.hideTrailing = false,
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
  });
  final String? restorationId;
  final void Function(List<T>? value)? onSaved;
  final String? Function(List<T>? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final Function(List<T>? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final Color? itemforegroundColor;
  final List<T>? initialValue;
  final ValueNotifier<List<T>>? value;
  final double width;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final String? dialogTittle;
  final bool indicator;
  final bool loading;
  final bool disabled;
  final int? maxLenght;
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

  @override
  State<MultipleSelectField<T>> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultipleSelectField<T>> {
  FormFieldState<List<T>>? formState;
  bool isOpen = false;

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

    setState(() => isOpen = true);

    final items = await BottomSheetListMultiple.showModal(
      context,
      items: widget.items,
      initialItems: selectedItems(),
      labelText: widget.dialogTittle,
      maxLenght: widget.maxLenght,
      emptyDataText: widget.emptyDataMessage,
      itemforegroundColor: widget.itemforegroundColor,
    );

    formState!.didChange(
      items?.map((e) => e.value!).toList() ?? formState!.value,
    );
    isOpen = false;
    setState(() {});

    if (widget.onChanged != null) {
      EasyDebounce.debounce("onChanged", Durations.short4,
          () => widget.onChanged!(formState!.value));
    }
  }

  void initNotifierListener() => widget.value?.addListener(() {
        if (widget.value!.value.isEmpty ||
            formState!.value == widget.value!.value) return;

        formState!.didChange(widget.value!.value);
      });

  @override
  void initState() {
    initNotifierListener();
    super.initState();
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
        widget.value?.value = state.value ?? [];

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
            errorWidget = Text(
              widget.errorText ?? state.errorText ?? '',
              style: widget.errorStyle ??
                  Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
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
                      );

        return SizedBox(
          width: widget.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // field
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: widget.width,
                height: widget.height ??
                    (widget.dense ? Vars.minInputHeight : Vars.maxInputHeight),
                padding: widget.padding,
                decoration: widget.decoration ??
                    BoxDecoration(
                        borderRadius: widget.borderRadius,
                        color: widget.bgColor ??
                            Theme.of(context).colorScheme.background,
                        boxShadow: widget.boxShadow ?? [Vars.boxShadow2],
                        border: Border.fromBorderSide(
                          widget.disabled
                              ? widget.borderDisabled ??
                                  const BorderSide(color: Colors.transparent)
                              : isOpen
                                  ? widget.borderFocused ??
                                      BorderSide(
                                          color: Theme.of(context).focusColor)
                                  : widget.border ??
                                      const BorderSide(
                                          color: Colors.transparent),
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
                      if (!widget.hideTrailing) ...[
                        Gap(widget.gap).row,
                        widget.trailing ??
                            (isOpen
                                ? const Icon(Icons.arrow_drop_up_rounded)
                                : const Icon(Icons.arrow_drop_down_rounded))
                      ]
                    ]),
              ),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.padding.horizontal / 2,
                  ),
                  child: Column(children: [const Gap(8).column, errorWidget]),
                ),
              ),
            ]
          ]),
        );
      },
    );
  }
}
