import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ExpandsWrapper extends StatefulWidget {
  final AnimationController? controller;
  final Widget Function(
    BuildContext context,
    AnimationController animationController,
    VoidCallback handlerExpands,
  ) child;
  final VoidCallback? onTap;
  final Widget Function(BuildContext context)? desplegableBuilder;
  final double desplegableGap;
  const ExpandsWrapper({
    super.key,
    this.controller,
    required this.child,
    this.onTap,
    this.desplegableBuilder,
    this.desplegableGap = 0,
  });

  @override
  State<ExpandsWrapper> createState() => _ExpandsWrapperState();
}

class _ExpandsWrapperState extends State<ExpandsWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController animController;

  AnimationController get animationController =>
      widget.controller ?? animController;

  @override
  void initState() {
    animController =
        AnimationController(vsync: this, duration: Durations.short2)
          ..drive(CurveTween(curve: Curves.bounceIn));
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handlerExpands() => animationController.isCompleted
        ? animationController.reverse()
        : animationController.forward();

    return Column(children: [
      widget.child(context, animationController, handlerExpands),
      if (widget.desplegableBuilder != null)
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final translate =
                    Tween<double>(begin: -widget.desplegableGap, end: 0)
                        .animate(animationController),
                opacity = Tween<double>(begin: 0, end: 1)
                    .animate(animationController);

            if (animationController.isAnimating ||
                animationController.isCompleted) {
              return Opacity(
                opacity: opacity.value,
                child: Transform.translate(
                  offset: Offset(0, translate.value),
                  child: child!,
                ),
              );
            }

            return const SizedBox.shrink();
          },
          child: Column(children: [
            Gap(widget.desplegableGap).column,
            widget.desplegableBuilder!(context)
          ]),
        ),
    ]);
  }
}
