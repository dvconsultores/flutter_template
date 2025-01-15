import 'package:flutter/material.dart';

class CustomFocusNode extends ValueNotifier<bool> {
  CustomFocusNode([super.value = false]);

  void focus() => value = true;
  void unfocus() => value = false;

  @override
  bool get hasListeners => super.hasListeners;
}
