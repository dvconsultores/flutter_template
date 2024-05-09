import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    super.key,
    required this.child,
    this.showTooltip = true,
    this.message,
    this.richMessage,
    this.verticalOffset,
  });
  final Widget child;
  final bool showTooltip;
  final String? message;
  final InlineSpan? richMessage;
  final double? verticalOffset;

  @override
  Widget build(BuildContext context) {
    if (!showTooltip) return child;

    return Tooltip(
      message: message,
      richMessage: richMessage,
      verticalOffset: verticalOffset ?? -50,
      triggerMode: TooltipTriggerMode.longPress,
      margin: Vars.paddingScaffold.copyWith(top: 0),
      padding: const EdgeInsets.symmetric(
        horizontal: Vars.gapLarge,
        vertical: Vars.gapNormal,
      ),
      textStyle: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: FontFamily.lato("400"),
      ),
      child: child,
    );
  }
}

class ButtonTip extends StatelessWidget {
  const ButtonTip({
    super.key,
    this.message,
    this.splashRadius = 12,
    this.constraints = const BoxConstraints(maxWidth: 22, maxHeight: 22),
    this.iconSize = 18,
    this.color,
    this.icon = const Icon(Icons.info),
  });
  final String? message;
  final double splashRadius;
  final BoxConstraints constraints;
  final double iconSize;
  final Color? color;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return AppTooltip(
      message: message,
      child: IconButton(
        onPressed: () {},
        splashRadius: splashRadius,
        padding: const EdgeInsets.all(0),
        constraints: constraints,
        iconSize: iconSize,
        color: color ?? ThemeApp.colors(context).primary,
        icon: icon,
      ),
    );
  }
}
