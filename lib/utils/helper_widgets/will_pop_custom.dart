import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WillPopCustom extends StatelessWidget {
  const WillPopCustom({
    super.key,
    required this.child,
    this.onWillPop,
    this.enabled = true,
  });
  final Widget child;
  final FutureOr<bool> Function()? onWillPop;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // * Web
    if (kIsWeb || !enabled) return child;

    Future<bool> onWillPopCallback() async {
      if (onWillPop != null) return await onWillPop!();
      return true;
    }

    // * Android
    if (io.Platform.isAndroid) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: onWillPopCallback,
        child: child,
      );
    }

    // * IOS
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 8) onWillPopCallback();
        },
        child: child,
      ),
    );
  }
}
