import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/routes/log_in_page.dart';
import 'package:flutter_detextre4/routes/shell_routes/search/pages/list_page.dart';
import 'package:flutter_detextre4/routes/splash_page.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/routes/shell_routes/home/home_page.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile/pages/user_page.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:go_router/go_router.dart';

Page _pageBuilder(Widget child) => CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          CustomTransitionWrapper(animation: animation, child: child),
    );

final GoRouter router = GoRouter(
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
        return "/auth/login";
      }

      return null;
    },

    // ? Registered Routes
    routes: [
      //* top level
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) =>
            const CustomTransitionWrapper(child: SplashPage()),
      ),

      GoRoute(
          path: '/auth',
          builder: (context, state) => const SizedBox.shrink(),
          redirect: (context, state) =>
              state.path == '/auth' ? '/auth/login' : null,
          routes: [
            GoRoute(
              path: 'login',
              name: 'login',
              builder: (context, state) =>
                  const CustomTransitionWrapper(child: LogInPage()),
            )
          ]),

      // * shell routes
      ShellRoute(
          navigatorKey: globalNavigatorKey,
          builder: (context, state, child) =>
              CustomTransitionWrapper(child: MainNavigation(state, child)),
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
}
