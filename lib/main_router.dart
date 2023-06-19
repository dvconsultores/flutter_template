import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/splash_screen.dart';
import 'package:flutter_detextre4/global_widgets/app_drawer.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/routes/home/home_screen.dart';
import 'package:flutter_detextre4/routes/search/screens/list_screen.dart';
import 'package:flutter_detextre4/routes/search/screens/search_screen.dart';
import 'package:flutter_detextre4/routes/search/screens/search_screen_two.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/routes/log_in_screen.dart';
import 'package:flutter_detextre4/routes/user/screens/user_screen.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/helper_widgets/double_back_to_close_widget.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:go_router/go_router.dart';

final locationExceptions = ["/splash", "/login"];

Page pageBuilder(context, state, Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

final GoRouter routerConfig = GoRouter(
    initialLocation: "/splash",
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
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LogInScreen(),
      ),

      ShellRoute(
        navigatorKey: globalNavigatorKey,
        routes: [
          // * route
          GoRoute(
            name: "user",
            path: '/user',
            pageBuilder: (context, state) =>
                pageBuilder(context, state, const UserScreen()),
            routes: const [],
          ),
          // * route
          GoRoute(
            name: "home",
            path: '/',
            pageBuilder: (context, state) =>
                pageBuilder(context, state, const HomeScreen()),
            routes: const [],
          ),
          // * route
          GoRoute(
              name: "search",
              path: '/search',
              pageBuilder: (context, state) =>
                  pageBuilder(context, state, const SearchScreen()),
              routes: [
                // * sub routes
                GoRoute(
                  name: "search-two",
                  path: 'search-two',
                  pageBuilder: (context, state) =>
                      pageBuilder(context, state, const SearchScreenTwo()),
                ),
                GoRoute(
                  name: "list",
                  path: 'list',
                  pageBuilder: (context, state) =>
                      pageBuilder(context, state, const ListScreen()),
                ),
              ]),
        ],

        // ? Router builder
        builder: (context, state, child) {
          final routes = routerConfig.configuration.routes
              .firstWhere((element) => element is ShellRoute)
              .routes;
          final indexTab = routes.indexWhere((element) =>
              (element as GoRoute).path == "/${state.location.split('/')[1]}");
          final subRoutes = routes
              .firstWhereOrNull((element) =>
                  (element as GoRoute).path.startsWith(state.location))
              ?.routes;
          final currentSubRoute = subRoutes?.any(
              (element) => (element as GoRoute).path.contains(state.location));

          return AppScaffold(
            drawer: currentSubRoute != null ? const AppDrawer() : null,
            appBar: AppBar(
              leading: currentSubRoute == null
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: context.pop,
                    )
                  : null,
              title: Text((routes[indexTab] as GoRoute).name ?? ""),
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context),
              child: BottomNavigationBar(
                currentIndex: indexTab,
                onTap: (index) => context.go((routes[index] as GoRoute).path),
                selectedItemColor: ThemeApp.colors(context).focusColor,
                items: routes
                    .map((element) => BottomNavigationBarItem(
                          label: "",
                          tooltip: (element as GoRoute).name?.toCapitalize(),
                          icon: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: element.name == "user"
                                ? const Icon(Icons.person)
                                : element.name == "home"
                                    ? const Icon(Icons.home)
                                    : const Icon(Icons.search),
                          ),
                        ))
                    .toList(),
              ),
            ),
            child: state.location == "/"
                ? DoubleBackToCloseWidget(
                    snackBarMessage: "Press again to leave",
                    child: child,
                  )
                : WillPopCustom(
                    onWillPop: () async {
                      context.go("/");
                      return false;
                    },
                    child: child,
                  ),
          );
        },
      ),
    ]);
