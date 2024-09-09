import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/shell_routes/home_route/home_desktop.dart';
import 'package:flutter_detextre4/routes/shell_routes/home_route/home_mobile.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int counter = 0;

  Future<void> incrementCounter() async {
    setState(() => counter++);
    showSnackbar("El contador ha incrementado");
  }

  @override
  Widget build(BuildContext context) {
    return HomeInherited(
      counter: counter,
      incrementCounter: incrementCounter,
      child: ResponsiveLayout(
        desktop: (context, constraints) => HomeDesktop(constraints),
        tablet: (context, constraints) => HomeMobile(constraints),
      ),
    );
  }
}

class HomeInherited extends InheritedWidget {
  const HomeInherited({
    super.key,
    required super.child,
    required this.counter,
    required this.incrementCounter,
  });
  final int counter;
  final Future<void> Function() incrementCounter;

  @override
  bool updateShouldNotify(HomeInherited oldWidget) =>
      counter != oldWidget.counter;
}
