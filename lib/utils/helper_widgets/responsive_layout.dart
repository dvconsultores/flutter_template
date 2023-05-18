import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  });
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (mobile != null && constraints.maxWidth < ScreenSizes.mobile.value) {
          return mobile!;
        } else if (tablet != null &&
            constraints.maxWidth < ScreenSizes.tablet.value) {
          return tablet!;
        }
        return desktop ?? const Placeholder();
      },
    );
  }
}
