import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';

// * App snackbar
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

/// A global snackbar that can be invoked onto whatever widget.
void appSnackbar(
  String? message, {
  ColorSnackbarState? type,
  Duration? duration,
}) {
  if (message.hasNotValue) return;

  Flushbar(
    message: message,
    backgroundColor: ColorSnackbarState.values
        .byName(type?.name ?? ColorSnackbarState.neutral.name)
        .color,
    messageColor: ColorSnackbarState.values
        .byName(type?.name ?? ColorSnackbarState.neutral.name)
        .textColor,
    duration: duration ?? const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(6),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
  ).show(globalNavigatorKey.currentContext!);
}

// * Sort Data
/// Will return sortBy sended into function aswell will sort `List` provided
/// in parameters.
String? sortData({
  required List<dynamic> data,
  required List<dynamic> dataFiltered,
  required String? currentSort,
  required String sortBy,
  List<String>? exclude,
}) {
  if (exclude.isExist && exclude!.contains(sortBy)) return null;

  if (currentSort != sortBy) {
    dataFiltered.sort(
      (a, b) {
        final valueA = a is Map ? a : a.toMap();
        final valueB = b is Map ? b : b.toMap();

        return (valueA[sortBy] as String)
            .toLowerCase()
            .compareTo((valueB[sortBy] as String).toLowerCase());
      },
    );
    return sortBy;
  }

  dataFiltered.clear();
  dataFiltered.addAll(data);
  return null;
}
