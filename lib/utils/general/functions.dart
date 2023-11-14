import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

/// * Helper to multiple pop callbacks
void popMultiple(BuildContext context, [int count = 1]) {
  if (count <= 0) return;

  Navigator.pop(context);
  popMultiple(context, count - 1);
}

/// * Launch external url from the app
Future<void> openUrl(String url) async {
  final urlParsed = Uri.parse(url);
  if (!await launchUrl(urlParsed, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $urlParsed');
  }
}

/// * Used to get a function instance inside widget building
T buildWidget<T>(T Function() callback) => callback();

// * App snackbar
enum ColorSnackbarState {
  neutral(
    color: Colors.black54,
    textColor: Colors.white,
  ),
  success(
    color: Color.fromARGB(180, 76, 175, 79),
    textColor: Colors.black,
  ),
  warning(
    color: Color.fromARGB(180, 255, 235, 59),
    textColor: Colors.black,
  ),
  error(
    color: Color.fromARGB(180, 244, 67, 54),
    textColor: Colors.white,
  );

  const ColorSnackbarState({
    required this.color,
    required this.textColor,
  });
  final Color color;
  final Color textColor;
}

/// A global snackbar that can be invoked onto whatever widget.
void showSnackbar(
  String? message, {
  ColorSnackbarState? type,
  Duration? duration,
  String searchBy = "message",
  String fallback = "Error",
}) {
  if (message.hasNotValue) return;

  String? msg() {
    if (message == null) return null;

    return message.contains('"$searchBy":')
        ? jsonDecode(message)[searchBy]
        : message.isNotEmpty
            ? message
            : fallback;
  }

  Flushbar(
    message: msg(),
    backgroundColor: ColorSnackbarState.values
        .byName(type?.name ?? ColorSnackbarState.neutral.name)
        .color,
    messageColor: ColorSnackbarState.values
        .byName(type?.name ?? ColorSnackbarState.neutral.name)
        .textColor,
    duration: duration ?? const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(6),
    margin: const EdgeInsets.only(left: 10.0, right: 10, bottom: 20),
  ).show(globalNavigatorKey.currentContext!);
}

/// A global menu that can be invoked onto whatever widget.
Future<String?> showPopup(
  Map<String, IconData> items,
) async {
  final context = globalNavigatorKey.currentContext!;

  //*get the render box from the context
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //*get the global position, from the widget local position
  final offset = renderBox.localToGlobal(Offset.zero);

  //*calculate the start point in this case, below the button
  final left = offset.dx;
  final top = offset.dy + renderBox.size.height;
  //*The right does not indicates the width
  final right = left + renderBox.size.width;

  return await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, 0.0),
      items: items.entries.map<PopupMenuEntry<String>>((entry) {
        return PopupMenuItem(
          value: entry.key,
          child: SizedBox(
            // width: 200, //*width of popup
            child: Row(
              children: [
                Icon(entry.value, color: Colors.redAccent),
                const SizedBox(width: 10.0),
                Text(entry.key)
              ],
            ),
          ),
        );
      }).toList());
}
