import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget({
    super.key,
    required this.snackBarMessage,
    required this.child,
    this.onDoubleBack,
    this.doubleBackDuration = const Duration(milliseconds: 1350),
  });
  final Widget child;
  final String snackBarMessage;
  final FutureOr<bool> Function()? onDoubleBack;
  final Duration doubleBackDuration;

  @override
  State<DoubleBackToCloseWidget> createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // * Web
    if (kIsWeb) return widget.child;

    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();

      if (currentBackPressTime.isNotExist ||
          now.difference(currentBackPressTime!) > widget.doubleBackDuration) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.snackBarMessage),
          duration: widget.doubleBackDuration,
          backgroundColor: Colors.black54,
        ));
        return false;
      }

      if (widget.onDoubleBack.isExist) return await widget.onDoubleBack!();

      return true;
    }

    // * Android
    if (io.Platform.isAndroid) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: widget.child,
      );
    }

    // * IOS
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) =>
            (details.delta.dx > 8).inCase(onWillPop),
        child: widget.child,
      ),
    );
  }
}
