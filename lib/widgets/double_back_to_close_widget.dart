import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/global_functions.dart';

class DoubleBackToCloseWidget extends StatelessWidget {
  const DoubleBackToCloseWidget({
    super.key,
    required this.snackBarMessage,
    required this.child,
    required this.onDoubleBack,
    this.doubleBackDuration = const Duration(milliseconds: 1350),
  });
  final Widget child;
  final String snackBarMessage;
  final VoidCallback onDoubleBack;
  final Duration doubleBackDuration;

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > doubleBackDuration) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarMessage),
          duration: doubleBackDuration,
          backgroundColor: ColorSnackbarState.neutral.color,
        ));
        return Future.value(false);
      }
      onDoubleBack();
      return Future.value(true);
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
              onHorizontalDragUpdate: (details) async {
                if (details.delta.dx > 8) {
                  onWillPop;
                }
              },
              child: child,
            ),
          );
  }
}
