import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class SwitchField extends StatelessWidget {
  const SwitchField({
    super.key,
    this.controller,
    this.onChanged,
    this.width = 50.0,
    this.height = 30.0,
    this.disabled = false,
    this.label,
    this.labelText,
    this.labelStyle,
  });
  final ValueNotifier<bool>? controller;
  final void Function(dynamic value)? onChanged;
  final double width;
  final double height;
  final bool disabled;
  final Widget? label;
  final String? labelText;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final labelWidget = Align(
      child: label ??
          Text(labelText ?? '',
              style: labelStyle ??
                  const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
    );

    final advancedSwitch = AdvancedSwitch(
      controller: controller,
      onChanged: onChanged,
      width: width,
      height: height,
      enabled: !disabled,
      activeColor: ThemeApp.of(context).colors.secondary,
      inactiveColor: ThemeApp.of(context).colors.error,
    );

    if (label != null || labelText.hasValue) {
      return Stack(children: [
        advancedSwitch,
        Positioned.fill(
          child: IgnorePointer(child: labelWidget),
        ),
      ]);
    }

    return advancedSwitch;
  }
}
