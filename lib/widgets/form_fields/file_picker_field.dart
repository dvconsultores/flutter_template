import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_animated_builder.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:path/path.dart';

class FilePickerField extends StatefulWidget {
  const FilePickerField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.initialValue,
    this.width = double.maxFinite,
    this.height = 150,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(Variables.radius15)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.boxShadow = const [Variables.boxShadow2],
    this.placeholderText,
    this.placeholder,
    this.errorText,
    this.errorStyle,
    this.onChanged,
    this.disabled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: Variables.gapMedium),
  });

  final String? restorationId;
  final void Function(File? value)? onSaved;
  final String? Function(File? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<File?>? controller;
  final File? initialValue;
  final double width;
  final double? height;
  final BorderRadius borderRadius;
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderFocused;
  final List<BoxShadow> boxShadow;
  final String? placeholderText;
  final Widget? placeholder;
  final String? errorText;
  final TextStyle? errorStyle;
  final void Function(File? value)? onChanged;
  final bool disabled;
  final EdgeInsetsGeometry padding;

  @override
  State<FilePickerField> createState() => _FilePickerFieldState();
}

class _FilePickerFieldState extends State<FilePickerField> {
  FormFieldState<File>? formState;
  bool isOpen = false;

  final docsAllowed = ["pdf", "doc"],
      imagesAllowed = ["png", "jpg", "bmp", "webp", "tiff"];

  String? fileExtension;

  Future<void> pickFile() async {
    setState(() => isOpen = true);

    final allowedExtensions = [...docsAllowed, ...imagesAllowed],
        result = await FilePicker.platform.pickFiles(
          allowedExtensions: allowedExtensions,
          type: FileType.custom,
        ),
        platformFile = result?.files.single;

    if (platformFile != null &&
        allowedExtensions.contains(platformFile.extension)) {
      fileExtension = platformFile.extension;
      formState!.didChange(File(platformFile.path!));
    } else {
      formState!.didChange(formState?.value);
    }

    isOpen = false;
    setState(() {});

    if (widget.onChanged != null) {
      EasyDebounce.debounce("onChanged", Durations.short4,
          () => widget.onChanged!(formState!.value));
    }
  }

  void clear() {
    formState!.didChange(null);
    setState(() {});

    if (widget.onChanged != null) {
      EasyDebounce.debounce("onChanged", Durations.short4,
          () => widget.onChanged!(formState!.value));
    }
  }

  void initNotifierListener() => widget.controller?.addListener(() {
        if (widget.controller!.value == null ||
            formState!.value == widget.controller!.value) return;

        formState!.didChange(widget.controller!.value);
      });

  @override
  void initState() {
    initNotifierListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
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

        final ps = TextStyle(color: ThemeApp.colors(context).label),
            placeholderWidget = Text(
              widget.placeholderText ?? '',
              textAlign: TextAlign.center,
              style: ps,
            ),
            errorWidget = Text(
              widget.errorText ?? state.errorText ?? '',
              style: widget.errorStyle ??
                  Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
            );

        return SizedBox(
          width: widget.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // field
            GestureDetector(
              onTap: widget.disabled ? null : pickFile,
              child: Container(
                width: widget.width,
                height: widget.height,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: ThemeApp.colors(context).background,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Variables.radius15)),
                  border: Border.fromBorderSide(
                    widget.disabled
                        ? widget.borderDisabled ??
                            BorderSide(
                                width: 0,
                                color: Theme.of(context).disabledColor)
                        : isOpen
                            ? widget.borderFocused ??
                                BorderSide(color: Theme.of(context).focusColor)
                            : widget.border ??
                                const BorderSide(
                                    width: 0, color: Colors.transparent),
                  ),
                  boxShadow: widget.boxShadow,
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: state.value != null
                            ? ThemeApp.colors(context).label.withAlpha(180)
                            : ThemeApp.colors(context).label.withAlpha(100),
                        borderRadius: widget.borderRadius.subtract(
                          const BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      child: Stack(alignment: Alignment.center, children: [
                        if (state.value != null) ...[
                          if (imagesAllowed.contains(fileExtension!))
                            Image.file(state.value!, fit: BoxFit.contain)
                          else
                            Transform.translate(
                              offset: const Offset(-4, 0),
                              child: FractionallySizedBox(
                                widthFactor: .9,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        child: Icon(Icons.file_copy_rounded),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          basename(state.value!.path)
                                              .split(".$fileExtension")
                                              .first,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(".$fileExtension")
                                    ]),
                              ),
                            ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Chip(
                                visualDensity: VisualDensity.compact,
                                label: Text(
                                  state.value!.lengthSync().formatBytes(),
                                  textAlign: TextAlign.center,
                                  style: ps.copyWith(fontSize: 13),
                                ),
                              ))
                        ] else if (widget.placeholder != null ||
                            widget.placeholderText != null)
                          widget.placeholder ?? placeholderWidget,
                      ]),
                    ),
                  ),
                  if (state.value != null)
                    IconButton(
                      onPressed: clear,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close_sharp),
                    )
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
