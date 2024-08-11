// TODO troubles on selections, give error on select item and accepts

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/custom_focus_node.dart';
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
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius10)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.bgColor,
    this.boxShadow,
    this.gap = Vars.gapLow,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.dense = false,
    this.dropdownInitialChildSize = .45,
    this.dropdownMaxChildSize = .45,
    this.dropdownMinChildSize = .2,
    this.dropdownTopWidget,
    this.dropdownChildAspectRatio = 20 / 4.8,
    this.dropdownScrollable = true,
    this.focusNode,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.hideBottomNavigationBarOnFocus = false,
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
  final bool dropdownScrollable;
  final CustomFocusNode? focusNode;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool hideBottomNavigationBarOnFocus;

  @override
  State<MultipleSelectField<T>> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultipleSelectField<T>>
    with SingleTickerProviderStateMixin {
  FormFieldState<List<T>>? formState;

  late final AnimationController labelAnimationController;

  final localController = ValueNotifier<List<T>>([]);
  ValueNotifier<List<T>> get getController =>
      widget.controller ?? localController;

  final _focusNode = CustomFocusNode();
  CustomFocusNode get focusNode => widget.focusNode ?? _focusNode;
  bool get isFocused => focusNode.value;

  List<T> selectedItems() {
    if (widget.maxLenght == null) return formState!.value ?? [];

    return formState!.value
            ?.slices(widget.maxLenght!)
            .elementAtOrNull(0)
            ?.toList() ??
        [];
  }

  void onListenController() {
    if (formState!.value == getController.value) return;

    formState!.didChange(getController.value);

    if (widget.floatingLabelBehavior == FloatingLabelBehavior.auto) {
      getController.value.isNotEmpty
          ? labelAnimationController.forward()
          : labelAnimationController.reverse();
    }

    if (widget.onChanged != null) widget.onChanged!(formState!.value);
  }

  Future<void> onListenFocusNode() async {
    setState(() {});

    if (!isFocused) return;

    final canAnimateLabel =
        widget.floatingLabelBehavior == FloatingLabelBehavior.auto &&
            getController.value.isEmpty;

    if (canAnimateLabel) labelAnimationController.forward();

    final items = await BottomSheetListMultiple.showModal(
      context,
      hideBottomNavigationBar: widget.hideBottomNavigationBarOnFocus,
      items: widget.items,
      scrollable: widget.dropdownScrollable,
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
      draggableFrameBgColor: Colors.transparent,
      draggableFrameColor: ThemeApp.colors(context).label,
    );

    if (canAnimateLabel) labelAnimationController.reverse();

    getController.value =
        items?.map((e) => e.value!).toList() ?? formState!.value ?? [];
    focusNode.unfocus();
  }

  @override
  void initState() {
    getController.addListener(onListenController);
    focusNode.addListener(onListenFocusNode);
    labelAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value:
          widget.floatingLabelBehavior == FloatingLabelBehavior.always ? 1 : 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    getController.removeListener(onListenController);
    localController.dispose();
    focusNode.removeListener(onListenFocusNode);
    labelAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

        final bgColor = widget.bgColor ?? theme.colorScheme.background,
            height = widget.height ??
                (widget.dense ? Vars.minInputHeight : Vars.maxInputHeight);

        final widgetField = SizedBox(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // field
            GestureDetector(
              onTap: () {
                if (widget.loading) return;
                focusNode.focus();
              },
              child: Container(
                width: widget.intrinsictWidth ? null : widget.width,
                height: height,
                padding: widget.padding,
                decoration: widget.decoration ??
                    BoxDecoration(
                        borderRadius: widget.borderRadius,
                        color: widget.bgColor ?? theme.colorScheme.background,
                        boxShadow: widget.boxShadow ?? [Vars.boxShadow2],
                        border: Border.fromBorderSide(
                          widget.disabled
                              ? widget.borderDisabled ??
                                  const BorderSide(color: Colors.transparent)
                              : isFocused
                                  ? widget.borderFocused ??
                                      BorderSide(color: theme.focusColor)
                                  : widget.border ??
                                      const BorderSide(
                                        color: Colors.transparent,
                                      ),
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
                          color: state.value.hasValue ? theme.focusColor : null,
                        ),
                        Gap(widget.gap).row,
                      ],
                      _ContentWidget(
                        height: height,
                        items: widget.items,
                        labelAnimationController: labelAnimationController,
                        bgColor: bgColor,
                        state: state,
                        textAlignHint: widget.textAlignHint,
                        loading: widget.loading,
                        loaderHeight: widget.loaderHeight,
                        labelText: widget.labelText,
                        labelStyle: widget.labelStyle,
                        floatingLabelStyle: widget.floatingLabelStyle,
                        hintText: widget.hintText,
                        hintStyle: widget.hintStyle,
                        indicator: widget.indicator,
                        selectedItems: selectedItems,
                      ),
                      if (!widget.hideOpenIcon) ...[
                        Gap(widget.gap).row,
                        isFocused
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                      if (widget.trailing != null) widget.trailing!
                    ]),
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

class _ContentWidget<T> extends StatelessWidget {
  const _ContentWidget({
    required this.height,
    this.loading = false,
    this.loaderHeight = 20,
    required this.items,
    required this.labelAnimationController,
    required this.bgColor,
    this.hintText,
    this.textAlignHint,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    required this.state,
    required this.indicator,
    required this.selectedItems,
  });
  final double height;
  final bool loading;
  final double loaderHeight;
  final List<DropdownMenuItem<T>> items;
  final AnimationController labelAnimationController;
  final Color bgColor;
  final String? hintText;
  final TextAlign? textAlignHint;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final FormFieldState<List<T>> state;
  final bool indicator;
  final List<T> Function() selectedItems;

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context);

    final hs = hintStyle ??
            TextStyle(
              color: colors.text.withOpacity(.7),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
        ls = labelStyle ?? TextStyle(color: colors.label),
        fls = floatingLabelStyle ?? ls;

    final hintWidget = Align(
      alignment: Alignment.centerLeft,
      child: Text(
        hintText ?? "",
        textAlign: textAlignHint,
        style: hs,
      ),
    );

    return Expanded(
      child: LayoutBuilder(
          builder: (context, constraints) => loading
              // loader
              ? LinearProgressIndicator(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(Vars.radius10)),
                  color: colors.primary,
                  minHeight: loaderHeight,
                )
              : Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  alignment: Alignment.centerLeft,
                  children: [
                      state.value.hasNotValue || indicator
                          // hint text
                          ? hintWidget
                          // value
                          : buildWidget(
                              () {
                                final itemsFiltered = selectedItems()
                                    .expand((item) => items.where(
                                        (element) => element.value == item))
                                    .toList();

                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: itemsFiltered.length,
                                  separatorBuilder: (context, index) =>
                                      const VerticalDivider(
                                    thickness: 1,
                                    indent: Vars.gapNormal,
                                    endIndent: Vars.gapNormal,
                                    width: Vars.gapXLarge,
                                  ),
                                  itemBuilder: (context, index) =>
                                      Center(child: itemsFiltered[index].child),
                                );
                              },
                            ),

                      // labelText
                      if (labelText.hasValue)
                        AnimatedBuilder(
                            animation: labelAnimationController,
                            builder: (context, child) {
                              final scaleAnimation = Tween<double>(
                                    begin: 1,
                                    end: .78,
                                  ).animate(labelAnimationController),
                                  floatingAnimation = Tween<double>(
                                    begin: 0,
                                    end: height / 2 * scaleAnimation.value + 2,
                                  ).animate(labelAnimationController);

                              final isFloating =
                                  labelAnimationController.isCompleted ||
                                      labelAnimationController.isAnimating;

                              return Positioned(
                                  top: -floatingAnimation.value,
                                  left: -constraints.maxWidth * .11,
                                  width:
                                      isFloating ? null : constraints.maxWidth,
                                  child: Transform.scale(
                                      scale: scaleAnimation.value,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        color: isFloating ? null : bgColor,
                                        width: constraints.maxWidth,
                                        height: isFloating
                                            ? null
                                            : constraints.maxHeight,
                                        child: Text(
                                          labelText!,
                                          overflow: TextOverflow.ellipsis,
                                          style: (isFloating ? fls : ls)
                                              .copyWith(
                                                  backgroundColor: bgColor),
                                        ),
                                      )));
                            })
                    ])),
    );
  }
}
