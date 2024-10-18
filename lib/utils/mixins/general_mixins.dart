import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:provider/provider.dart';

final _context = ContextUtility.context!;

mixin ThemesMixin {
  final themeApp = ThemeApp.of(_context),
      theme = Theme.of(_context),
      media = MediaQuery.of(_context);
}

mixin ProviderMixin {
  final mainProvider = Provider.of<MainProvider>(_context, listen: false),
      mainProviderListenable = Provider.of<MainProvider>(_context);
}
