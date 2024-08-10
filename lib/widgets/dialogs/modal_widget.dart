import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ModalWidget extends StatelessWidget {
  const ModalWidget({
    super.key,
    required this.textTitle,
    this.body,
    this.loading = false,
    this.disabled = false,
    this.textCancelBtn,
    this.textConfirmBtn,
    this.textSoloBtn,
    this.onPressedCancelBtn,
    this.onPressedConfirmBtn,
    this.onPressedSoloBtn,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    this.actionButtonsHeight = 40,
    this.shrinkWrap = false,
  });
  final String textTitle;
  final Widget? body;
  final bool loading;
  final bool disabled;
  final String? textCancelBtn;
  final String? textConfirmBtn;
  final String? textSoloBtn;
  final VoidCallback? onPressedCancelBtn;
  final VoidCallback? onPressedConfirmBtn;
  final VoidCallback? onPressedSoloBtn;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final EdgeInsets insetPadding;
  final double actionButtonsHeight;
  final bool shrinkWrap;

  static Future<T?> showModal<T>(
    BuildContext context, {
    required String textTitle,
    Widget? body,
    bool loading = false,
    bool disabled = false,
    String? textCancelBtn,
    String? textConfirmBtn,
    String? textSoloBtn,
    VoidCallback? onPressedCancelBtn,
    VoidCallback? onPressedConfirmBtn,
    VoidCallback? onPressedSoloBtn,
    EdgeInsetsGeometry? titlePadding,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    EdgeInsets insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    double actionButtonsHeight = 40,
    bool shrinkWrap = false,
  }) async =>
      await showDialog<T>(
        context: context,
        builder: (context) => ModalWidget(
          textTitle: textTitle,
          body: body,
          loading: loading,
          disabled: disabled,
          textCancelBtn: textCancelBtn,
          textConfirmBtn: textConfirmBtn,
          textSoloBtn: textSoloBtn,
          onPressedCancelBtn: onPressedCancelBtn,
          onPressedConfirmBtn: onPressedConfirmBtn,
          onPressedSoloBtn: onPressedSoloBtn,
          titlePadding: titlePadding,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          insetPadding: insetPadding,
          actionButtonsHeight: actionButtonsHeight,
          shrinkWrap: shrinkWrap,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bodyWidget = body ?? const SizedBox.shrink();

    return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        alignment: Alignment.center,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Vars.radius30)),
        ),
        titlePadding: Vars.paddingScaffold
            .copyWith(bottom: 0)
            .add(const EdgeInsets.only(top: Vars.gapLow)),
        title: Center(
            child: Text(
          textTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        )),
        content: shrinkWrap ? IntrinsicHeight(child: bodyWidget) : bodyWidget,
        contentPadding:
            contentPadding ?? Vars.paddingScaffold.copyWith(top: 0, bottom: 0),
        actionsPadding: actionsPadding ??
            Vars.paddingScaffold
                .add(const EdgeInsets.only(bottom: Vars.gapLow)),
        insetPadding: insetPadding,
        actions: [
          Row(children: [
            if (onPressedSoloBtn != null)
              Expanded(
                  child: Button(
                height: actionButtonsHeight,
                text: textSoloBtn ?? "Confirmar",
                textExpanded: true,
                onPressed: onPressedSoloBtn ??
                    () {
                      clearSnackbars();
                      Navigator.pop(context);
                    },
              ))
            else ...[
              Expanded(
                  child: Button.variant(
                height: actionButtonsHeight,
                text: textCancelBtn ?? "Cancelar",
                textExpanded: true,
                onPressed: onPressedCancelBtn ??
                    () {
                      clearSnackbars();
                      Navigator.pop(context);
                    },
              )),
              const Gap(Vars.gapXLarge).row,
              Expanded(
                  child: Button(
                height: actionButtonsHeight,
                loading: loading,
                disabled: disabled,
                textExpanded: true,
                text: textConfirmBtn ?? "Confirmar",
                onPressed: onPressedConfirmBtn,
              )),
            ]
          ]),
        ]);
  }
}
