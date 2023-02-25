import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen_two.dart';
import 'package:flutter_detextre4/features/user/ui/screens/user_screen.dart';
import 'package:flutter_detextre4/home_screen.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:provider/provider.dart';

class NavigationRoutesModel {
  const NavigationRoutesModel({
    required this.name,
    required this.widget,
  });
  final NavigationRoutesName name;
  final Widget widget;
}

// * Router navigation config
// ? setup your custome route names
enum NavigationRoutesName {
  user,
  home,
  search,
  searchTwo;
}

// ? setup your custome routes
enum NavigationRoutes {
  userRoute(name: "User", icon: Icon(Icons.person), routes: [
    NavigationRoutesModel(
      name: NavigationRoutesName.user,
      widget: UserScreen(),
    ),
  ]),
  homeRoute(name: "Home", icon: Icon(Icons.home), routes: [
    NavigationRoutesModel(
      name: NavigationRoutesName.home,
      widget: HomeScreen(),
    ),
  ]),
  searchRoute(name: "Search", icon: Icon(Icons.search), routes: [
    NavigationRoutesModel(
      name: NavigationRoutesName.search,
      widget: SearchScreen(),
    ),
    NavigationRoutesModel(
      name: NavigationRoutesName.searchTwo,
      widget: SearchScreenTwo(),
    ),
  ]);

  const NavigationRoutes(
      {required this.routes, required this.icon, required this.name});
  final List<NavigationRoutesModel> routes;
  final Icon icon;
  final String name;
}

// ? Navigator extension
extension NavigatorExtension on Navigator {
  MainProvider getMainProvider(BuildContext context) =>
      Provider.of<MainProvider>(context, listen: false);

  // * router push
  void routerPush(BuildContext context, NavigationRoutesName name) =>
      getMainProvider(context).setCurrentNavigation = name;

  // * router back by
  void routerBackBy(BuildContext context, int index) =>
      getMainProvider(context).setRouteBackBy = index;

// * router back until first
  void routerBackUntilFirst(BuildContext context) =>
      getMainProvider(context).setRouteBackUntilFirst();

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
