import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen_two.dart';
import 'package:flutter_detextre4/features/user/ui/screens/user_screen.dart';
import 'package:flutter_detextre4/home_screen.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:provider/provider.dart';

// * Router navigation config
enum NavigationRoutesPath {
  user,
  home,
  search,
  searchTwo;
}

enum NavigationRoutes {
  userRoute(name: "User", icon: Icon(Icons.person), routes: [
    {
      "path": NavigationRoutesPath.user,
      "widget": UserScreen(),
    },
  ]),
  homeRoute(name: "Home", icon: Icon(Icons.home), routes: [
    {
      "path": NavigationRoutesPath.home,
      "widget": HomeScreen(),
    },
  ]),
  searchRoute(name: "Search", icon: Icon(Icons.search), routes: [
    {
      "path": NavigationRoutesPath.search,
      "widget": SearchScreen(),
    },
    {
      "path": NavigationRoutesPath.searchTwo,
      "widget": SearchScreenTwo(),
    },
  ]);

  const NavigationRoutes(
      {required this.routes, required this.icon, required this.name});
  final List<Map<String, dynamic>> routes;
  final Icon icon;
  final String name;
}

// ? Navigator extension
extension NavigatorExtension on Navigator {
  // * router push
  void routerPush(BuildContext context, NavigationRoutesPath path) =>
      Provider.of<MainProvider>(context, listen: false).setCurrentNavigation =
          path;

  // * router back by
  void routerBackBy(BuildContext context, int index) =>
      Provider.of<MainProvider>(context, listen: false).setRouteBackBy = index;

// * router back until first
  void routerBackUntilFirst(BuildContext context) =>
      Provider.of<MainProvider>(context, listen: false)
          .setRouteBackUntilFirst();

  // * push with transition
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

  // * push replacement with transition
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
