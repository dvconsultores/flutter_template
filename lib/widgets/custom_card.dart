import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(0),
    this.constraints,
    this.width,
    this.height,
    this.shape,
    this.borderRadius = BorderRadius.zero,
    this.borderSide = BorderSide.none,
    this.borderOnForeground = true,
    this.decorationClipBehavior,
    this.backgroundColor,
    this.elevation,
    this.semanticContainer = true,
    this.shadowColor,
    this.surfaceTintColor,
  });
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final ShapeBorder? shape;
  final BorderRadiusGeometry borderRadius;
  final BorderSide borderSide;
  final bool borderOnForeground;
  final Clip? decorationClipBehavior;
  final Color? backgroundColor;
  final double? elevation;
  final bool semanticContainer;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        constraints: constraints,
        child: Card(
          shape: shape ??
              RoundedRectangleBorder(
                  borderRadius: borderRadius, side: borderSide),
          borderOnForeground: borderOnForeground,
          clipBehavior: decorationClipBehavior,
          color: backgroundColor,
          elevation: elevation,
          margin: margin,
          semanticContainer: semanticContainer,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          child: Padding(padding: padding, child: child),
        ));
  }
}
