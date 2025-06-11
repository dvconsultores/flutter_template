import 'dart:ui';

import 'package:app_loader/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';

class Modal extends StatefulWidget {
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
    this.dismissible = true,
    this.textCancelBtn,
    this.textConfirmBtn,
    this.hideCancelButton = false,
    this.hideConfirmButton = false,
    this.flexCancelButton = 1,
    this.flexConfirmButton = 2,
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
    this.elevation,
    this.constraints,
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
  final bool dismissible;
  final String? textCancelBtn;
  final String? textConfirmBtn;
  final int flexCancelButton;
  final int flexConfirmButton;
  final bool hideCancelButton;
  final bool hideConfirmButton;
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
  final double? elevation;
  final BoxConstraints? constraints;

  static Future<T?> showModal<T>(
    BuildContext context, {
    Key? key,
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
    int flexCancelButton = 1,
    int flexConfirmButton = 2,
    bool hideCancelButton = false,
    bool hideConfirmButton = false,
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
    bool dismissible = true,
    Color? barrierColor,
    double? elevation,
    BoxConstraints? constraints,
  }) async =>
      await showDialog<T>(
          context: context,
          barrierColor: barrierColor,
          barrierDismissible: dismissible,
          builder: (context) {
            final child = Modal(
              key: key,
              icon: icon,
              iconColor: iconColor,
              title: title,
              titleText: titleText,
              content: content,
              contentText: contentText,
              actions: actions,
              loading: loading,
              disabled: disabled,
              dismissible: dismissible,
              textCancelBtn: textCancelBtn,
              textConfirmBtn: textConfirmBtn,
              flexCancelButton: flexCancelButton,
              flexConfirmButton: flexConfirmButton,
              hideCancelButton: hideCancelButton,
              hideConfirmButton: hideConfirmButton,
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
              elevation: elevation,
              constraints: constraints,
            );

            if (builder != null) builder(context, child);
            return child;
          });

  static Future<bool?> showAlertToContinue(
    BuildContext context, {
    Key? key,
    Widget? icon,
    Color? iconColor,
    String? titleText,
    String? contentText,
    String? textConfirmBtn,
    String? textCancelBtn,
    int flexCancelButton = 1,
    int flexConfirmButton = 2,
    bool hideCancelButton = false,
    bool hideConfirmButton = false,
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
    bool dismissible = true,
    Color? barrierColor,
    double? elevation,
    BoxConstraints? constraints,
    bool loading = false,
    bool disabled = false,
    List<Widget>? actions,
    Widget? title,
    Widget? content,
  }) async =>
      await showModal<bool>(
        context,
        key: key,
        dismissible: dismissible,
        barrierColor: barrierColor,
        icon: icon,
        iconColor: iconColor,
        titleText: titleText,
        contentText: contentText,
        textConfirmBtn: textConfirmBtn,
        textCancelBtn: textCancelBtn,
        flexCancelButton: flexCancelButton,
        flexConfirmButton: flexConfirmButton,
        hideCancelButton: hideCancelButton,
        hideConfirmButton: hideConfirmButton,
        onPressedConfirmBtn:
            onPressedConfirmBtn ?? (context) => Navigator.pop(context, true),
        onPressedCancelBtn:
            onPressedCancelBtn ?? (context) => Navigator.pop(context, false),
        actionsDirection: actionsDirection,
        iconPadding: iconPadding,
        titlePadding: titlePadding,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        insetPadding: insetPadding,
        actionButtonsHeight: actionButtonsHeight,
        shrinkWrap: shrinkWrap,
        bgColor: bgColor,
        borderSide: borderSide,
        borderRadius: borderRadius,
        elevation: elevation,
        constraints: constraints,
        loading: loading,
        disabled: disabled,
        actions: actions,
        title: title,
        content: content,
      );

