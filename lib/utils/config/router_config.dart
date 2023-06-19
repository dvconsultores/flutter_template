import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/routes/search/screens/list_screen.dart';
import 'package:flutter_detextre4/routes/splash_screen.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/routes/home/home_screen.dart';
import 'package:flutter_detextre4/routes/search/screens/search_screen.dart';
import 'package:flutter_detextre4/routes/search/screens/search_screen_two.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/routes/log_in_screen.dart';
import 'package:flutter_detextre4/routes/user/screens/user_screen.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_transition_wrapper.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:go_router/go_router.dart';

final locationExceptions = ["/splash", "/login"];

Page pageBuilder(Widget child) => CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          CustomTransitionWrapper(animation: animation, child: child),
    );

final GoRouter routerConfig = GoRouter(
    initialLocation: kIsWeb ? "/" : "/splash",
    // errorBuilder: (context, state) {
    //   return const ErrorScreen();
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
            const CustomTransitionWrapper(child: SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const CustomTransitionWrapper(child: LogInScreen()),
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
              pageBuilder: (context, state) => pageBuilder(const UserScreen()),
              routes: const [],
            ),
            GoRoute(
              name: "home",
              path: '/',
              pageBuilder: (context, state) => pageBuilder(const HomeScreen()),
              routes: const [],
            ),
            GoRoute(
                name: "search",
                path: '/search',
                pageBuilder: (context, state) =>
                    pageBuilder(const SearchScreen()),
                routes: [
                  GoRoute(
                    name: "search-two",
                    path: 'search-two',
                    pageBuilder: (context, state) =>
                        pageBuilder(const SearchScreenTwo()),
                  ),
                  GoRoute(
                    name: "list",
                    path: 'list',
                    pageBuilder: (context, state) =>
                        pageBuilder(const ListScreen()),
                  ),
                ]),
          ]),
    ]);
