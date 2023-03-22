import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// * app snackbar
enum ColorSnackbarState {
  neutral(
    color: Colors.black54,
    textColor: Colors.white,
  ),
  success(
    color: Color.fromARGB(180, 76, 175, 79),
    textColor: Colors.black,
  ),
  warning(
    color: Color.fromARGB(180, 255, 235, 59),
    textColor: Colors.black,
  ),
  error(
    color: Color.fromARGB(180, 244, 67, 54),
    textColor: Colors.white,
  );

  const ColorSnackbarState({
    required this.color,
    required this.textColor,
  });
  final Color color;
  final Color textColor;
}

void appSnackbar(
  BuildContext context,
  String message, {
  required ColorSnackbarState type,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    message: message,
    backgroundColor: ColorSnackbarState.values.byName(type.name).color,
    messageColor: ColorSnackbarState.values.byName(type.name).textColor,
    duration: duration,
    borderRadius: BorderRadius.circular(6),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
  ).show(context);
}
