import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _context = globalNavigatorKey.currentContext!;

// * App snackbar types
enum SnackbarType {
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
  SnackbarType? type,
  Duration? duration = const Duration(seconds: 15),
  bool closable = true,
  FlushbarDismissDirection dismissDirection = FlushbarDismissDirection.VERTICAL,
  FlushbarPosition? flushbarPosition,
  FlushbarStyle flushbarStyle = FlushbarStyle.FLOATING,
  String searchBy = "message",
  String fallback = "Error",
}) {
  if (message.hasNotValue) return;

  final String msg = message!.contains('"$searchBy":')
      ? jsonDecode(message)[searchBy]
      : message.isNotEmpty
          ? message
          : fallback;

  (Color, Icon?, FlushbarPosition) getValueByType() {
    Color? color;

    switch (type) {
      case SnackbarType.success:
        return (
          color ??= ThemeApp.colors(_context).success,
          Icon(Icons.check_circle_outline_rounded, color: color),
          FlushbarPosition.BOTTOM
        );
      case SnackbarType.warning:
        return (
          color ??= ThemeApp.colors(_context).warning,
          Icon(Icons.warning_amber_rounded, color: color),
          FlushbarPosition.BOTTOM
        );
      case SnackbarType.error:
        return (
          color ??= ThemeApp.colors(_context).error,
          Icon(Icons.error_rounded, color: color),
          FlushbarPosition.BOTTOM
        );
      case SnackbarType.info:
        return (
          color ??= ThemeApp.colors(_context).secondary,
          Icon(Icons.info_outline_rounded, color: color),
          FlushbarPosition.BOTTOM
        );
      case SnackbarType.neutral:
      default:
        return (
          color ??= ThemeApp.colors(_context).text,
          null,
          FlushbarPosition.BOTTOM
        );
    }
  }

  Flushbar? flushbar;
  flushbar = Flushbar(
    titleText: title.hasValue
        ? Text(title!, style: Theme.of(_context).textTheme.bodyLarge)
        : null,
    messageText: Text(
      msg,
      style: Theme.of(_context).textTheme.bodyMedium?.copyWith(fontSize: 14),
    ),
    icon: getValueByType().$2,
    titleColor: ThemeApp.colors(_context).text,
    messageColor: ThemeApp.colors(_context).text,
    backgroundColor: ThemeApp.colors(_context).background,
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    borderColor: getValueByType().$1,
    borderWidth: 2.5,
    dismissDirection: dismissDirection,
    mainButton: closable
        ? IconButton(
            onPressed: () => flushbar?.dismiss(),
            icon: const Icon(Icons.close),
            splashRadius: 20,
          )
        : null,
    positionOffset: 20,
    flushbarPosition: flushbarPosition ?? getValueByType().$3,
    margin: const EdgeInsets.only(left: 10.0, right: 10),
    duration: duration,
    flushbarStyle: flushbarStyle,
  );

  _context.read<MainProvider>().addSnackbar = flushbar;

  flushbar.show(_context);
}

void clearSnackbars() => _context.read<MainProvider>().clearSnackbars;
