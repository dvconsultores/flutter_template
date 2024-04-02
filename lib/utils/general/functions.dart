import 'dart:convert';
import 'dart:io' show Directory, File;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/dialogs/system_alert_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' show Response, get;
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

Future<ByteArrayAndroidBitmap?> buildAndroidBitmap(
  String? imageUrl, {
  Size? size,
}) async {
  if (imageUrl == null || !imageUrl.hasNetworkPath) return null;

  final byteData = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
  var bytes = byteData.buffer.asUint8List();

  if (size != null) {
    final codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: size.width.toInt(),
          targetHeight: size.height.toInt(),
        ),
        frame = await codec.getNextFrame();

    bytes = (await frame.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  return ByteArrayAndroidBitmap.fromBase64String(base64Encode(bytes));
}

Future<String?> downloadAndSavePicture(
  String? url, {
  String? fileName,
  String extensionType = 'png',
}) async {
  if (url.hasNotValue) return null;
  final Directory directory = await getApplicationDocumentsDirectory();
  final filePath =
      '${directory.path}/${fileName ?? "file-${DateTime.now()}"}.$extensionType';

  final Response response = await get(Uri.parse(url!));
  await File(filePath).writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<File> capturePng(
  Uint8List imageBytes, {
  String? fileName,
  String extensionType = 'png',
}) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final filePath =
          '${directory.path}/${fileName ?? "screenshot-${DateTime.now()}"}.$extensionType',
      file = File(filePath);

  await file.writeAsBytes(imageBytes);
  await GallerySaver.saveImage(file.path);
  Share.shareXFiles([XFile(file.path)]);
  return file;
}

void unfocus(BuildContext context) => FocusScope.of(context).unfocus();

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
Future<String?> showPopup(
  BuildContext context, {
  required List<PopupMenuItem<String>> items,
  double? offsetY,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  clipBehavior = Clip.none,
  String? initialValue,
  double? elevation,
  Color? shadowColor,
  Color? color = Colors.white,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) async {
  //*get the render box from the context
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //*get the global position, from the widget local position
  final offset = renderBox.localToGlobal(Offset.zero);

  //*calculate the start point in this case, below the button
  final left = offset.dx;
  final top = offset.dy /* + renderBox.size.height */ + (offsetY ?? 0);
  //*The right does not indicates the width
  final right = left + renderBox.size.width;

  return await showMenu<String>(
    context: context,
    clipBehavior: clipBehavior,
    initialValue: initialValue,
    shadowColor: shadowColor,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Vars.radius15)),
        ),
    color: color,
    elevation: elevation,
    constraints:
        constraints ?? BoxConstraints(minWidth: context.size?.width ?? 100),
    position: RelativeRect.fromLTRB(left, top, right, 0.0),
    items: items,
  );
}

Future<void> checkVersion(BuildContext context) =>
    PackageInfo.fromPlatform().then((packageInfo) async {
      final (minVersion, currentVersion) =
          ("1.0.0", "1.0.0"); //? implement fetch to get version 🖊️

      final packageVersion = packageInfo.version,
          hasUpdate =
              Version.parse(packageVersion) < Version.parse(currentVersion),
          requireUpdate =
              Version.parse(packageVersion) < Version.parse(minVersion);

      if (context.mounted && hasUpdate) {
        await showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(.1),
            barrierDismissible: !requireUpdate,
            builder: (context) => SystemAlertWidget(
                  title: "Update Available!",
                  textContent: requireUpdate
                      ? "You must to update the application to continue"
                      : "We have a new version available to you on the store",
                  dismissible: !requireUpdate,
                  textButton: requireUpdate ? null : "Continue",
                  textButton2: "Update",
                  onPressedButton2: () => LaunchReview.launch(
                      androidAppId: packageInfo.packageName),
                ));
      }
    });
