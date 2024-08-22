import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

class CustomCircleAvatar extends HeroMode {
  CustomCircleAvatar({
    super.key,
    final bool heroEnabled = false,
    final Object heroTag = "circleAvatar",
    final EdgeInsetsGeometry? padding,
    final EdgeInsetsGeometry? margin,
    final Color? color,
    final Gradient? gradient,
    final List<BoxShadow> boxShadow = const [Vars.boxShadow1],
    final BoxBorder? border,
    final double? radius,
    final double? maxRadius,
    final double? minRadius,
    final Color? backgroundColor,
    final ImageProvider<Object>? backgroundImage,
    final Color? foregroundColor,
    final ImageProvider<Object>? foregroundImage,
    final void Function(Object, StackTrace?)? onBackgroundImageError,
    final void Function(Object, StackTrace?)? onForegroundImageError,
    final List<Widget> Function(BuildContext context, Widget child)?
        decoratorBuilder,
  }) : super(
            enabled: heroEnabled,
            child: Builder(builder: (context) {
              final widget = Hero(
                tag: heroTag,
                child: Container(
                    padding: padding,
                    margin: margin,
                    decoration: BoxDecoration(
                      boxShadow: boxShadow,
                      color: color,
                      border: border,
                      gradient: gradient,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: radius,
                      maxRadius: maxRadius,
                      minRadius: minRadius,
                      backgroundColor: backgroundColor,
                      backgroundImage: backgroundImage,
                      foregroundColor: foregroundColor,
                      foregroundImage: foregroundImage,
                      onBackgroundImageError: onBackgroundImageError,
                      onForegroundImageError: onForegroundImageError,
                    )),
              );

              if (decoratorBuilder == null) return widget;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: decoratorBuilder(context, widget),
              );
            }));

  static CustomCircleAvatar badged({
    Widget? badge,
    List<BoxShadow> badgeBoxShadow = const [Vars.boxShadow3],
    Color badgeColor = Colors.white,
    BoxBorder? badgeBorder,
    double badgeSize = 20,
    double? offsetLeft,
    double? offsetRight = -3,
    double? offsetTop,
    double? offsetBottom = -3,
    bool heroEnabled = false,
    Object heroTag = "circleAvatar",
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    List<BoxShadow> boxShadow = const [Vars.boxShadow1],
    BoxBorder? border,
    double? radius,
    double? maxRadius,
    double? minRadius,
    Color? backgroundColor,
    ImageProvider<Object>? backgroundImage,
    Color? foregroundColor,
    ImageProvider<Object>? foregroundImage,
    void Function(Object, StackTrace?)? onBackgroundImageError,
    void Function(Object, StackTrace?)? onForegroundImageError,
    List<Widget> Function(BuildContext context, Widget child)? decoratorBuilder,
  }) =>
      CustomCircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: backgroundImage,
        border: border,
        boxShadow: boxShadow,
        color: color,
        foregroundColor: foregroundColor,
        foregroundImage: foregroundImage,
        gradient: gradient,
        heroEnabled: heroEnabled,
        heroTag: heroTag,
        margin: margin,
        maxRadius: maxRadius,
        minRadius: minRadius,
        onBackgroundImageError: onBackgroundImageError,
        onForegroundImageError: onForegroundImageError,
        padding: padding,
        radius: radius,
        decoratorBuilder: (context, child) {
          if (badge == null) return [child];

          return [
            Positioned(
              left: offsetLeft,
              right: offsetRight,
              top: offsetTop,
              bottom: offsetBottom,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  boxShadow: badgeBoxShadow,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            child,
            Positioned(
              left: offsetLeft,
              right: offsetRight,
              top: offsetTop,
              bottom: offsetBottom,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: badgeColor,
                  border:
                      badgeBorder ?? Border.all(width: 2, color: badgeColor),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                child: badge,
              ),
            )
          ];
        },
      );
}
