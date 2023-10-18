import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:provider/provider.dart';

class SystemAlertWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<MainProvider>().setStopProcess = true;
    });

    if (onOpen != null) onOpen!();

    return WillPopCustom(
      onWillPop: () async => true,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: ThemeApp.colors(context).accent,
                width: 2,
              ),
            ),
            title: Text(title),
            content: textContent != null ? Text(textContent!) : null,
            actionsAlignment: MainAxisAlignment.center,
            titlePadding:
                const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            actionsPadding:
                const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
            actions: [
              Row(children: [
                if (textButton != null)
                  Expanded(
                    child: TextButton(
                      onPressed:
                          onPressedButton ?? () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            ThemeApp.colors(context).secondary),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                      ),
                      child: Text(textButton!),
                    ),
                  ),
                if (textButton != null && textButton2 != null)
                  const SizedBox(width: 15),
                if (textButton2 != null)
                  Expanded(
                    child: TextButton(
                      onPressed:
                          onPressedButton2 ?? () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            ThemeApp.colors(context).primary),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                      ),
                      child: Text(textButton2!),
                    ),
                  ),
              ])
            ]),
      ),
    );
  }
}
