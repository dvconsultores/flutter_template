import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/layouts/navigation_layout/navigation_layout.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/routes/landing_route/landing_route.dart';
import 'package:flutter_detextre4/routes/login_route/login_route.dart';
import 'package:flutter_detextre4/routes/shell_routes/home_route/home_route.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile_route/profile_route.dart';
import 'package:flutter_detextre4/routes/shell_routes/search_route/search_route.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final routerConfig = AppRouterConfig();

class AppRouterConfig {
  late GoRouter router;
  static Page pageBuilder(Widget child) => CustomTransitionPage(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            CustomTransitionWrapper(animation: animation, child: child),
        child: child,
      );

  AppRouterConfig() {
    setRouter();
  }

  void setRouter() => router = GoRouter(
          navigatorKey: ContextUtility.navigatorKey,
          initialLocation: "/",
          // errorBuilder: (context, state) {
          //   return const ErrorPage();
          // },
          redirect: (context, state) async {
            final location = state.path ?? '';

            final isLogged = (await SecureStorage.read<String?>(
                        SecureCollection.tokenAuth)) !=
                    null,
                requireAuth = !location.contains("/auth");

            if (requireAuth && !isLogged) {
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
                pageBuilder: (context, state) =>
                    pageBuilder(const LandingRoute()),
              ),

            GoRoute(
              path: '/auth',
              name: 'login',
              pageBuilder: (context, state) => pageBuilder(const LoginRoute()),
              routes: const [],
            ),

            // * shell routes
            ShellRoute(
                navigatorKey: ContextUtility.shellrouteKey,
                builder: (context, state, child) =>
                    NavigationLayout(state, child),
                routes: [
                  GoRoute(
                    path: '/profile',
                    name: "profile",
                    pageBuilder: (context, state) =>
                        pageBuilder(const ProfileRoute()),
                    routes: const [],
                  ),
                  GoRoute(
                    path: '/',
                    name: "home",
                    pageBuilder: (context, state) =>
                        pageBuilder(const HomeRoute()),
                    routes: const [],
                  ),
                  GoRoute(
                    path: '/search',
                    name: "search",
                    pageBuilder: (context, state) =>
                        pageBuilder(const SearchRoute()),
                    routes: const [],
                  ),
                ]),
          ]);
}

//! //FIXME search better practices
extension GoRouterExtension on GoRouter {
  /// Getter yo know if current route require authentication to show it
  bool get requireAuth => !(state?.path ?? '').contains('/auth');

  /// Get list of main routes on the [ShellRoute].
  List<RouteBase> get shellRoutes => configuration.routes
      .firstWhere((element) => element is ShellRoute)
      .routes;

  /// Get list of sub routes on the [ShellRoute].
  List<RouteBase>? get subShellRoutes => shellRoutes
      .firstWhereOrNull(
          (element) => (element as GoRoute).path.startsWith(state?.path ?? ''))
      ?.routes;

  /// Get index of the current [ShellRoute] displayed in Page.
  /// Returns -1 if [element] is not found.
  int get currentIndexShellRoute => shellRoutes.indexWhere((element) =>
      (element as GoRoute).path == "/${(state?.path ?? '').split('/')[1]}");

  /// Get the current [ShellRoute] displayed in Page.
  RouteBase? get currentShellRoute => currentIndexShellRoute == -1
      ? null
      : shellRoutes.elementAtOrNull(currentIndexShellRoute);
}

class Nav {
  @optionalTypeArgs
  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    required Widget page,
    bool hideBottomNavigationBar = false,
  }) async {
    final mainProvider = context.read<MainProvider>();
    mainProvider.setCurrentNavContext = context;

    final value = await Navigator.push<T>(
      context,
      !kIsWeb && Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );

    mainProvider.setCurrentNavContext = null;
    return value;
  }

  @optionalTypeArgs
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, {
    required Widget page,
    required RoutePredicate predicate,
    bool hideBottomNavigationBar = false,
  }) async {
    final mainProvider = context.read<MainProvider>();
    mainProvider.setCurrentNavContext = context;

    final value = await Navigator.pushAndRemoveUntil(
      context,
      !kIsWeb && Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
      predicate,
    );

    mainProvider.setCurrentNavContext = null;
    return value;
  }

  @optionalTypeArgs
  static Future<T?> pushReplacement<T extends Object?>(
    BuildContext context, {
    required Widget page,
    bool hideBottomNavigationBar = false,
  }) async {
    final mainProvider = context.read<MainProvider>();
    mainProvider.setCurrentNavContext = context;

    final value = await Navigator.pushReplacement(
      context,
      !kIsWeb && Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );

    mainProvider.setCurrentNavContext = null;
    return value;
  }
}
