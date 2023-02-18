import 'package:flutter/material.dart';

class GlobalFunctions {
  static void pushWithTransition(
    BuildContext context, {
    required Widget widget,
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
                  opacity: Tween<double>(begin: begin, end: end)
                      .animate(CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  )),
                  child: child),
        ),
      );
    });
  }

  static void pushReplacementWithTransition(
    BuildContext context, {
    required Widget widget,
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
                  opacity: Tween<double>(begin: begin, end: end)
                      .animate(CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  )),
                  child: child),
        ),
      );
    });
  }
}
