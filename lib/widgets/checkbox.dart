import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_gap/flutter_gap.dart';

class AppCheckbox extends StatefulWidget {
  const AppCheckbox({
    super.key,
    this.notifier,
    this.onChanged,
    this.splashRadius = 16,
    this.size,
    this.label,
    this.labelText,
    this.gap = 10,
    this.textStyle,
    this.expanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.borderRadius = 40,
  });
  final ValueNotifier<bool>? notifier;
  final void Function(bool? value)? onChanged;
  final double splashRadius;
  final double? size;
  final Widget? label;
  final String? labelText;
  final TextStyle? textStyle;
  final double gap;
  final bool expanded;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double borderRadius;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  @override
  Widget build(BuildContext context) {
    final labelWidget = widget.label ?? Text(widget.labelText ?? '');

    return TextButton(
      onPressed: () {
        setState(
            () => widget.notifier?.value = !(widget.notifier?.value ?? false));

        widget.onChanged!(widget.notifier?.value);
      },
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
            widget.textStyle ?? const TextStyle(fontSize: 12)),
        shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        )),
        overlayColor: MaterialStatePropertyAll(
            ThemeApp.colors(context).secondary.withOpacity(.3)),
        foregroundColor: MaterialStatePropertyAll(
            widget.textStyle?.color ?? ThemeApp.colors(context).text),
      ),
      child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          children: [
            SizedBox(
              width: widget.size != null ? widget.size! * 2 : null,
              height: widget.size != null ? widget.size! * 2 : null,
              child: Material(
                  elevation: 7,
                  shadowColor: ThemeApp.colors(context).secondary,
                  shape: const CircleBorder(),
                  child: Checkbox(
                    value: widget.notifier?.value,
                    onChanged: null,
                    side: BorderSide.none,
                    splashRadius: widget.splashRadius,
                    fillColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    checkColor: ThemeApp.colors(context).secondary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )),
            ),
            if (widget.label != null || widget.labelText != null) ...[
              Gap(widget.gap).row,
              if (widget.expanded)
                Expanded(child: labelWidget)
              else
                labelWidget,
            ]
          ]),
    );
  }
}
