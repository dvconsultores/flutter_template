import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/sheets/bottom_sheet_card.dart';

class BottomSelectField<T> extends StatefulWidget {
  const BottomSelectField({
    super.key,
    this.onChanged,
    required this.items,
    this.placeholder,
    this.disabledMessage,
    this.clearValue = false,
    this.value,
    this.initialValue,
    this.width = 100,
    this.height,
    this.decoration,
    this.leading,
    this.trailing,
    this.visualDensity,
    this.dialogTittle,
    this.textAlignPlaceHolder,
    this.loading = false,
    this.loaderHeight = 20,
    this.disabled = false,
    this.emptyDataMessage,
    this.hideTrailing = false,
    this.placeholderSize,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(Variables.radius15)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.bgColor,
    this.boxShadow,
    this.gap = 5,
    this.padding = const EdgeInsets.symmetric(horizontal: Variables.gapMedium),
    this.dense = true,
  });
  final Function(T? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String? placeholder;
  final String? disabledMessage;
  final bool clearValue;
  final ValueNotifier<T?>? value;
  final T? initialValue;
  final double width;
  final double? height;
  final VisualDensity? visualDensity;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final String? dialogTittle;
  final TextAlign? textAlignPlaceHolder;
  final bool loading;
  final bool disabled;
  final String? emptyDataMessage;
  final bool hideTrailing;
  final double? placeholderSize;
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

  @override
  State<BottomSelectField> createState() => _BottomSelectFieldState<T>();
}

class _BottomSelectFieldState<T> extends State<BottomSelectField<T>> {
  bool isOpen = false;

  final localValue = ValueNotifier<T?>(null);

  ValueNotifier<T?> get getValue => widget.value ?? localValue;

  @override
  void initState() {
    if (widget.initialValue != null) getValue.value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration ??
          BoxDecoration(
              borderRadius: widget.borderRadius,
              color: widget.bgColor ?? Theme.of(context).colorScheme.background,
              boxShadow: widget.boxShadow ?? [Variables.boxShadow2],
              border: Border.fromBorderSide(
                widget.disabled
                    ? widget.borderDisabled ??
                        BorderSide(color: Theme.of(context).disabledColor)
                    : isOpen
                        ? widget.borderFocused ??
                            BorderSide(color: Theme.of(context).focusColor)
                        : widget.border ??
                            BorderSide(
                                color: Theme.of(context).colorScheme.outline),
              )),
      child: ListTile(
        minLeadingWidth: 20,
        leading: widget.loading ? null : widget.leading,
        horizontalTitleGap: widget.gap,
        minVerticalPadding: 0,
        contentPadding: widget.padding,
        visualDensity: widget.visualDensity,
        dense: widget.dense,
        title: widget.loading
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
                        (element) => element.value == getValue.value)
                    ?.child ??
                // placeholder
                Text(
                  widget.placeholder ?? "",
                  textAlign: widget.textAlignPlaceHolder,
                  style: TextStyle(fontSize: widget.placeholderSize),
                ),
        iconColor:
            getValue.value != null ? ThemeApp.colors(context).primary : null,
        trailing: widget.hideTrailing
            ? null
            : widget.trailing ??
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                        angle: isOpen ? 22 : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        )),
                  ],
                ),
        onTap: () async {
          if (widget.disabledMessage != null) {
            return widget.disabledMessage!.isEmpty
                ? null
                : showSnackbar(widget.disabledMessage!,
                    type: SnackbarType.error);
          }
          if (widget.disabled || widget.loading) return;

          setState(() => isOpen = true);

          await BottomSheetList.showModal<T>(
            context,
            items: widget.items,
            emptyDataText: widget.emptyDataMessage,
            onTap: (item) {
              getValue.value = item.value;
              if (widget.onChanged != null) widget.onChanged!(getValue.value);
            },
          );

          setState(() => isOpen = false);
        },
      ),
    );
  }
}
