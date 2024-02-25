import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/sheets/bottom_sheet_card.dart';

class MultipleSelectField<T> extends StatefulWidget {
  const MultipleSelectField({
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
    this.indicator = false,
    this.loading = false,
    this.loaderHeight = 20,
    this.disabled = false,
    this.maxLenght,
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
    this.gap = Variables.gapLow,
    this.padding = const EdgeInsets.symmetric(horizontal: Variables.gapMedium),
    this.dense = true,
  });
  final Function(List<T>? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String? placeholder;
  final String? disabledMessage;
  final bool clearValue;
  final List<T>? initialValue;
  final List<T>? value;
  final double width;
  final double? height;
  final VisualDensity? visualDensity;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final String? dialogTittle;
  final TextAlign? textAlignPlaceHolder;
  final bool indicator;
  final bool loading;
  final bool disabled;
  final int? maxLenght;
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
  State<MultipleSelectField> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultipleSelectField<T>> {
  bool isOpen = false;

  List<T> get getValue => widget.value ?? <T>[];

  @override
  void initState() {
    if (widget.initialValue != null && getValue.isEmpty) {
      widget.value!.addAll(widget.initialValue!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<T> selectedItems() {
      if (widget.maxLenght == null) return getValue;

      return getValue.slices(widget.maxLenght!).elementAtOrNull(0)?.toList() ??
          [];
    }

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
            : getValue.isEmpty || widget.indicator
                // placeholder
                ? Text(
                    widget.placeholder ?? "",
                    textAlign: widget.textAlignPlaceHolder,
                    style: TextStyle(fontSize: widget.placeholderSize),
                  )
                // value
                : Wrap(
                    spacing: 7,
                    children: selectedItems()
                        .expand((item) => widget.items
                            .where((element) => element.value == item))
                        .map((e) => e.child)
                        .toList(),
                  ),
        iconColor: getValue.isNotEmpty && widget.indicator
            ? ThemeApp.colors(context).primary
            : null,
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

          await BottomSheetListMultiple.showModal(
            context,
            items: widget.items,
            initialItems: selectedItems(),
            labelText: widget.dialogTittle,
            maxLenght: widget.maxLenght,
            emptyDataText: widget.emptyDataMessage,
            onComplete: (items) {
              getValue.clear();
              getValue.addAll(items.map((e) => e.value!).toList());
              if (widget.onChanged != null) widget.onChanged!(getValue);
            },
          );

          setState(() => isOpen = false);
        },
      ),
    );
  }
}
