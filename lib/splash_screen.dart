import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/user/ui/screens/sign_in_screen.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/const/global_functions.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    lowerBound: 0.0,
    upperBound: 1.0,
    vsync: this,
    duration: const Duration(
      milliseconds: 1500,
    ),
  );

  void goToNextPage() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // ignore: use_build_context_synchronously
    GlobalFunctions.pushReplacementWithTransition(context,
        widget: const SignInScreen());
  }

  @override
  void didChangeDependencies() {
    goToNextPage();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
    animationController.forward().then(
          (value) {},
        );

    return Scaffold(
      body: Stack(
        children: [
          // * background
          SizedBox(
            width: size.width,
            height: size.height,
            child: RotatedBox(
              quarterTurns: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.getColor(context, ColorType.primary)!,
                      AppColors.getColor(context, ColorType.secondary)!,
                    ],
                  ),
                ),
              ),
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
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.getColor(context, ColorType.accent),
              ),
              width: 60,
              height: 60,
            ),
          ),

          // * logo
          Positioned(
            top: size.height * 0.33,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Transform.scale(
                    scale: animationCurve.value,
                    child: child,
                  ),
                  child: Hero(
                    tag: 'Logo Icon',
                    child: Image.asset(
                      'assets/images/avatar.png',
                      height: size.height * 0.15,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Transform.scale(
                    scale: animationCurve.value,
                    child: Transform.translate(
                      offset: Offset(0, animMoveText.value),
                      child: child,
                    ),
                  ),
                  child: const Hero(
                    tag: 'Logo Title',
                    child: Text(
                      'Flutter Demo',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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
                  offset: Offset(
                    animMoveFirstCube.value,
                    0,
                  ),
                  child: child,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.getColor(context, ColorType.active),
              ),
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
