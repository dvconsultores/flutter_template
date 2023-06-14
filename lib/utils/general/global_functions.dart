import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutterDetextre4/main.dart';
import 'package:flutterDetextre4/utils/config/extensions_config.dart';

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
}) {
  if (message.hasNotValue) return;

  Flushbar(
    message: message,
    backgroundColor: ColorSnackbarState.values
        .byName(type?.name ?? ColorSnackbarState.neutral.name)
        .color,
    messageColor: ColorSnackbarState.values
        .byName(type?.name ?? ColorSnackbarState.neutral.name)
        .textColor,
    duration: duration ?? const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(6),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
