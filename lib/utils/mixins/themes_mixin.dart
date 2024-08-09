import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';

mixin ThemesMixin {
  static final context = ContextUtility.context!;

  final colors = ThemeApp.colors(context),
      styles = ThemeApp.styles(context),
      theme = Theme.of(context),
      media = MediaQuery.of(context);
}
