import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:provider/provider.dart';

class SystemAlertWidget extends StatefulWidget {
  const SystemAlertWidget({
    super.key,
    required this.title,
    this.content,
    this.textButton,
    this.textButton2,
    this.onPressedButton,
    this.onPressedButton2,
    this.dismissible = false,
    this.onOpen,
  });
  final String title;
  final String? content;
  final String? textButton;
  final void Function()? onPressedButton;
  final String? textButton2;
  final void Function()? onPressedButton2;
  final bool dismissible;
  final VoidCallback? onOpen;

  static Future<void> showModal(
    BuildContext context, {
    required String title,
    String? content,
    String? textButton,
    void Function()? onPressedButton,
    String? textButton2,
    void Function()? onPressedButton2,
    bool dismissible = true,
    VoidCallback? onOpen,
  }) async =>
      await showDialog(
        context: context,
        builder: (context) => SystemAlertWidget(
          title: title,
          content: content,
          textButton: textButton,
          onPressedButton: onPressedButton,
          textButton2: textButton2,
          onPressedButton2: onPressedButton2,
          dismissible: dismissible,
          onOpen: onOpen,
        ),
      );

  @override
  State<SystemAlertWidget> createState() => _SystemAlertWidgetState();
}

class _SystemAlertWidgetState extends State<SystemAlertWidget> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ContextUtility.context!.read<MainProvider>().setStopProcess = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(
        Durations.long2,
        () => ContextUtility.context!.read<MainProvider>().setStopProcess =
            false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onOpen != null) widget.onOpen!();

    final haveBothButtons =
        widget.textButton != null && widget.textButton2 != null;

    return WillPopCustom(
      onWillPop: () async => widget.dismissible,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(Vars.radius30),
              ),
              side: BorderSide(
                color: ThemeApp.colors(context).secondary,
                width: 2,
              ),
            ),
            title: Text(widget.title, textAlign: TextAlign.center),
            content: widget.content != null ? Text(widget.content!) : null,
            actionsAlignment: MainAxisAlignment.center,
            titlePadding: Vars.paddingScaffold
                .copyWith(
                  bottom: haveBothButtons || widget.content != null
                      ? Vars.gapXLarge
                      : Vars.gapXLow,
                )
                .add(const EdgeInsets.only(top: Vars.gapNormal)),
            contentPadding: Vars.paddingScaffold.copyWith(
              top: 0,
              bottom: Vars.gapXLarge,
            ),
            actionsPadding: Vars.paddingScaffold
                .copyWith(top: 0)
                .add(const EdgeInsets.only(bottom: Vars.gapNormal)),
            actions: [
              Row(children: [
                if (widget.textButton != null)
                  Expanded(
                    child: Button.variant(
                      text: widget.textButton!,
                      textFitted: BoxFit.contain,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Vars.radius12)),
                      onPressed: widget.onPressedButton ??
                          () => Navigator.pop(context),
                    ),
                  ),
                if (haveBothButtons) const Gap(Vars.gapXLarge).row,
                if (widget.textButton2 != null)
                  Expanded(
                    child: Button(
                      text: widget.textButton2!,
                      textFitted: BoxFit.contain,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Vars.radius12)),
                      onPressed: widget.onPressedButton2 ??
                          () => Navigator.pop(context),
                    ),
                  ),
              ])
            ]),
      ),
    );
  }
}
