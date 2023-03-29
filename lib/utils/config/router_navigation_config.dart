import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen_two.dart';
import 'package:flutter_detextre4/features/user/ui/screens/user_screen.dart';
import 'package:flutter_detextre4/home_screen.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:provider/provider.dart';

// * Router navigation config
///? Collection of allowed routes from app.
///
/// ? here can setup your custome route names.
enum NavigationRoutesName {
  user,
  home,
  search,
  searchTwo,
}

// ? setup your custome routes
/// Navigator router configuration class from app.
enum NavigationRoutes {
  userRoute(name: "User", icon: Icon(Icons.person), routes: [
    NavigationRoutesModel(
      name: NavigationRoutesName.user,
      page: UserScreen(),
    ),
  ]),
  homeRoute(name: "Home", icon: Icon(Icons.home), routes: [
    NavigationRoutesModel(
      name: NavigationRoutesName.home,
      page: HomeScreen(),
    ),
  ]),
  searchRoute(name: "Search", icon: Icon(Icons.search), routes: [
    NavigationRoutesModel(
      name: NavigationRoutesName.search,
      page: SearchScreen(),
    ),
    NavigationRoutesModel(
      name: NavigationRoutesName.searchTwo,
      page: SearchScreenTwo(),
    ),
  ]);

  const NavigationRoutes({
    required this.routes,
    required this.icon,
    required this.name,
  });
  final List<NavigationRoutesModel> routes;
  final Icon icon;
  final String name;
}

// ? --------------------- Navigator extension ------------------------------ //
extension NavigatorExtension on Navigator {
  MainProvider get getMainProvider =>
      Provider.of<MainProvider>(globalNavigatorKey.currentContext!,
          listen: false);

  ///* Push any route using router navigator from app.
  ///
  /// if widget is not founded into [NavigationRoutes] will pushed using
  /// [push] method from [Navigator].
  void routerPush(Widget page) => getMainProvider.setCurrentNavigation = page;

  ///* Push any route using router navigator from app.
  void routerPushByName(NavigationRoutesName name) =>
      getMainProvider.setCurrentNavigationByName = name;

  ///* Go back based on router navigator cache.
  void routerBack() => getMainProvider.setRouteBack();

  ///* Go back based on quantity provided.
  void routerBackBy(int index) => getMainProvider.setRouteBackBy = index;

  ///* Go to the first route from the current router navigator cache.
  void routerBackUntilFirst() => getMainProvider.setRouteBackUntilFirst();

  ///* Normal [push] method from [Navigator] with custome transition.
  void pushWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) =>
      WidgetsBinding.instance
          .addPostFrameCallback((timeStamp) => Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: transitionDuration,
                  pageBuilder: (context, animation, secondaryAnimation) => page,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                              opacity: Tween<double>(begin: begin, end: end)
                                  .animate(CurvedAnimation(
                                parent: animation,
                                curve: curve,
                              )),
                              child: child),
                ),
              ));

  ///* Normal [pushReplacement] method from [Navigator] with custome transition.
  void pushReplacementWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) =>
      WidgetsBinding.instance
          .addPostFrameCallback((timeStamp) => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: transitionDuration,
                  pageBuilder: (context, animation, secondaryAnimation) => page,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                              opacity: Tween<double>(begin: begin, end: end)
                                  .animate(CurvedAnimation(
                                parent: animation,
                                curve: curve,
                              )),
                              child: child),
                ),
              ));
}

// ? ------------------------ Navigator models ------------------------------ //

class NavigationRoutesModel {
  const NavigationRoutesModel({
    required this.name,
    required this.page,
  });
  final NavigationRoutesName name;
  final Widget page;
}

class CachedIndexNavigation {
  const CachedIndexNavigation({
    required this.indexTab,
    required this.indexRoute,
  });
  final int indexTab;
  final int indexRoute;
}
