import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_layout.dart';
import 'package:flutter_detextre4/routes/initial_routes/landing_route/landing_route.dart';
import 'package:flutter_detextre4/routes/initial_routes/splash_route/splash_route.dart';
import 'package:flutter_detextre4/routes/login_route/login_route.dart';
import 'package:flutter_detextre4/routes/shell_routes/home_route/home_route.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile_route/profile_route.dart';
import 'package:flutter_detextre4/routes/shell_routes/search_route/search_route.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:go_router/go_router.dart';

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
        return kIsWeb ? "/landing" : "/auth";
      }

      return null;
    },

    // ? Registered Routes
    routes: [
      //* top level
      if (kIsWeb)
        GoRoute(
          path: '/landing',
          name: 'landing',
          pageBuilder: (context, state) => _pageBuilder(const LandingRoute()),
        )
      else
        GoRoute(
          path: '/splash',
          name: 'splash',
          pageBuilder: (context, state) => _pageBuilder(const SplashRoute()),
        ),

      GoRoute(
        path: '/auth',
        name: 'login',
        pageBuilder: (context, state) => _pageBuilder(const LoginRoute()),
        routes: const [],
      ),

      // * shell routes
      ShellRoute(
          navigatorKey: ContextUtility.shellrouteKey,
          builder: (context, state, child) => NavigationLayout(state, child),
          routes: [
            GoRoute(
              path: '/profile',
              name: "profile",
              pageBuilder: (context, state) =>
                  _pageBuilder(const ProfileRoute()),
              routes: const [],
            ),
            GoRoute(
              path: '/',
              name: "home",
              pageBuilder: (context, state) => _pageBuilder(const HomeRoute()),
              routes: const [],
            ),
            GoRoute(
              path: '/search',
              name: "search",
              pageBuilder: (context, state) =>
                  _pageBuilder(const SearchRoute()),
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
}

class Nav {
  @optionalTypeArgs
  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    required Widget page,
    bool hideBottomNavigationBar = false,
  }) async {
    return await Navigator.push<T>(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );
  }

  @optionalTypeArgs
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, {
    required Widget page,
    required RoutePredicate predicate,
    bool hideBottomNavigationBar = false,
  }) async {
    return await Navigator.pushAndRemoveUntil(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
      predicate,
    );
  }

  @optionalTypeArgs
  static Future<T?> pushReplacement<T extends Object?>(
    BuildContext context, {
    required Widget page,
    bool hideBottomNavigationBar = false,
  }) async {
    return await Navigator.pushReplacement(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );
  }
}
