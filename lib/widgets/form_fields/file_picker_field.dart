import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/error_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

enum FilePickerMode {
  fromCamera,
  fromFiles,
  both;
}

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
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius10)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.boxShadow = const [Vars.boxShadow2],
    this.placeholderText,
    this.placeholder,
    this.defaultPlaceholderSize = 45,
    this.errorText,
    this.errorStyle,
    this.onChanged,
    this.disabled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: Vars.gapMedium),
    this.showClearButton = true,
    this.clearButtonInside = true,
    this.chipPositionRight = 0,
    this.chipPositionBottom = 0,
    this.filePickerMode = FilePickerMode.fromFiles,
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
  final double defaultPlaceholderSize;
  final String? errorText;
  final TextStyle? errorStyle;
  final void Function(File? value)? onChanged;
  final bool disabled;
  final EdgeInsetsGeometry padding;
  final bool showClearButton;
  final bool clearButtonInside;
  final double chipPositionRight;
  final double chipPositionBottom;
  final FilePickerMode filePickerMode;

  @override
  State<FilePickerField> createState() => _FilePickerFieldState();
}

class _FilePickerFieldState extends State<FilePickerField>
    with SingleTickerProviderStateMixin {
  FormFieldState<File>? formState;

  late final AnimationController animation;

  final localController = ValueNotifier<File?>(null);

  ValueNotifier<File?> get getController =>
      widget.controller ?? localController;

  final docsAllowed = ["pdf", "doc"],
      imagesAllowed = ["png", "jpg", "bmp", "webp", "tiff"];

  String? fileExtension;

  Future<void> pickFile() async {
    animation.forward();

    final allowedExtensions = [...docsAllowed, ...imagesAllowed],
        result = await FilePicker.platform.pickFiles(
          allowCompression: true,
          allowedExtensions: allowedExtensions,
          type: FileType.custom,
        ),
        platformFile = result?.files.single;

    if (platformFile != null &&
        allowedExtensions.contains(platformFile.extension)) {
      fileExtension = platformFile.extension;

      animation.reverse();
      getController.value = File(platformFile.path!);
    } else {
      animation.reverse();
      getController.value = formState?.value;
    }
  }

  Future<void> pickImage() async {
    animation.forward();

    final xfile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 400,
      maxHeight: 400,
    );

    if (xfile != null) {
      fileExtension = xfile.path.split('.').last;

      animation.reverse();
      getController.value = File(xfile.path);
    } else {
      animation.reverse();
      getController.value = formState?.value;
    }
  }

  void clear() {
    formState!.didChange(null);
    setState(() {});

    if (widget.onChanged != null) {
      EasyDebounce.debounce("onChanged", Durations.short3,
          () => widget.onChanged!(formState!.value));
    }
  }

  void onListen() {
    if (formState!.value == getController.value) return;

    formState!.didChange(getController.value);

    if (widget.onChanged != null) widget.onChanged!(formState!.value);
  }

  @override
  void initState() {
    animation = AnimationController(vsync: this, duration: Durations.short1);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      fileExtension = formState!.value?.path.split('.').last;
      setState(() {});
    });
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
    final colors = ThemeApp.of(context).colors, theme = Theme.of(context);

    final clearButtonWidget = IconButton(
      onPressed: clear,
      visualDensity: VisualDensity.compact,
      icon: const Icon(Icons.close_sharp),
    );

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

        final ps = TextStyle(color: colors.label),
            placeholderWidget = widget.placeholder ??
                (widget.placeholderText != null
                    ? Text(
                        widget.placeholderText ?? '',
                        textAlign: TextAlign.center,
                        style: ps,
                      )
                    : Icon(
                        Icons.add_photo_alternate_outlined,
                        size: widget.defaultPlaceholderSize,
                        color: colors.primary,
                      ));

        return Row(children: [
          SizedBox(
            width: widget.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // field
              AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final isOpen = animation.isCompleted;

                    return GestureDetector(
                      onTap: widget.disabled
                          ? null
                          : () => switch (widget.filePickerMode) {
                                FilePickerMode.fromFiles => pickFile(),
                                FilePickerMode.fromCamera => pickImage(),
                                FilePickerMode.both => attachmentPressed(
                                    context,
                                    onImage: pickImage,
                                    onMedia: pickFile,
                                  ),
                              },
                      child: Container(
                        width: widget.width,
                        height: widget.height,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: widget.borderRadius,
                          border: Border.fromBorderSide(
                            widget.disabled
                                ? widget.borderDisabled ??
                                    BorderSide(
                                        width: 0, color: theme.disabledColor)
                                : isOpen
                                    ? widget.borderFocused ??
                                        BorderSide(color: theme.focusColor)
                                    : widget.border ??
                                        const BorderSide(
                                            width: 0,
                                            color: Colors.transparent),
                          ),
                          boxShadow: widget.boxShadow,
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Container(
                              height: double.maxFinite,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: widget.borderRadius.subtract(
                                  const BorderRadius.all(Radius.circular(4)),
                                ),
                              ),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                if (state.value != null) ...[
                                  if (imagesAllowed.contains(fileExtension))
                                    Image.file(
                                      state.value!,
                                      fit: BoxFit.contain,
                                    )
                                  else
                                    Transform.translate(
                                      offset: const Offset(-4, 0),
                                      child: FractionallySizedBox(
                                        widthFactor: .9,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Expanded(
                                                child: Icon(
                                                    Icons.file_copy_rounded),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Text(
                                                  path
                                                      .basename(
                                                          state.value!.path)
                                                      .split(".$fileExtension")
                                                      .first,
                                                  textAlign: TextAlign.right,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(".$fileExtension")
                                            ]),
                                      ),
                                    ),
                                  Positioned(
                                      right: widget.chipPositionRight,
                                      bottom: widget.chipPositionBottom,
                                      child: Chip(
                                        visualDensity: VisualDensity.compact,
                                        label: Text(
                                          state.value!
                                              .lengthSync()
                                              .formatBytes(),
                                          textAlign: TextAlign.center,
                                          style: ps.copyWith(fontSize: 13),
                                        ),
                                      ))
                                ] else
                                  placeholderWidget,
                              ]),
                            ),
                          ),
                          if (widget.showClearButton &&
                              widget.clearButtonInside &&
                              state.value != null)
                            clearButtonWidget
                        ]),
                      ),
                    );
                  }),

              // error text
              if (state.hasError && (widget.errorText?.isNotEmpty ?? true))
                ErrorText(
                  widget.errorText ?? state.errorText ?? '',
                  style: widget.errorStyle ??
                      theme.textTheme.labelMedium
                          ?.copyWith(color: theme.colorScheme.error),
                )
            ]),
          ),
          if (widget.showClearButton &&
              !widget.clearButtonInside &&
              state.value != null)
            clearButtonWidget
        ]);
      },
    );
  }
}
