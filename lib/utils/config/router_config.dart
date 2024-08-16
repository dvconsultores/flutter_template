import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/routes/login_page.dart';
import 'package:flutter_detextre4/routes/shell_routes/home/home_page.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile/pages/user_page.dart';
import 'package:flutter_detextre4/routes/shell_routes/search/pages/list_page.dart';
import 'package:flutter_detextre4/routes/splash_page.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Page _pageBuilder(Widget child) => CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          CustomTransitionWrapper(animation: animation, child: child),
      child: child,
    );

final GoRouter router = GoRouter(
    navigatorKey: ContextUtility.navigatorKey,
    initialLocation: kIsWeb ? "/" : "/splash",
    // errorBuilder: (context, state) {
    //   return const ErrorPage();
    // },
    redirect: (context, state) async {
      final isLogged =
          (await SecureStorage.read<String?>(SecureCollection.tokenAuth)) !=
              null;

      if (state.location == "/splash") {
        return null;
      } else if (router.requireAuth && !isLogged) {
        return "/auth";
      }

      return null;
    },

    // ? Registered Routes
    routes: [
      //* top level
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => _pageBuilder(const SplashPage()),
      ),

      GoRoute(
        path: '/auth',
        name: 'login',
        pageBuilder: (context, state) => _pageBuilder(const LoginPage()),
        routes: const [],
      ),

      // * shell routes
      ShellRoute(
          navigatorKey: ContextUtility.shellrouteKey,
          builder: (context, state, child) => MainNavigation(state, child),
          routes: [
            GoRoute(
              path: '/profile',
              name: "profile",
              pageBuilder: (context, state) => _pageBuilder(const UserPage()),
              routes: const [],
            ),
            GoRoute(
              path: '/',
              name: "home",
              pageBuilder: (context, state) => _pageBuilder(const HomePage()),
              routes: const [],
            ),
            GoRoute(
              path: '/search',
              name: "search",
              pageBuilder: (context, state) => _pageBuilder(const ListPage()),
              routes: const [],
            ),
          ]),
    ]);

//! //FIXME search better practices
extension GoRouterExtension on GoRouter {
  /// Getter yo know if current route require authentication
  get requireAuth => !router.location.contains('/auth');

  /// Get list of main routes on the [ShellRoute].
  List<RouteBase> get shellRoutes => router.configuration.routes
      .firstWhere((element) => element is ShellRoute)
      .routes;

  /// Get list of sub routes on the [ShellRoute].
  List<RouteBase>? get subShellRoutes => shellRoutes
      .firstWhereOrNull(
          (element) => (element as GoRoute).path.startsWith(location))
      ?.routes;

  /// Get index of the current [ShellRoute] displayed in Page.
  /// Returns -1 if [element] is not found.
  int get indexShellRoute => shellRoutes.indexWhere(
      (element) => (element as GoRoute).path == "/${location.split('/')[1]}");

  /// Get the current [ShellRoute] displayed in Page.
  RouteBase? get shellRoute => indexShellRoute == -1
      ? null
      : shellRoutes.elementAtOrNull(indexShellRoute);

  /// Function to show [AppBottomNavigationBar] widget.
  void showBottomNavigationBar() =>
      ContextUtility.context!.read<MainProvider>().showBottomNavigationBar();

  /// Function to hide [AppBottomNavigationBar] widget.
  void hideBottomNavigationBar() =>
      ContextUtility.context!.read<MainProvider>().hideBottomNavigationBar();
}

class Nav {
  @optionalTypeArgs
  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    required Widget page,
    bool hideBottomNavigationBar = false,
  }) async {
    if (hideBottomNavigationBar) router.hideBottomNavigationBar();

    final value = await Navigator.push<T>(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );

    if (hideBottomNavigationBar) router.showBottomNavigationBar();
    

    return value;
  }

  @optionalTypeArgs
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, {
    required Widget page,
    required RoutePredicate predicate,
    bool hideBottomNavigationBar = false,
  }) async {
    if (hideBottomNavigationBar) router.hideBottomNavigationBar();
    final value = await Navigator.pushAndRemoveUntil(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
      predicate,
    );

    if (hideBottomNavigationBar) router.showBottomNavigationBar();
    

    return value;
  }

  @optionalTypeArgs
  static Future<T?> pushReplacement<T extends Object?>(
    BuildContext context, {
    required Widget page,
    bool hideBottomNavigationBar = false,
  }) async {
    if (hideBottomNavigationBar) router.hideBottomNavigationBar();
    final value = await Navigator.pushReplacement(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );

    if (hideBottomNavigationBar) router.showBottomNavigationBar();
    

    return value;
  }
}
