import 'dart:io';
import 'package:flutter/material.dart';

class WillPopCustom extends StatelessWidget {
  const WillPopCustom({
    super.key,
    required this.child,
    this.onWillPop,
    this.onWillPopCallback = defaultCallback,
  });
  final Widget child;
  final Future<bool> Function()? onWillPop;
  final VoidCallback onWillPopCallback;

  static defaultCallback() {}

  @override
  Widget build(BuildContext context) {
    return !Platform.isIOS
        // * Android
        ? WillPopScope(
            onWillPop: onWillPop ??
                () async {
                  onWillPopCallback();
                  return true;
                },
            child: child,
          )
        // * IOS
        : WillPopScope(
            onWillPop: () => Future.value(false),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 8) {
                  onWillPopCallback();
                }
              },
              child: child,
            ),
          );
  }
}
