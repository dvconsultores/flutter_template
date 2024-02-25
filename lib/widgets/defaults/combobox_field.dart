import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button_aspect.dart';

class ComboboxField<T> extends StatefulWidget {
  const ComboboxField({
    super.key,
    this.itemBuilder,
    this.onChanged,
    this.placeholder,
    required this.value,
    this.dropdownMenuItemChild,
    this.width,
    this.height,
    this.decoration,
    this.leading,
    this.trailing,
    this.visualDensity,
    this.textAlignPlaceHolder,
    this.loading = false,
    this.loaderHeight = 20,
    this.disabled = false,
    this.placeholderSize,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.borderSide = const BorderSide(width: 1),
    this.bgColor,
    this.boxShadow,
    this.gap = 5,
    this.padding = const EdgeInsets.symmetric(horizontal: Variables.gapMedium),
    this.dense = true,
    this.onSubmit,
    this.onTap,
  });
  final ValueNotifier<List<T>> value;
  final Widget Function(T value)? itemBuilder;
  final Widget? dropdownMenuItemChild;
  final Function(List<T>? value)? onChanged;
  final String? placeholder;
  final double? width;
  final double? height;
  final VisualDensity? visualDensity;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final TextAlign? textAlignPlaceHolder;
  final bool loading;
  final bool disabled;
  final double? placeholderSize;
  final BorderRadiusGeometry borderRadius;
  final BorderSide borderSide;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;
  final double gap;
  final EdgeInsetsGeometry padding;
  final double loaderHeight;
  final bool dense;
  final void Function(String value)? onSubmit;
  final void Function()? onTap;

  @override
  State<ComboboxField> createState() => _ComboboxFieldState<T>();
}

class _ComboboxFieldState<T> extends State<ComboboxField<T>> {
  final focusNode = FocusNode();
  final textEditingController = TextEditingController();

  Widget dropdownMenuItemChild([String? value]) =>
      widget.dropdownMenuItemChild ?? Text(value!);

  void onSubmit(String value) {
    if (value.isEmpty) return;

    widget.value.value.add(value as T);
    textEditingController.clear();
    focusNode.requestFocus();
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(widget.value.value);
  }

  void onTap() {
    focusNode.requestFocus();
    if (widget.onTap != null) widget.onTap!();
  }

  void initFocusListener() => focusNode.addListener(() {
        if (!focusNode.hasFocus) textEditingController.clear();
        setState(() {});
      });

  @override
  void initState() {
    initFocusListener();
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
            : widget.disabled && widget.value.value.hasNotValue
                ? Text(
                    widget.placeholder ?? '',
                    textAlign: widget.textAlignPlaceHolder,
                    style: TextStyle(
                      fontSize: widget.placeholderSize,
                    ),
                  )
                : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 7,
                    runSpacing: 3,
                    children: [
                        if (!widget.disabled)
                          SizedBox(
                            width: focusNode.hasFocus ? null : 0,
                            child: TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              onSubmitted: onSubmit,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: widget.value.value.hasNotValue
                                    ? widget.placeholder
                                    : null,
                              ),
                            ),
                          ),
                        ...widget.value.value
                            .mapIndexed((index, item) => IntrinsicWidth(
                                  child: ButtonAspect(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Variables.gapMedium),
                                    height: 35,
                                    bgColor: ThemeApp.colors(context)
                                        .primary
                                        .withAlpha(200),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.close),
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.all(0),
                                      splashRadius: 20,
                                      splashColor: Colors.white,
                                      constraints: const BoxConstraints(
                                        maxWidth: 20,
                                        maxHeight: 20,
                                      ),
                                      iconSize: 18,
                                      color: Colors.white,
                                      onPressed: () => setState(() =>
                                          widget.value.value.removeAt(index)),
                                    ),
                                    trailingGap: 5,
                                    textExpanded: true,
                                    textOverflow: TextOverflow.ellipsis,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      letterSpacing: .5,
                                    ),
                                    text: item is String ? item : null,
                                    content: item is! String
                                        ? widget.itemBuilder!(item)
                                        : null,
                                  ),
                                ))
                            .toList(),
                      ]),
        iconColor: focusNode.hasFocus ? ThemeApp.colors(context).primary : null,
        trailing: widget.trailing,
        onTap: onTap,
      ),
    );
  }
}
