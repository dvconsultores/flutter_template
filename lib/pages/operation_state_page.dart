import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/circle_light__blurred_widget.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';
import 'package:flutter_gap/flutter_gap.dart';

enum OperationStateType {
  success,
  cancel;
}

class OperationStatePage extends StatelessWidget {
  const OperationStatePage({
    super.key,
    required this.operationState,
    this.icon,
    this.title,
    this.titleText,
    this.titleStyle,
    this.desc,
    this.descText,
    this.descStyle,
    this.actions,
    this.actionsDirection = Axis.vertical,
    this.onPop,
  });
  final OperationStateType operationState;
  final Widget? icon;
  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? desc;
  final String? descText;
  final TextStyle? descStyle;
  final List<Widget> Function(BuildContext context)? actions;
  final Axis actionsDirection;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context), theme = Theme.of(context);

    Map<String, dynamic> defaultValues = switch (operationState) {
      OperationStateType.success => {
          "icon": Icon(
            Icons.check_circle_rounded,
            size: 100,
            color: colors.success,
          ),
          "title": "Saved successfully!",
          "desc": "The record was saved successfully",
          "color": colors.success,
        },
      OperationStateType.cancel => {
          "icon": Icon(
            Icons.cancel_rounded,
            size: 100,
            color: colors.error,
          ),
          "title": "Save failed!",
          "desc": "The record could not be saved correctly",
          "color": colors.error,
        },
    };

    final iconWidget = icon ?? defaultValues['icon'] as Widget,
        titleWidget = title ??
            Text(
              titleText ?? defaultValues['title'] as String,
              style: titleStyle ??
                  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: defaultValues['color'],
                  ),
            ),
        descWidget = desc ??
            Text(
              descText ?? defaultValues['desc'] as String,
              style: descStyle ?? const TextStyle(fontSize: 14),
            ),
        renderActions = actions != null ? actions!(context) : null;

    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          bodyMedium: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
      child: AppScaffold(
        onPop: onPop,
        color: const Color(0xFF000042),
        // decorators
        backgroundStack: [
          const Positioned(
              top: -20,
              left: -30,
              width: 211,
              height: 211,
              child: CircleLightBlurredWidget(blur: 110)),
          Positioned(
              top: -20,
              right: -30,
              width: 211,
              height: 211,
              child: CircleLightBlurredWidget(
                blur: 110,
                color: colors.success.withOpacity(.66),
              ))
        ],

        // body
        body: Column(children: [
          const Gap(30).column,
          const Gap(Vars.gapXLarge).column,
          iconWidget,
          const Gap(Vars.gapXLarge).column,
          titleWidget,
          const Gap(Vars.gapXLarge).column,
          descWidget,
        ]),
        bottomWidget: renderActions != null
            ? Padding(
                padding: Vars.paddingScaffold
                    .add(const EdgeInsets.only(bottom: Vars.gapXLarge)),
                child: switch (actionsDirection) {
                  Axis.horizontal =>
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      for (var i = 0; i < renderActions.length; i++) ...[
                        renderActions[i],
                        if (i != renderActions.length - 1)
                          const Gap(Vars.gapXLarge).row,
                      ],
                    ]),
                  Axis.vertical =>
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      for (var i = 0; i < renderActions.length; i++) ...[
                        renderActions[i],
                        if (i != renderActions.length - 1)
                          const Gap(Vars.gapXLarge).column,
                      ],
                    ]),
                },
              )
            : null,
      ),
    );
  }
}
