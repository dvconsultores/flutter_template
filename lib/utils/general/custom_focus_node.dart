import 'package:flutter/material.dart';

class CustomFocusNode extends ValueNotifier<bool> {
  CustomFocusNode([bool value = false]) : super(value);

  void focus() => value = true;
  void unfocus() => value = false;

  @override
  bool get hasListeners => super.hasListeners;
}
