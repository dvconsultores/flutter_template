import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

extension HiveEnumToString on Enum {
  String get name => toString().split('.').last;
}

extension DateTimeToString on DateTime {
  String get parseToString => toString();
  String get toDateString {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }
}

extension StringToDateTime on String {
  DateTime get parseToDateTime => DateTime.parse(this);
}

extension FileToBase64 on File {
  String get parseToBase64 {
    final Uint8List v = readAsBytesSync();
    // print('v: $v');
    // print('parseToBase64: ${base64Encode(v)}$path');
    return base64Encode(v);
  }
}

extension Base64ToFile on String {
  File get parseBase64ToFile => File.fromRawPath(base64Decode(this));
}

extension NavigatorExtension on Navigator {
  // * push with transition
  void pushWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: transitionDuration,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                        opacity: Tween<double>(begin: begin, end: end)
                            .animate(CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        )),
                        child: child),
          ),
        ));
  }

  // * push replacement with transition
  void pushReplacementWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: transitionDuration,
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(
                            opacity: Tween<double>(begin: begin, end: end)
                                .animate(CurvedAnimation(
                              parent: animation,
                              curve: curve,
                            )),
                            child: child),
              ),
            ));
  }
}
