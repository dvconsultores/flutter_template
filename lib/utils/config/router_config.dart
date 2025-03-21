import 'dart:async';
import 'dart:io';

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
import 'package:flutter_detextre4/routes/splash_route/splash_route.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:flutter_detextre4/utils/services/initialization_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:go_router/go_router.dart';

final routerConfig = AppRouterConfig();

class AppRouterConfig {
  late GoRouter router;
  static Page pageBuilder(Widget child) => CustomTransitionPage(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            CustomTransitionWrapper(animation: animation, child: child),
        child: child,
      );

  static FutureOr<String?> Function(BuildContext, GoRouterState) get redirect =>
      (context, state) async {
        final mainProvider = MainProvider.read(context);

        if (mainProvider.currentNavContext != null &&
            mainProvider.currentNavContext!.mounted &&
            Navigator.canPop(mainProvider.currentNavContext!)) {
          Navigator.popUntil(
            mainProvider.currentNavContext!,
            (route) => route.isFirst,
          );
        }

        final location = state.path ?? '';

        if (mainProvider
                .initializationService.initialFetch.initialFetchStatus.value !=
            InitialFetchStatus.done) {
          if (state.uri.toString().contains("redirectPath")) return null;

          return '/splash?redirectPath=${Uri.encodeComponent(state.uri.toString())}';
        }

        final isLogged = (await SecureStorage.read<String?>(
                    SecureCollection.tokenAuth)) !=
                null,
            requireAuth = !location.contains("/auth");

        if (requireAuth && !isLogged) {
          return kIsWeb ? "/landing" : "/auth";
        }

        return null;
      };

  AppRouterConfig() {
    setRouter();
  }

  void setRouter() => router = GoRouter(
          navigatorKey: ContextUtility.navigatorKey,
          initialLocation: "/",
          // errorBuilder: (context, state) {
          //   return const ErrorPage();
          // },
          redirect: redirect,

          // ? Registered Routes
          routes: [
            //* top level
            GoRoute(
              path: '/splash',
              name: 'splash',
              pageBuilder: (context, state) {
                final redirectPath = state.uri.queryParameters['redirectPath'];

                return pageBuilder(
                  SplashRoute(
                    redirectPath: redirectPath != null
                        ? Uri.decodeComponent(redirectPath)
                        : redirectPath,
                  ),
                );
              },
            ),
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
                builder: (context, state, child) => NavigationLayout(
                      state,
                      child,
                      routerConfig.router.state.topRoute,
                    ),
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

extension GoRouterExtension on GoRouter {
  /// Getter yo know if current route require authentication to show it
  bool get requireAuth => !(state.fullPath ?? '').contains('/auth');

  /// Get list of main routes on the [ShellRoute].
  List<RouteBase> get shellRoutes => configuration.routes
      .firstWhere((element) => element is ShellRoute)
      .routes;
}

class Nav {
  @optionalTypeArgs
  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    required Widget page,
  }) async {
    MainProvider.read().setCurrentNavContext = context;

    return await Navigator.push<T>(
      context,
      !kIsWeb && Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );
  }

  @optionalTypeArgs
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, {
    required Widget page,
    required RoutePredicate predicate,
  }) async {
    MainProvider.read().setCurrentNavContext = context;

    return await Navigator.pushAndRemoveUntil(
      context,
      !kIsWeb && Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
      predicate,
    );
  }

  @optionalTypeArgs
  static Future<T?> pushReplacement<T extends Object?>(
    BuildContext context, {
    required Widget page,
  }) async {
    MainProvider.read().setCurrentNavContext = context;

    return await Navigator.pushReplacement(
      context,
      !kIsWeb && Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => page)
          : MaterialPageRoute(builder: (context) => page),
    );
  }
}
