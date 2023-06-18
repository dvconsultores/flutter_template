import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    // * Web
    if (kIsWeb) return child;

    Future<bool> onWillPopCallback() async {
      if (onWillPop != null) return await onWillPop!();
      return true;
    }

    // * Android
    if (Platform.isAndroid) {
      return WillPopScope(
        onWillPop: onWillPopCallback,
        child: child,
      );
    }

    // * IOS
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) =>
            (details.delta.dx > 8) ? onWillPopCallback() : true,
        child: child,
      ),
    );
  }
}
