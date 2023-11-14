import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
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
