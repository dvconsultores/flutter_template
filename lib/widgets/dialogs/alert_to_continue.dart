import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Vars.radius15)),
        ),
        title: title != null ? Text(title!, textAlign: TextAlign.center) : null,
        content: content != null
            ? Text(
                content!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 100, 93, 93),
                ),
              )
            : null,
        titlePadding: Vars.paddingScaffold
            .add(const EdgeInsets.only(top: Vars.gapNormal)),
        contentPadding: EdgeInsets.only(
          left: Vars.paddingScaffold.left,
          right: Vars.paddingScaffold.left,
        ),
        actionsPadding: Vars.paddingScaffold
            .add(const EdgeInsets.only(bottom: Vars.gapNormal)),
        actions: [
          Row(children: [
            Expanded(
                child: Button.variant(
              text: cancelText ?? "Cancel",
              onPressed: () => Navigator.pop(context),
            )),
            const Gap(Vars.gapXLarge).row,
            Expanded(
                child: Button(
              text: acceptText ?? "Continue",
              onPressed: () => Navigator.pop(context, true),
            )),
          ]),
        ]);
  }
}
