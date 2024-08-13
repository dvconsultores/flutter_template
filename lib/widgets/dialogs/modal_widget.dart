import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:provider/provider.dart';

class Modal extends StatelessWidget {
  const Modal({
    super.key,
    this.icon,
    this.iconColor,
    this.title,
    this.titleText,
    this.content,
    this.contentText,
    this.actions,
    this.loading = false,
    this.disabled = false,
    this.textCancelBtn,
    this.textConfirmBtn,
    this.onPressedCancelBtn,
    this.onPressedConfirmBtn,
    this.iconPadding,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    this.actionButtonsHeight = 40,
    this.actionsDirection = Axis.horizontal,
    this.shrinkWrap = false,
    this.bgColor,
    this.borderSide = BorderSide.none,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius30)),
  });
  final Widget? icon;
  final Color? iconColor;
  final Widget? title;
  final String? titleText;
  final Widget? content;
  final String? contentText;
  final List<Widget>? actions;
  final bool loading;
  final bool disabled;
  final String? textCancelBtn;
  final String? textConfirmBtn;
  final void Function(BuildContext context)? onPressedCancelBtn;
  final void Function(BuildContext context)? onPressedConfirmBtn;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final EdgeInsets insetPadding;
  final double actionButtonsHeight;
  final Axis actionsDirection;
  final bool shrinkWrap;
  final Color? bgColor;
  final BorderSide borderSide;
  final BorderRadius borderRadius;

  static Future<T?> showModal<T>(
    BuildContext context, {
    Widget? icon,
    Color? iconColor,
    Widget? title,
    String? titleText,
    Widget? content,
    String? contentText,
    List<Widget>? actions,
    bool loading = false,
    bool disabled = false,
    String? textCancelBtn,
    String? textConfirmBtn,
    void Function(BuildContext context)? onPressedCancelBtn,
    void Function(BuildContext context)? onPressedConfirmBtn,
    EdgeInsetsGeometry? iconPadding,
    EdgeInsetsGeometry? titlePadding,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    EdgeInsets insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    double actionButtonsHeight = 40,
    Axis actionsDirection = Axis.horizontal,
    bool shrinkWrap = false,
    Color? bgColor,
    BorderSide borderSide = BorderSide.none,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius30)),
    Widget Function(BuildContext context, Widget child)? builder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async =>
      await showDialog<T>(
          context: context,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          builder: (context) {
            final child = Modal(
              icon: icon,
              iconColor: iconColor,
              title: title,
              titleText: titleText,
              content: content,
              contentText: contentText,
              actions: actions,
              loading: loading,
              disabled: disabled,
              textCancelBtn: textCancelBtn,
              textConfirmBtn: textConfirmBtn,
              onPressedCancelBtn: onPressedCancelBtn,
              onPressedConfirmBtn: onPressedConfirmBtn,
              iconPadding: iconPadding,
              titlePadding: titlePadding,
              contentPadding: contentPadding,
              actionsPadding: actionsPadding,
              insetPadding: insetPadding,
              actionButtonsHeight: actionButtonsHeight,
              actionsDirection: actionsDirection,
              shrinkWrap: shrinkWrap,
              bgColor: bgColor,
              borderSide: borderSide,
              borderRadius: borderRadius,
            );

            if (builder != null) builder(context, child);
            return child;
          });

  static Future<bool?> showAlertToContinue(
    BuildContext context, {
    Widget? icon,
    Color? iconColor,
    String? titleText,
    String? contentText,
    String? textConfirmBtn,
    String? textCancelBtn,
    Axis actionsDirection = Axis.horizontal,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async =>
      await showModal<bool>(
        context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        icon: icon,
        iconColor: iconColor,
        titleText: titleText,
        contentText: contentText,
        textConfirmBtn: textConfirmBtn,
        textCancelBtn: textCancelBtn,
        onPressedConfirmBtn: (context) => Navigator.pop(context, true),
        onPressedCancelBtn: (context) => Navigator.pop(context, false),
        actionsDirection: actionsDirection,
      );

  static Future<void> showSystemAlert(
    BuildContext context, {
    Widget? icon,
    Color? iconColor,
    String? titleText,
    String? contentText,
    String? textConfirmBtn,
    String? textCancelBtn,
    void Function(BuildContext context)? onPressedCancelBtn,
    void Function(BuildContext context)? onPressedConfirmBtn,
    Axis actionsDirection = Axis.horizontal,
    Color? barrierColor,
    bool dismissible = true,
  }) async {
    final mainProvider = ContextUtility.context!.read<MainProvider>();
    if (mainProvider.preventModal) return;
    mainProvider.setPreventModal = true;

    await showModal<void>(
      context,
      barrierDismissible: dismissible,
      barrierColor: barrierColor,
      icon: icon,
      iconColor: iconColor,
      titleText: titleText,
      contentText: contentText,
      textConfirmBtn: textConfirmBtn,
      textCancelBtn: textCancelBtn,
      onPressedCancelBtn: onPressedCancelBtn,
      onPressedConfirmBtn: onPressedConfirmBtn,
      actionsDirection: actionsDirection,
      builder: (context, child) {
        return WillPopCustom(
          onWillPop: () async => dismissible,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: child,
          ),
        );
      },
    );

    Future.delayed(Durations.long2, () => mainProvider.setPreventModal = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context);

    final haveActions =
            onPressedConfirmBtn != null || onPressedCancelBtn != null,
        haveTitle = titleText != null,
        haveContent = contentText != null,
        haveIcon = icon != null;

    final tp = titlePadding ??
            Vars.paddingScaffold
                .copyWith(
                  top: haveIcon ? 0 : null,
                  bottom: haveContent || haveActions ? 0 : null,
                )
                .add(EdgeInsets.only(
                  top: haveIcon ? 0 : Vars.gapNormal,
                  bottom: haveContent || haveActions ? 0 : Vars.gapNormal,
                )),
        cp = contentPadding ??
            Vars.paddingScaffold
                .copyWith(
                  top: Vars.gapXLarge,
                  bottom: haveActions ? 0 : Vars.gapXLarge,
                )
                .add(EdgeInsets.only(
                  top: haveTitle ? 0 : Vars.gapNormal,
                  bottom: haveActions ? 0 : Vars.gapNormal,
                ));

    // widgets
    final titleWidget = title ??
            (titleText != null
                ? Text(titleText!, textAlign: TextAlign.center)
                : null),
        contentWidget = content ??
            (contentText != null
                ? Text(contentText!, textAlign: TextAlign.center)
                : null),
        actionWidgets = actions ??
            [
              if (onPressedCancelBtn != null)
                Expanded(
                  child: Button.variant2(
                    height: actionButtonsHeight,
                    text: textCancelBtn ?? "Cancel",
                    textFitted: BoxFit.scaleDown,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Vars.radius12),
                    ),
                    borderSide: BorderSide(color: colors.primary),
                    color: colors.primary,
                    onPressed: () => onPressedCancelBtn!(context),
                  ),
                ),
              if (onPressedCancelBtn != null && onPressedConfirmBtn != null)
                const Gap(Vars.gapXLarge),
              if (onPressedConfirmBtn != null)
                Expanded(
                  child: Button(
                    height: actionButtonsHeight,
                    disabled: disabled || loading,
                    text: textConfirmBtn ?? "Continue",
                    textFitted: BoxFit.scaleDown,
                    bgColor: colors.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Vars.radius12),
                    ),
                    onPressed: () => onPressedConfirmBtn!(context),
                  ),
                ),
            ];

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderSide,
      ),
      iconPadding: const EdgeInsets.all(0),
      titlePadding: tp,
      contentPadding: cp,
      clipBehavior: Clip.hardEdge,
      actionsPadding: actionsPadding ??
          Vars.paddingScaffold
              .copyWith(top: Vars.gapXLarge)
              .add(const EdgeInsets.only(bottom: Vars.gapNormal)),
      icon: Column(children: [
        if (loading)
          LinearProgressIndicator(
            color: colors.primary,
            backgroundColor: colors.secondary,
            minHeight: 5,
            borderRadius:
                const BorderRadius.all(Radius.circular(Vars.radius30)),
          ),
        if (icon != null)
          Padding(
            padding: iconPadding ??
                Vars.paddingScaffold
                    .copyWith(bottom: Vars.gapXLarge)
                    .add(const EdgeInsets.only(top: Vars.gapNormal)),
            child: icon,
          ),
      ]),
      iconColor: iconColor ?? colors.text,
      title: titleWidget,
      content:
          shrinkWrap ? IntrinsicHeight(child: contentWidget) : contentWidget,
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      actions: actionWidgets.isNotEmpty
          ? [
              actionsDirection == Axis.horizontal
                  ? Row(children: actionWidgets)
                  : IntrinsicHeight(child: Column(children: actionWidgets))
            ]
          : null,
    );
  }
}
