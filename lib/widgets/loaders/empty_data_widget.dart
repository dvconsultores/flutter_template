import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';

class EmptyDataWidget extends StatefulWidget {
  const EmptyDataWidget({
    super.key,
    this.width = 150,
    this.height = 130,
    this.label,
    this.labelText,
    this.labelStyle,
  });
  final double? width;
  final double? height;
  final Widget? label;
  final String? labelText;
  final TextStyle? labelStyle;

  @override
  State<EmptyDataWidget> createState() => _EmptyDataWidgetState();
}

class _EmptyDataWidgetState extends State<EmptyDataWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = widget.label ??
        Text(
          widget.labelText ?? 'No hay datos',
          textAlign: TextAlign.center,
          style: widget.labelStyle ??
              TextStyle(
                color: ThemeApp.of(context).colors.tertiary,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.lato("500"),
              ),
        );

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // Lottie.asset(
      //   'assets/animation/empty.json',
      //   fit: BoxFit.cover,
      //   width: widget.width,
      //   height: widget.height,
      //   controller: animationController,
      //   onLoaded: (lottieComposition) {
      //     animationController
      //       ..duration = lottieComposition.duration
      //       ..forward().whenComplete(() {
      //         animationController.stop();
      //       });
      //   },
      // ),
      labelWidget
    ]);
  }
}