  static Future<bool?> showSystemAlert(
    BuildContext context, {
    Key? key,
    Widget? icon,
    Color? iconColor,
    Widget Function(TextStyle style)? title,
    String? titleText,
    Widget Function(TextStyle style)? content,
    String? contentText,
    String? textConfirmBtn,
    String? textCancelBtn,
    int flexCancelButton = 1,
    int flexConfirmButton = 2,
    bool hideCancelButton = false,
    bool hideConfirmButton = false,
    void Function(BuildContext context)? onPressedCancelBtn,
    void Function(BuildContext context)? onPressedConfirmBtn,
    Axis actionsDirection = Axis.horizontal,
    Color? barrierColor,
    bool dismissible = true,
    EdgeInsetsGeometry? iconPadding,
    EdgeInsetsGeometry? titlePadding,
    EdgeInsetsGeometry? actionsPadding,
    EdgeInsets insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    double actionButtonsHeight = 40,
    bool shrinkWrap = false,
    Color? bgColor,
    BorderSide borderSide = BorderSide.none,
    BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(Vars.radius30)),
    double? elevation,
    BoxConstraints? constraints,
    bool loading = false,
    bool disabled = false,
    List<Widget>? actions,
  }) async {
    final mainProvider = MainProvider.read(context);
    if (mainProvider.preventModal) return null;
    mainProvider.setPreventModal = true;

    final themeApp = ThemeApp.of(context);

    final haveActions =
            onPressedConfirmBtn != null || onPressedCancelBtn != null,
        haveTitle = titleText != null || title != null,
        haveContent = contentText != null || content != null;

    final ts =
        themeApp.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600);
    final cs = themeApp.textTheme.bodyMedium!.copyWith(fontSize: 15);

    final value = await showModal<bool>(
      context,
      key: key,
      dismissible: dismissible,
      barrierColor: barrierColor,
      borderSide: BorderSide(color: themeApp.colors.secondary, width: 2),
      icon: icon,
      iconColor: iconColor,
      title: title != null
          ? title(ts)
          : Column(children: [
              Text(
                titleText ?? "Notificación del sistema",
                style: ts,
              ),
              if (haveContent) ...[Gap(Vars.gapXLow).column, Divider()],
            ]),
      content: content != null
          ? content(cs)
          : (contentText != null ? Text(contentText, style: cs) : null),
      contentPadding: Vars.paddingScaffold
          .copyWith(
            top: Vars.gapNormal,
            bottom:
                haveActions ? Vars.gapNormal : Vars.gapXLarge + Vars.gapNormal,
          )
          .add(EdgeInsets.only(
            top: haveTitle ? 0 : Vars.gapNormal,
          )),
      textConfirmBtn: textConfirmBtn,
      textCancelBtn: textCancelBtn,
      flexCancelButton: flexCancelButton,
      flexConfirmButton: flexConfirmButton,
      hideCancelButton: hideCancelButton,
      hideConfirmButton: hideConfirmButton,
      onPressedCancelBtn: onPressedCancelBtn ??
          (textCancelBtn != null
              ? (context) => Navigator.pop(context, false)
              : null),
      onPressedConfirmBtn: onPressedConfirmBtn ??
          (textConfirmBtn != null
              ? (context) => Navigator.pop(context, true)
              : null),
      actionsDirection: actionsDirection,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: child,
        );
      },
      iconPadding: iconPadding,
      titlePadding: titlePadding,
      actionsPadding: actionsPadding,
      insetPadding: insetPadding,
      actionButtonsHeight: actionButtonsHeight,
      shrinkWrap: shrinkWrap,
      bgColor: bgColor,
      borderRadius: borderRadius,
      elevation: elevation,
      constraints: constraints,
      loading: loading,
      disabled: disabled,
      actions: actions,
    );

    Future.delayed(Durations.long2, () => mainProvider.setPreventModal = false);
    return value;
  }

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  late final mainProvider = MainProvider.read(context);

  @override
  void initState() {
    mainProvider.setCurrentNavContext = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeApp = ThemeApp.of(context);

    final showCancelButton =
            widget.onPressedCancelBtn != null && !widget.hideCancelButton,
        showConfirmButton =
            widget.onPressedConfirmBtn != null && !widget.hideConfirmButton;

    final haveActions = widget.onPressedConfirmBtn != null ||
            widget.onPressedCancelBtn != null,
        haveTitle = widget.titleText != null || widget.title != null,
        haveContent = widget.contentText != null || widget.content != null,
        haveIcon = widget.icon != null;

    final tp = widget.titlePadding ??
            Vars.paddingScaffold
                .copyWith(
                  top: haveIcon ? 0 : null,
                  bottom: haveContent || haveActions ? 0 : null,
                )
                .add(EdgeInsets.only(
                  top: haveIcon ? 0 : Vars.gapNormal,
                  bottom: haveContent || haveActions ? 0 : Vars.gapNormal,
                )),
        cp = widget.contentPadding ??
            Vars.paddingScaffold
                .copyWith(
                  top: Vars.gapXLarge,
                  bottom: haveActions ? 0 : Vars.gapXLarge + Vars.gapNormal,
                )
                .add(EdgeInsets.only(
                  top: haveTitle ? 0 : Vars.gapNormal,
                ));

    final boxConstraints =
        widget.constraints ?? BoxConstraints(maxWidth: Vars.mobileSize.width);

    // widgets
    final titleWidget = ConstrainedBox(
            constraints: boxConstraints,
            child: widget.title ??
                (widget.titleText != null
                    ? Text(widget.titleText!, textAlign: TextAlign.center)
                    : null)),
        contentWidget = ConstrainedBox(
            constraints: boxConstraints,
            child: widget.content ??
                (widget.contentText != null
                    ? Text(
                        widget.contentText!,
                        textAlign: TextAlign.center,
                        style: themeApp.textTheme.bodyMedium,
                      )
                    : null)),
        actionWidgets = widget.actions ??
            [
              if (showCancelButton)
                Expanded(
                  flex: widget.flexCancelButton,
                  child: ButtonVariant(
                    height: widget.actionButtonsHeight,
                    text: widget.textCancelBtn ?? "Cancel",
                    textFitted: BoxFit.scaleDown,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Vars.radius12),
                    ),
                    borderSide: BorderSide(color: themeApp.colors.primary),
                    color: themeApp.colors.primary,
                    onPressed: () => widget.onPressedCancelBtn!(context),
                  ),
                ),
              if (showCancelButton && showConfirmButton)
                const Gap(Vars.gapXLarge),
              if (showConfirmButton)
                Expanded(
                  flex: widget.flexConfirmButton,
                  child: Button(
                    height: widget.actionButtonsHeight,
                    disabled: widget.disabled || widget.loading,
                    text: widget.textConfirmBtn ?? "Continue",
                    textFitted: BoxFit.scaleDown,
                    bgColor: themeApp.colors.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Vars.radius12),
                    ),
                    onPressed: () => widget.onPressedConfirmBtn!(context),
                  ),
                ),
            ];

    return WillPopCustom(
      onWillPop: () => widget.dismissible,
      child: AlertDialog(
        backgroundColor: widget.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
          side: widget.borderSide,
        ),
        elevation: widget.elevation,
        iconPadding: const EdgeInsets.all(0),
        insetPadding: widget.insetPadding,
        titlePadding: tp,
        contentPadding: cp,
        clipBehavior: Clip.hardEdge,
        actionsPadding: widget.actionsPadding ??
            Vars.paddingScaffold
                .copyWith(top: Vars.gapXLarge)
                .add(const EdgeInsets.only(bottom: Vars.gapNormal)),
        icon: Column(children: [
          if (widget.loading)
            LinearProgressIndicator(
              color: themeApp.colors.primary,
              backgroundColor: themeApp.colors.secondary,
              minHeight: 5,
              borderRadius:
                  const BorderRadius.all(Radius.circular(Vars.radius30)),
            ),
          if (widget.icon != null)
            Padding(
              padding: widget.iconPadding ??
                  Vars.paddingScaffold
                      .copyWith(bottom: Vars.gapXLarge)
                      .add(const EdgeInsets.only(top: Vars.gapNormal)),
              child: widget.icon,
            ),
        ]),
        iconColor: widget.iconColor ?? themeApp.colors.text,
        title: titleWidget,
        content: widget.shrinkWrap
            ? IntrinsicHeight(child: contentWidget)
            : contentWidget,
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        actions: actionWidgets.isNotEmpty
            ? [
                widget.actionsDirection == Axis.horizontal
                    ? Row(children: actionWidgets)
                    : IntrinsicHeight(child: Column(children: actionWidgets))
              ]
            : null,
      ),
    );
  }
}
