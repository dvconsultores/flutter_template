import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.animationController,
    required this.animationCurve,
    required this.animMoveText,
    required this.animMoveFirstCube,
    required this.animMoveSecondCube,
  });
  final AnimationController animationController;
  final Animation<double> animationCurve;
  final Animation<double> animMoveText;
  final Animation<double> animMoveFirstCube;
  final Animation<double> animMoveSecondCube;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        // * background
        SizedBox(
          width: size.width,
          height: size.height,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                ThemeApp.colors(context).primary,
                ThemeApp.colors(context).secondary,
              ]),
            )),
          ),
        ),

        // * animated cube one
        AnimatedBuilder(
          animation: animMoveSecondCube,
          builder: (context, child) {
            return Positioned(
              top: size.height * 0.60,
              left: size.width * 0.125,
              child: Transform.translate(
                  offset: Offset(
                    animMoveSecondCube.value,
                    -animMoveSecondCube.value,
                  ),
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: child,
                  )),
            );
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Vars.gapMax),
              color: ThemeApp.colors(context).accent,
            ),
          ),
        ),

        // * logo
        Positioned(
          top: size.height * 0.33,
          left: 0,
          right: 0,
          child: Hero(
            tag: "logo demo",
            child: Column(children: [
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) => Transform.scale(
                  scale: animationCurve.value,
                  child: child,
                ),
                child: Image.asset(
                  'assets/images/avatar.png',
                  height: size.height * 0.15,
                ),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) => Transform.scale(
                    scale: animationCurve.value,
                    child: Transform.translate(
                      offset: Offset(0, animMoveText.value),
                      child: child,
                    )),
                child: const Material(
                    color: Colors.transparent,
                    child: Text(
                      'Flutter Demo',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    )),
              ),
            ]),
          ),
        ),

        // * animated cube two
        AnimatedBuilder(
          animation: animMoveFirstCube,
          builder: (context, child) {
            return Positioned(
                bottom: size.height * 0.075,
                right: 0,
                child: Transform.translate(
                  offset: Offset(animMoveFirstCube.value, 0),
                  child: child,
                ));
          },
          child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Vars.radius20),
                color: ThemeApp.colors(context).focusColor,
              )),
        ),
      ]),
    );
  }
}
