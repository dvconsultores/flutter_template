import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/sheets/bottom_sheet_card.dart';
import 'package:flutter_gap/flutter_gap.dart';

class MultiSelectField<T> extends StatefulWidget {
  const MultiSelectField({
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
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.borderSide = const BorderSide(width: 1),
    this.bgColor,
    this.boxShadow,
    this.gap = 5,
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
  final BorderSide borderSide;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;
  final double gap;
  final EdgeInsetsGeometry padding;
  final double loaderHeight;
  final bool dense;

  @override
  State<MultiSelectField> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultiSelectField<T>> {
  bool isOpen = false;

  List<T>? selectedItems;

  late final ValueNotifier<List<T>> getValue;

  @override
  void initState() {
    getValue = ValueNotifier(widget.value ?? <T>[]);
    if (widget.initialValue != null) getValue.value = widget.initialValue!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<T> controllerValue() {
      if (widget.maxLenght == null) return getValue.value;

      return getValue.value
              .slices(widget.maxLenght!)
              .elementAtOrNull(0)
              ?.toList() ??
          [];
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration ??
          BoxDecoration(
            borderRadius: widget.borderRadius,
            color: widget.bgColor ?? Theme.of(context).colorScheme.background,
            boxShadow: widget.boxShadow ??
                [
                  const BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 6),
                    blurRadius: 10,
                  )
                ],
            border: Border.fromBorderSide(widget.borderSide),
          ),
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
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Variables.radius12)),
                  color: ThemeApp.colors(context).primary,
                  minHeight: widget.loaderHeight,
                ),
              )
            : getValue.value.hasNotValue || widget.indicator
                // placeholder
                ? Text(
                    widget.placeholder ?? "",
                    textAlign: widget.textAlignPlaceHolder,
                    style: TextStyle(
                      fontSize: widget.placeholderSize,
                    ),
                  )
                // value
                : Wrap(
                    spacing: 7,
                    children: controllerValue()
                        .expand((item) => widget.items
                            .where((element) => element.value == item))
                        .map((e) => e.child)
                        .toList(),
                  ),
        iconColor: getValue.value.hasValue && widget.indicator
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

          final List<T>? result = await BottomSheetCard.showModal(
            context,
            builder: (context) => _ShowModal<T>(
              items: widget.items,
              controllerValue: controllerValue(),
              title: widget.dialogTittle,
              maxLenght: widget.maxLenght,
              emptyDataMessage: widget.emptyDataMessage,
            ),
          );

          if (result == null) return;

          getValue.value = result;
          if (widget.onChanged != null) widget.onChanged!(getValue.value);

          setState(() => isOpen = false);
        },
      ),
    );
  }
}

class _ShowModal<T> extends StatefulWidget {
  const _ShowModal({
    required this.items,
    required this.controllerValue,
    required this.title,
    this.maxLenght,
    this.emptyDataMessage,
  });
  final List<DropdownMenuItem<T>> items;
  final List<T> controllerValue;
  final String? title;
  final int? maxLenght;
  final String? emptyDataMessage;

  @override
  State<_ShowModal> createState() => _ShowModalState<T>();
}

class _ShowModalState<T> extends State<_ShowModal<T>> {
  late final selectedItems = List.of(widget.controllerValue);

  @override
  Widget build(BuildContext context) {
    bool isSelected(T? item) =>
        selectedItems.singleWhereOrNull((element) => element == item) != null;

    return BottomSheetCard(
      initialChildSize: .45,
      minChildSize: .1,
      maxChildSize: .45,
      scrollable: false,
      padding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(children: [
          Text(widget.title ?? '',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const Gap(Variables.gapMedium).column,
          Expanded(
            child: widget.items.isEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Variables.gapMax),
                    child: Text(widget.emptyDataMessage ?? "No hay registros"),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 20 / 4.8,
                    crossAxisSpacing: Variables.gapXLarge,
                    mainAxisSpacing: Variables.gapXLarge,
                    children: widget.items
                        .map(
                          (item) => Button(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              if (!isSelected(item.value)) Variables.boxShadow2,
                            ],
                            borderSide: BorderSide(
                              width: 1.3,
                              color: isSelected(item.value)
                                  ? ThemeApp.colors(context).primary
                                  : Colors.transparent,
                            ),
                            bgColor: Colors.white,
                            onPressed: () => setState(() {
                              if (isSelected(item.value)) {
                                return selectedItems.removeWhere(
                                    (element) => element == item.value);
                              }

                              if (widget.maxLenght == null) {
                                selectedItems.add(item.value as T);
                              } else if (selectedItems.length <
                                  widget.maxLenght!) {
                                selectedItems.add(item.value as T);
                              }
                            }),
                            child: item.child,
                          ),
                        )
                        .toList(),
                  ),
          ),
          const Gap(Variables.gapMedium).column,
          Button(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            text: "Aceptar",
            onPressed: () => Navigator.pop(context, selectedItems),
          ),
        ]),
      ),
    );
  }
}
