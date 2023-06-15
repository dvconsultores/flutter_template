import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/general/global_functions.dart';

class DoubleBackToCloseWidget extends StatelessWidget {
  const DoubleBackToCloseWidget({
    super.key,
    required this.snackBarMessage,
    required this.child,
    this.onDoubleBack,
    this.doubleBackDuration = const Duration(milliseconds: 1350),
  });
  final Widget child;
  final String snackBarMessage;
  final Future<bool> Function()? onDoubleBack;
  final Duration doubleBackDuration;

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();
      if (currentBackPressTime.isNotExist ||
          now.difference(currentBackPressTime!) > doubleBackDuration) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarMessage),
          duration: doubleBackDuration,
          backgroundColor: ColorSnackbarState.neutral.color,
        ));
        return false;
      }

      if (onDoubleBack.isExist) return await onDoubleBack!();

      return true;
    }

    return !Platform.isIOS
        // * Android
        ? WillPopScope(
            onWillPop: onWillPop,
            child: child,
          )
        // * IOS
        : WillPopScope(
            onWillPop: () => Future.value(false),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  (details.delta.dx > 8).inCase(onWillPop),
              child: child,
            ),
          );
  }
}
