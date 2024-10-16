import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';
import 'package:flutter_detextre4/widgets/loaders/loader.dart';

class SafeRequest {
  static Future<T> retryOnFailure<T>(
    Future<T> Function() future, {
    int maxAttempts = 3,
    Duration delay = Durations.medium2,
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await future();
      } catch (error) {
        debugPrint("$error ⭕");
        await Future.delayed(delay);
        if (attempt == maxAttempts - 1) rethrow;
      }
    }

    throw "Max attemps reached on fetch";
  }

  static Future<T?> retryOnFailureWithRequest<T>(
    BuildContext context,
    Future<T> Function() future, {
    AppLoader? loader,
    int maxAttempts = 0,
    Duration delay = Durations.long2,
    String title = "Something went wrong",
    String? contentText,
    String textConfirm = "Retry",
    String texTCancel = "Cancel",
  }) async {
    final load = loader ?? AppLoader();
    int attempt = 0;

    while (maxAttempts == 0 || attempt < maxAttempts) {
      try {
        load.open();
        final response = await future();
        load.close();

        return response;
      } catch (error) {
        load.close();
        if (!context.mounted) return null;

        final accepts = await Modal.showAlertToContinue(
          context,
          titleText: title,
          contentText: contentText ?? error.toString(),
          textConfirmBtn: textConfirm,
          textCancelBtn: texTCancel,
        );
        if (accepts != true || !context.mounted) return null;
        await Future.delayed(delay);
      }

      attempt++;
    }

    return null;
  }
}
