import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';

class AlertToContinue extends StatelessWidget {
  const AlertToContinue({
    super.key,
    this.title,
    this.content,
    this.acceptText,
    this.cancelText,
  });
  final String? title;
  final String? content;
  final String? acceptText;
  final String? cancelText;

  static Future<void> showModal(
    BuildContext context, {
    String? title,
    String? content,
    String? acceptText,
    String? cancelText,
  }) async =>
      await showDialog(
        context: context,
        builder: (context) => AlertToContinue(
          title: title,
          content: content,
          acceptText: acceptText,
          cancelText: cancelText,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(Vars.radius30),
        )),
        title: title != null ? Text(title!, textAlign: TextAlign.center) : null,
        content: content != null ? Text(content!) : null,
        titlePadding: Vars.paddingScaffold
            .copyWith(bottom: Vars.gapXLarge)
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
            Expanded(
                child: Button.variant2(
              text: cancelText ?? "Cancel",
              textFitted: BoxFit.contain,
              borderRadius:
                  const BorderRadius.all(Radius.circular(Vars.radius12)),
              onPressed: () => Navigator.pop(context),
            )),
            const Gap(Vars.gapXLarge).row,
            Expanded(
                child: Button(
              text: acceptText ?? "Continue",
              textFitted: BoxFit.contain,
              borderRadius:
                  const BorderRadius.all(Radius.circular(Vars.radius12)),
              onPressed: () => Navigator.pop(context, true),
            )),
          ]),
        ]);
  }
}
