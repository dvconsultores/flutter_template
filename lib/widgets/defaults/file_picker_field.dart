import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:path/path.dart';

class FilePickerField extends StatefulWidget {
  const FilePickerField({
    super.key,
    this.controller,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.borderWidth = 1,
    this.borderColor,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 6),
        blurRadius: 10,
      )
    ],
    this.placeholderText,
    this.placeholder,
  });

  final ValueNotifier<File?>? controller;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final List<BoxShadow> boxShadow;
  final String? placeholderText;
  final Widget? placeholder;

  @override
  State<FilePickerField> createState() => _FilePickerFieldState();
}

class _FilePickerFieldState extends State<FilePickerField> {
  final docsAllowed = ["pdf", "doc"],
      imagesAllowed = ["png", "jpg", "bmp", "webp", "tiff"];

  File? file;
  String? fileExtension;
  File? get getFile => widget.controller?.value ?? file;

  Future<void> pickFile() async {
    final allowedExtensions = [...docsAllowed, ...imagesAllowed];

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: allowedExtensions, type: FileType.custom);
    if (result == null ||
        !allowedExtensions.contains(result.files.single.extension)) return;

    widget.controller?.value = File(result.files.single.path!);
    file = File(result.files.single.path!);

    fileExtension = result.files.single.extension;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ps = TextStyle(color: ThemeApp.colors(context).label);

    return GestureDetector(
      onTap: pickFile,
      child: Container(
        width: double.maxFinite,
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ThemeApp.colors(context).background,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: widget.borderWidth,
            color: widget.borderColor ?? Theme.of(context).colorScheme.outline,
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
              onPressed: () => setState(() {
                widget.controller?.value = null;
                file = null;
              }),
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close_sharp),
            )
        ]),
      ),
    );
  }
}
