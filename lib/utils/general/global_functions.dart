import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/model/language_list.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:provider/provider.dart';

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
  String message, {
  required ColorSnackbarState type,
  Duration? duration,
}) {
  Flushbar(
    message: message,
    backgroundColor: ColorSnackbarState.values.byName(type.name).color,
    messageColor: ColorSnackbarState.values.byName(type.name).textColor,
    duration: duration ?? const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(6),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
  ).show(globalNavigatorKey.currentContext!);
}

/// A global function to change current language.
void changeLanguage(LanguageList value) =>
    Provider.of<MainProvider>(globalNavigatorKey.currentContext!, listen: false)
        .changeLocale = value;

// * Sort Data
/// Will return sortBy sended into function aswell will sort `List` provided
/// in parameters.
String? sortData({
  required List<Map<String, dynamic>> data,
  required List<Map<String, dynamic>> dataFiltered,
  required String? currentSort,
  required String sortBy,
  List<String>? exclude,
}) {
  if (exclude.isExist && exclude!.contains(sortBy)) return null;

  if (currentSort != sortBy) {
    dataFiltered.sort(
      (a, b) => (a[sortBy] as String)
          .toLowerCase()
          .compareTo((b[sortBy] as String).toLowerCase()),
    );
    return sortBy;
  }

  dataFiltered.clear();
  dataFiltered.addAll(data);
  return null;
}
