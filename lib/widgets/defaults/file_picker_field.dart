import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:path/path.dart';

class FilePickerField extends StatefulWidget {
  const FilePickerField({
    super.key,
    this.controller,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(Variables.radius15)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.boxShadow = const [Variables.boxShadow2],
    this.placeholderText,
    this.placeholder,
    this.onChanged,
    this.disabled = false,
  });

  final ValueNotifier<File?>? controller;
  final BorderRadius borderRadius;
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderFocused;
  final List<BoxShadow> boxShadow;
  final String? placeholderText;
  final Widget? placeholder;
  final void Function(File? value)? onChanged;
  final bool disabled;

  @override
  State<FilePickerField> createState() => _FilePickerFieldState();
}

class _FilePickerFieldState extends State<FilePickerField> {
  bool isOpen = false;

  final docsAllowed = ["pdf", "doc"],
      imagesAllowed = ["png", "jpg", "bmp", "webp", "tiff"];

  File? file;
  String? fileExtension;
  File? get getFile => widget.controller?.value ?? file;

  Future<void> pickFile() async {
    setState(() => isOpen = true);

    final allowedExtensions = [...docsAllowed, ...imagesAllowed];

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: allowedExtensions, type: FileType.custom);

    if (result != null &&
        allowedExtensions.contains(result.files.single.extension)) {
      widget.controller?.value = File(result.files.single.path!);
      file = File(result.files.single.path!);

      fileExtension = result.files.single.extension;
    }

    setState(() => isOpen = false);

    if (widget.onChanged != null) widget.onChanged!(getFile);
  }

  void clear() {
    widget.controller?.value = null;
    file = null;
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(getFile);
  }

  @override
  Widget build(BuildContext context) {
    final ps = TextStyle(color: ThemeApp.colors(context).label);

    return GestureDetector(
      onTap: widget.disabled ? null : pickFile,
      child: Container(
        width: double.maxFinite,
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ThemeApp.colors(context).background,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          ),
          boxShadow: widget.boxShadow,
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              height: double.maxFinite,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: getFile != null
                    ? ThemeApp.colors(context).label.withAlpha(180)
                    : ThemeApp.colors(context).label.withAlpha(100),
                borderRadius: widget.borderRadius.subtract(
                  const BorderRadius.all(Radius.circular(4)),
                ),
              ),
              child: Stack(alignment: Alignment.center, children: [
                if (getFile != null) ...[
                  if (imagesAllowed.contains(fileExtension!))
                    Image.file(getFile!, fit: BoxFit.contain)
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
                                  basename(getFile!.path)
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
                          getFile!.lengthSync().formatBytes(),
                          textAlign: TextAlign.center,
                          style: ps.copyWith(fontSize: 13),
                        ),
                      ))
                ] else if (widget.placeholder != null ||
                    widget.placeholderText != null)
                  widget.placeholder ??
                      Text(
                        widget.placeholderText!,
                        textAlign: TextAlign.center,
                        style: ps,
                      ),
              ]),
            ),
          ),
          if (getFile != null)
            IconButton(
              onPressed: clear,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close_sharp),
            )
        ]),
      ),
    );
  }
}
