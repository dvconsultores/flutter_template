import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

final GlobalKey flushBarKey = GlobalKey();

// * App snackbar types
enum ColorSnackbarState {
  neutral,
  info,
  success,
  warning,
  error;
}

/// A global snackbar that can be invoked onto whatever widget.
/// To make it indefinite, set messageDuration to null
void showSnackbar(
  String? message, {
  String? title,
  ColorSnackbarState? type,
  Duration? duration = const Duration(seconds: 3),
  bool closable = true,
  FlushbarDismissDirection dismissDirection =
      FlushbarDismissDirection.HORIZONTAL,
  FlushbarPosition? flushbarPosition,
  String searchBy = "message",
  String fallback = "Error",
}) {
  final context = globalNavigatorKey.currentContext!;
  if (message.hasNotValue) return;

  final String msg = message!.contains('"$searchBy":')
      ? jsonDecode(message)[searchBy]
      : message.isNotEmpty
          ? message
          : fallback;

  (Color, Icon?, FlushbarPosition) getValueByType() {
    Color? color;

    switch (type) {
      case ColorSnackbarState.success:
        return (
          color ??= ThemeApp.colors(context).success,
          Icon(Icons.check_circle_outline_rounded, color: color),
          FlushbarPosition.TOP
        );
      case ColorSnackbarState.warning:
        return (
          color ??= ThemeApp.colors(context).warning,
          Icon(Icons.warning_amber_rounded, color: color),
          FlushbarPosition.TOP
        );
      case ColorSnackbarState.error:
        return (
          color ??= ThemeApp.colors(context).error,
          Icon(Icons.error_rounded, color: color),
          FlushbarPosition.TOP
        );
      case ColorSnackbarState.info:
        return (
          color ??= ThemeApp.colors(context).primary,
          Icon(Icons.info_outline_rounded, color: color),
          FlushbarPosition.BOTTOM
        );
      case ColorSnackbarState.neutral:
      default:
        return (
          color ??= ThemeApp.colors(context).text,
          null,
          FlushbarPosition.BOTTOM
        );
    }
  }

  Flushbar? flushbar;
  flushbar = Flushbar(
    key: flushBarKey,
    titleText: title.hasValue
        ? Text(title!, style: Theme.of(context).textTheme.bodyLarge)
        : null,
    messageText: Text(
      msg,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
    ),
    icon: getValueByType().$2,
    titleColor: ThemeApp.colors(context).text,
    messageColor: ThemeApp.colors(context).text,
    backgroundColor: ThemeApp.colors(context).background,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    borderColor: getValueByType().$1,
    borderWidth: 1.5,
    dismissDirection: dismissDirection,
    leftBarIndicatorColor: getValueByType().$1,
    mainButton: closable
        ? IconButton(
            onPressed: () => flushbar?.dismiss(),
            icon: const Icon(Icons.close),
          )
        : null,
    positionOffset: 20,
    flushbarPosition: flushbarPosition ?? getValueByType().$3,
    margin: const EdgeInsets.only(left: 10.0, right: 10),
    duration: duration,
  );

  flushbar.show(context);
}

void clearSnackbar() {
  if (flushBarKey.currentWidget == null) return;

  (flushBarKey.currentWidget as Flushbar).dismiss();
}
