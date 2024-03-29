import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    super.key,
    required this.child,
    this.showTooltip = false,
    this.message,
  });
  final Widget child;
  final bool showTooltip;
  final String? message;

  @override
  Widget build(BuildContext context) {
    if (!showTooltip) return child;

    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.longPress,
      margin: Vars.paddingScaffold.copyWith(top: 0),
      padding: const EdgeInsets.symmetric(
        horizontal: Vars.gapLarge,
        vertical: Vars.gapMedium,
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
