import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_animated_builder.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ComboboxField<T> extends StatefulWidget {
  const ComboboxField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.itemBuilder,
    this.onChanged,
    this.value,
    this.initialValue,
    this.width = double.maxFinite,
    this.height = Vars.maxInputHeight,
    this.decoration,
    this.leading,
    this.trailing,
    this.loading = false,
    this.loaderHeight = 20,
    this.disabled = false,
    this.readOnly = false,
    this.hintText,
    this.textAlignHint,
    this.errorText,
    this.hintStyle,
    this.errorStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius15)),
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
    this.onSubmit,
    this.onTap,
    this.onTapItem,
    this.onRemoveItem,
    this.maxLength,
  });
  final String? restorationId;
  final void Function(List<T>? value)? onSaved;
  final String? Function(List<T>? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final List<T>? initialValue;
  final ValueNotifier<List<T>>? value;
  final Widget Function(T value)? itemBuilder;
  final Function(List<T>? value)? onChanged;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;
  final bool disabled;
  final bool readOnly;
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
  final void Function(String value)? onSubmit;
  final void Function(FormFieldState<List<T>> state)? onTap;
  final void Function(T item)? onTapItem;
  final void Function(T item, int index)? onRemoveItem;
  final int? maxLength;

  @override
  State<ComboboxField<T>> createState() => _ComboboxFieldState<T>();
}

class _ComboboxFieldState<T> extends State<ComboboxField<T>> {
  FormFieldState<List<T>>? formState;

  final focusNode = FocusNode(),
      textEditingController = TextEditingController();

  bool get hasReachedMaxLength {
    if (widget.maxLength == null) return false;
    return widget.maxLength! <= (formState?.value?.length ?? 0);
  }

  void onSubmit(String value) {
    if (value.isEmpty) return;

    final newValue = formState!.value ?? [];
    newValue.add(value as T);
    formState!.didChange(newValue);

    textEditingController.clear();
    focusNode.requestFocus();
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(formState!.value);
  }

  void onTap() {
    focusNode.requestFocus();
    if (widget.onTap != null) widget.onTap!(formState!);
  }

  void removeItem(int index) {
    final newValue = formState!.value, item = newValue!.removeAt(index);
    formState!.didChange(newValue);
    setState(() {});

    if (widget.onRemoveItem != null) widget.onRemoveItem!(item, index);
  }

  void initFocusListener() => focusNode.addListener(() {
        if (!focusNode.hasFocus) textEditingController.clear();
        setState(() {});
      });

  void initNotifierListener() => widget.value?.addListener(() {
        if (widget.value!.value.isEmpty ||
            formState!.value == widget.value!.value) return;

        formState!.didChange(widget.value!.value);
      });

  @override
  void initState() {
    initFocusListener();
    initNotifierListener();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
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
        widget.value?.value = state.value ?? [];

        final hs = widget.hintStyle ??
                TextStyle(
                  color: ThemeApp.colors(context).text.withOpacity(.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.lato("400"),
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
                : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 7,
                    runSpacing: 3,
                    children: [
                        // textField
                        if (!hasReachedMaxLength &&
                                !widget.disabled &&
                                !widget.readOnly ||
                            state.value.hasNotValue)
                          SizedBox(
                            width: state.value.hasNotValue || focusNode.hasFocus
                                ? null
                                : 0,
                            child: TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              enabled: !widget.disabled,
                              readOnly: widget.readOnly,
                              onSubmitted: onSubmit,
                              onTap: onTap,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                // hint text
                                hintText: widget.hintText,
                                hintStyle: hs,
                              ),
                            ),
                          ),

                        // value
                        for (var i = 0; i < (state.value?.length ?? 0); i++)
                          IntrinsicWidth(
                            child: Button(
                              onPressed: widget.onTapItem != null
                                  ? () => widget.onTapItem!(state.value![i])
                                  : null,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Vars.gapMedium),
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
                                onPressed: () => removeItem(i),
                              ),
                              trailingGap: 5,
                              textExpanded: true,
                              textOverflow: TextOverflow.ellipsis,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                              text: state.value![i] is String
                                  ? state.value![i] as String
                                  : null,
                              content: state.value![i] is! String
                                  ? widget.itemBuilder!(state.value![i])
                                  : null,
                            ),
                          )
                      ]);

        return SizedBox(
          width: widget.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // field
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: widget.width,
                constraints: BoxConstraints(
                    minHeight: widget.height ??
                        (widget.dense
                            ? Vars.minInputHeight
                            : Vars.maxInputHeight)),
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
                            : focusNode.hasFocus
                                ? widget.borderFocused ??
                                    BorderSide(
                                        color: Theme.of(context).focusColor)
                                : widget.border ??
                                    const BorderSide(color: Colors.transparent),
                      ),
                    ),
                child: Row(children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    Gap(widget.gap).row
                  ],
                  Expanded(child: contentWidget),
                  if (widget.trailing != null) ...[
                    Gap(widget.gap).row,
                    widget.trailing!
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
