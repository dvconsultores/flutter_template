import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/custom_animated_builder.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(
    this.text, {
    super.key,
    this.padding,
    this.style,
  });
  final String? text;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final defaultPadding =
            padding ?? const EdgeInsets.symmetric(horizontal: Vars.gapMedium),
        errorWidget = Text(
          text!,
          style: style ??
              theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.error),
        );

    return SingleAnimatedBuilder(
      animationSettings: CustomAnimationSettings(
        duration: Durations.short3,
      ),
      builder: (context, child, parent) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -.2),
            end: const Offset(0, 0),
          ).animate(parent),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(parent),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: defaultPadding,
        child: Column(children: [const Gap(8).column, errorWidget]),
      ),
    );
  }
}
