import 'dart:convert';
import 'dart:io' show Directory, File, FileMode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/widgets/dialogs/system_alert_widget.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' show Response, get;
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

Future<String?> downloadAndSavePicture(String? url, String fileName) async {
  if (url == null) return null;
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final Response response = await get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<dynamic> capturePng(Uint8List imageBytes) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String path = directory.path;
  final String imagePath = '$path/screenshot${DateTime.now()}.png';
  final File file = File(imagePath);
  await file.writeAsBytes(imageBytes, mode: FileMode.write);
  debugPrint(
      'Image saved to $imagePath (size: ${file.lengthSync()} bytes) ${file.path} ⬅️');
  await GallerySaver.saveImage(file.path);
  Share.shareXFiles([XFile(file.path)]);
  return file;
}

/// Read JSON asset file
Future<T> getJsonFile<T>(String path) async =>
    jsonDecode(await rootBundle.loadString(path));

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
Future<String?> showPopup(Map<String, IconData> items) async {
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

Future<void> checkVersion(BuildContext context) =>
    PackageInfo.fromPlatform().then((packageInfo) async {
      final (minVersion, currentVersion) =
          ("1.0.0", "1.0.0"); //? implement fetch to get version 🖊️
      final packageVersion = packageInfo.version;

      final hasUpdate =
          Version.parse(packageVersion) < Version.parse(currentVersion);
      final requireUpdate =
          Version.parse(packageVersion) < Version.parse(minVersion);

      if (context.mounted && hasUpdate) {
        await showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(.1),
            barrierDismissible: !requireUpdate,
            builder: (context) => SystemAlertWidget(
                  title: "Actualización disponible!",
                  textContent: requireUpdate
                      ? "Debes actualizar tu applicación de Apolo Pay para poder continuar"
                      : "Tenemos una nueva versión de Apolo Pay disponible para ti en la tienda",
                  dismissible: !requireUpdate,
                  textButton: requireUpdate ? null : "Continuar",
                  textButton2: "Actualizar",
                  onPressedButton2: () => LaunchReview.launch(
                      androidAppId: packageInfo.packageName),
                ));
      }
    });
