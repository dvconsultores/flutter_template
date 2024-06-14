import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

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
    this.shadowColor = Colors.black54,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(Vars.radius15)),
    ),
    this.clipBehavior = Clip.antiAliasWithSaveLayer,
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
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: margin,
        color: color ?? Colors.white,
        shadowColor: shadowColor,
        shape: shape,
        clipBehavior: clipBehavior,
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

class CardWidgetV2 extends StatelessWidget {
  const CardWidgetV2({
    super.key,
    required this.child,
    this.color,
    this.border,
    this.padding = const EdgeInsets.all(Vars.gapMedium),
    this.margin,
    this.boxShadow = const [Vars.boxShadow1],
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius10)),
    this.onTap,
    this.constraints,
    this.width = double.maxFinite,
    this.height,
  });
  final Widget child;
  final Color? color;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        constraints: constraints,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          color: color ?? Colors.white,
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}
