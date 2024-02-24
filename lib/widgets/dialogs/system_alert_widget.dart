import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:provider/provider.dart';

// TODO migrate and create other general alert based on apolo
//* plus add to general widgets correct sizings on variables
class SystemAlertWidget extends StatefulWidget {
  const SystemAlertWidget({
    super.key,
    required this.title,
    this.textContent,
    this.textButton,
    this.textButton2,
    this.onPressedButton,
    this.onPressedButton2,
    this.dismissible = false,
    this.onOpen,
  });
  final String title;
  final String? textContent;
  final String? textButton;
  final void Function()? onPressedButton;
  final String? textButton2;
  final void Function()? onPressedButton2;
  final bool dismissible;
  final VoidCallback? onOpen;

  @override
  State<SystemAlertWidget> createState() => _SystemAlertWidgetState();
}

class _SystemAlertWidgetState extends State<SystemAlertWidget> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      globalNavigatorKey.currentContext!.read<MainProvider>().setStopProcess =
          true;
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(
        const Duration(milliseconds: 500),
        () => globalNavigatorKey.currentContext!
            .read<MainProvider>()
            .setStopProcess = false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onOpen != null) widget.onOpen!();

    return WillPopCustom(
      onWillPop: () async => widget.dismissible,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  color: ThemeApp.colors(context).secondary, width: 2),
            ),
            title: Text(widget.title),
            content:
                widget.textContent != null ? Text(widget.textContent!) : null,
            actionsAlignment: MainAxisAlignment.center,
            titlePadding:
                const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            actionsPadding:
                const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
            actions: [
              Row(children: [
                if (widget.textButton != null)
                  Expanded(
                    child: Button.variant(
                      text: widget.textButton!,
                      onPressed: widget.onPressedButton ??
                          () => Navigator.pop(context),
                    ),
                  ),
                if (widget.textButton != null && widget.textButton2 != null)
                  const Gap(15).row,
                if (widget.textButton2 != null)
                  Expanded(
                    child: Button(
                      text: widget.textButton2!,
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
