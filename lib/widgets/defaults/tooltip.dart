import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_gap/flutter_gap.dart';

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    super.key,
    required this.child,
    this.showTooltip = true,
    this.message,
    this.richMessage,
    this.verticalOffset,
    this.triggerMode,
  });
  final Widget child;
  final bool showTooltip;
  final String? message;
  final InlineSpan? richMessage;
  final double? verticalOffset;
  final TooltipTriggerMode? triggerMode;

  @override
  Widget build(BuildContext context) {
    if (!showTooltip) return child;

    return Tooltip(
      message: message ?? '',
      richMessage: richMessage,
      verticalOffset: verticalOffset ?? -50,
      showDuration: const Duration(seconds: 10),
      triggerMode: triggerMode ?? TooltipTriggerMode.tap,
      margin: Vars.paddingScaffold.copyWith(top: 0),
      padding: const EdgeInsets.symmetric(
        horizontal: Vars.gapLarge,
        vertical: Vars.gapNormal,
      ),
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      child: child,
    );
  }
}

class ButtonTip extends StatelessWidget {
  const ButtonTip({
    super.key,
    required this.message,
    this.splashRadius = 12,
    this.verticalOffset,
    this.constraints = const BoxConstraints(maxWidth: 22, maxHeight: 22),
    this.iconSize = 18,
    this.color,
    this.icon = const Icon(Icons.info),
    this.triggerMode,
    this.gap = Vars.gapLow,
    this.child,
  });
  final String message;
  final double splashRadius;
  final double? verticalOffset;
  final BoxConstraints constraints;
  final double iconSize;
  final Color? color;
  final Widget icon;
  final TooltipTriggerMode? triggerMode;
  final double gap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final buttonTip = AppTooltip(
      message: message,
      triggerMode: triggerMode,
      verticalOffset: verticalOffset,
      child: AbsorbPointer(
        child: IconButton(
          onPressed: () {},
          splashRadius: splashRadius,
          visualDensity: VisualDensity.comfortable,
          padding: const EdgeInsets.all(0),
          constraints: constraints,
          iconSize: iconSize,
          color: color ?? ThemeApp.of(context).colors.primary,
          icon: icon,
        ),
      ),
    );

    return child != null
        ? Row(children: [
            child!,
            Gap(gap).row,
            Transform.translate(
              offset: const Offset(0, -3),
              child: buttonTip,
            ),
          ])
        : buttonTip;
  }
}
