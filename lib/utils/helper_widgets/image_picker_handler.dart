import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';
import 'package:image_picker/image_picker.dart' as image;
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHandler extends image.ImagePicker {
  @override
  Future<image.XFile?> pickImage({
    required image.ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    image.CameraDevice preferredCameraDevice = image.CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    final permissions = Permission.camera;

    if (await permissions.isPermanentlyDenied) {
      final permissionsGranted =
          await openAppSettingsModal(ContextUtility.context!, permissions);
      if (permissionsGranted != true) return null;
    }

    return await super.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
  }

  @override
  Future<image.XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  }) async {
    final permissions = Permission.mediaLibrary;

    if (await permissions.isPermanentlyDenied) {
      final permissionsGranted =
          await openAppSettingsModal(ContextUtility.context!, permissions);
      if (permissionsGranted != true) return null;
    }

    return await super.pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
    );
  }

  @override
  Future<image.XFile?> pickVideo({
    required image.ImageSource source,
    image.CameraDevice preferredCameraDevice = image.CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    final permissions = Permission.videos;

    if (await permissions.isPermanentlyDenied) {
      final permissionsGranted =
          await openAppSettingsModal(ContextUtility.context!, permissions);
      if (permissionsGranted != true) return null;
    }

    return await super.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );
  }

  @override
  Future<List<image.XFile>> pickMultipleMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    final permissions = Permission.mediaLibrary;

    if (await permissions.isPermanentlyDenied) {
      final permissionsGranted =
          await openAppSettingsModal(ContextUtility.context!, permissions);
      if (permissionsGranted != true) return [];
    }

    return await super.pickMultipleMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
      requestFullMetadata: requestFullMetadata,
    );
  }

  @override
  Future<List<image.XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    final permissions = Permission.photos;

    if (await permissions.isPermanentlyDenied) {
      final permissionsGranted =
          await openAppSettingsModal(ContextUtility.context!, permissions);
      if (permissionsGranted != true) return [];
    }

    return await super.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
      requestFullMetadata: requestFullMetadata,
    );
  }

  /// Returns [true] if the app settings page could be opened, otherwise [false].
  /// if modal is cancelled returns [null]
  static Future<bool?> openAppSettingsModal(
      BuildContext context, Permission permission) async {
    String permissionName;
    switch (permission) {
      case Permission.camera:
        permissionName = "cámara";
        break;
      case Permission.photos:
      case Permission.mediaLibrary:
        permissionName = "galería";
        break;
      case Permission.videos:
        permissionName = "videos";
        break;
      default:
        permissionName = "almacenamiento";
    }

    return await Modal.showSystemAlert(
      context,
      titleText: "Permisos requeridos",
      content: (style) => Text.rich(
        TextSpan(children: [
          TextSpan(
            text: "Para poder acceder a esta funcionalidad, necesitamos ",
          ),
          TextSpan(
            text: "permisos para acceder a la $permissionName.",
            style: style.copyWith(
              color: ThemeApp.of(context).colors.primary,
              fontFamily: FontFamily.lato("500"),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text:
                "\n\nPor favor, habilita los permisos en la configuración de la aplicación.",
          ),
        ]),
        style: style.copyWith(height: 1.2),
      ),
      textConfirmBtn: "Ir a la configuración",
      onPressedConfirmBtn: (context) async {
        final value = await openAppSettings();
        if (context.mounted) Navigator.pop(context, value);
      },
    );
  }
}
