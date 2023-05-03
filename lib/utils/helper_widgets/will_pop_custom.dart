import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';

class WillPopCustom extends StatelessWidget {
  const WillPopCustom({
    super.key,
    required this.child,
    this.onWillPop,
  });
  final Widget child;
  final Future<bool> Function()? onWillPop;

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPopCallback() async {
      if (onWillPop.isExist) return await onWillPop!();
      return true;
    }

    return !Platform.isIOS
        // * Android
        ? WillPopScope(
            onWillPop: onWillPopCallback,
            child: child,
          )
        // * IOS
        : WillPopScope(
            onWillPop: () => Future.value(false),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  (details.delta.dx > 8).inCase(onWillPopCallback),
              child: child,
            ),
          );
  }
}
