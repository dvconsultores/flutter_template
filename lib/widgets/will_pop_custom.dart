import 'dart:io';
import 'package:flutter/material.dart';

class WillPopCustom extends StatelessWidget {
  const WillPopCustom({
    super.key,
    required this.child,
    required this.onWillPop,
  });
  final Widget child;
  final VoidCallback onWillPop;

  @override
  Widget build(BuildContext context) {
    return !Platform.isIOS
        ? WillPopScope(
            onWillPop: () async {
              onWillPop();
              return true;
            },
            child: child,
          )
        : WillPopScope(
            onWillPop: () => Future.value(false),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 8) {
                  onWillPop();
                }
              },
              child: child,
            ),
          );
  }
}
