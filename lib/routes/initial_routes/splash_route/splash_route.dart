import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/initial_routes/splash_route/splash_screen.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';

class SplashRoute extends StatefulWidget {
  const SplashRoute({super.key});

  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute>
    with SingleTickerProviderStateMixin {
  final int splashDuration = 1500;
  late final AnimationController animationController = AnimationController(
    lowerBound: 0.0,
    upperBound: 1.0,
    vsync: this,
    duration: Duration(milliseconds: splashDuration),
  );

  @override
  void initState() {
    animationController.forward().then((_) => router.go("/"));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animationCurve = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    final Animation<double> animMoveText = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(animationCurve);
    final Animation<double> animMoveFirstCube = Tween<double>(
      begin: 0.0,
      end: -125,
    ).animate(animationController);
    final Animation<double> animMoveSecondCube = Tween<double>(
      begin: 0.0,
      end: 125,
    ).animate(animationController);

    return SplashScreen(
      animationController: animationController,
      animationCurve: animationCurve,
      animMoveText: animMoveText,
      animMoveFirstCube: animMoveFirstCube,
      animMoveSecondCube: animMoveSecondCube,
    );
  }
}
