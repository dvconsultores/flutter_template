import 'package:flutter/material.dart';

final _navigatorKey =
        GlobalKey<NavigatorState>(debugLabel: 'ContextUtilityNavigatorKey'),
    _shellrouteKey =
        GlobalKey<NavigatorState>(debugLabel: 'ContextUtilityShellrouteKey'),
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(
        debugLabel: 'ContextUtilityScaffoldMessengerKey');

class ContextUtility {
  // navigator
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static bool get hasNavigator => navigatorKey.currentState != null;
  static NavigatorState? get navigator => navigatorKey.currentState;

  static bool get hasContext => navigatorKey.currentContext != null;
  static BuildContext? get context => navigatorKey.currentContext;

  // shell route
  static GlobalKey<NavigatorState> get shellrouteKey => _shellrouteKey;

  static bool get hasShellroute => shellrouteKey.currentState != null;
  static NavigatorState? get shellroute => shellrouteKey.currentState;

  static bool get hasShellrouteContext => shellrouteKey.currentContext != null;
  static BuildContext? get shellrouteContext => shellrouteKey.currentContext;

  // scaffold messenger
  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  static bool get hasScaffoldMessenger =>
      scaffoldMessengerKey.currentState != null;
  static ScaffoldMessengerState? get scaffoldMessenger =>
      scaffoldMessengerKey.currentState;

  static bool get hasScaffoldMessengerContext =>
      scaffoldMessengerKey.currentContext != null;
  static BuildContext? get scaffolMessengerContext =>
      scaffoldMessengerKey.currentContext;
}
