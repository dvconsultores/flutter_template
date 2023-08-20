import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/routes/search/pages/list_page.dart';
import 'package:flutter_detextre4/routes/splash_page.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/routes/home/home_page.dart';
import 'package:flutter_detextre4/routes/search/pages/search_page.dart';
import 'package:flutter_detextre4/routes/search/pages/search_page_two.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/routes/log_in_page.dart';
import 'package:flutter_detextre4/routes/user/pages/user_page.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:go_router/go_router.dart';

final locationExceptions = ["/splash", "/login"];

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
      final isLogged = await BlocProvider.of<UserBloc>(context).isLogged;

      if (state.location == "/splash") {
        return null;
      } else if (!isLogged) {
        return "/login";
      } else if (locationExceptions.contains(state.location) && isLogged) {
        return "/";
      }

      return null;
    },

    // ? Registered Routes
    routes: [
      //* top level
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const CustomTransitionWrapper(child: SplashPage()),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const CustomTransitionWrapper(child: LogInPage()),
        routes: const [],
      ),
      ShellRoute(
          navigatorKey: globalNavigatorKey,
          builder: (context, state, child) =>
              CustomTransitionWrapper(child: MainNavigation(state, child)),

          // * shell routes
          routes: [
            GoRoute(
              name: "user",
              path: '/user',
              pageBuilder: (context, state) => _pageBuilder(const UserPage()),
              routes: const [],
            ),
            GoRoute(
              name: "home",
              path: '/',
              pageBuilder: (context, state) => _pageBuilder(const HomePage()),
              routes: const [],
            ),
            GoRoute(
                name: "search",
                path: '/search',
                pageBuilder: (context, state) =>
                    _pageBuilder(const SearchPage()),
                routes: [
                  GoRoute(
                    name: "search-two",
                    path: 'search-two',
                    pageBuilder: (context, state) =>
                        _pageBuilder(const SearchPageTwo()),
                  ),
                  GoRoute(
                    name: "list",
                    path: 'list',
                    pageBuilder: (context, state) =>
                        _pageBuilder(const ListPage()),
                  ),
                ]),
          ]),
    ]);

extension GoRouterExtension on GoRouter {
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
