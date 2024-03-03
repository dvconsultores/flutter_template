import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/Variables.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    this.color,
    this.onTap,
    this.elevation = 12.5,
    this.constraints,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(Vars.gapMedium),
    this.margin = const EdgeInsets.all(0),
    this.child,
  });

  final Color? color;
  final void Function()? onTap;
  final EdgeInsets? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: margin,
        color: color ?? Colors.white,
        shadowColor: Colors.black54,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(Vars.radius30)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: elevation,
        child: Container(
          width: width,
          height: height,
          constraints: constraints,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
