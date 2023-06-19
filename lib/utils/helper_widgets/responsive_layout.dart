import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.tv,
  });
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      mobile;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      desktop;
  final Widget? Function(BuildContext context, BoxConstraints constraints)? tv;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (mobile != null &&
              constraints.maxWidth < ScreenSize.mobile.value) {
            return mobile!(context, constraints) ?? const Placeholder();
          } else if (tablet != null &&
              constraints.maxWidth < ScreenSize.tablet.value) {
            return tablet!(context, constraints) ?? const Placeholder();
          } else if (desktop != null &&
              constraints.maxWidth < ScreenSize.desktop.value) {
            return desktop!(context, constraints) ?? const Placeholder();
          }
          return tv!(context, constraints) ?? const Placeholder();
        },
      );
}

mixin ResponsiveLayoutMixinStateful<T extends StatefulWidget> on State<T> {
  Widget? mobileLayout(BuildContext context, BoxConstraints constraints) =>
      null;
  Widget? tabletLayout(BuildContext context, BoxConstraints constraints) =>
      null;
  Widget? desktopLayout(BuildContext context, BoxConstraints constraints) =>
      null;
  Widget? tvLayout(BuildContext context, BoxConstraints constraints) => null;

  Widget buildResponsiveLayout(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (mobileLayout(context, constraints) != null &&
              constraints.maxWidth < ScreenSize.mobile.value) {
            return mobileLayout(context, constraints) ?? const Placeholder();
          } else if (tabletLayout(context, constraints) != null &&
              constraints.maxWidth < ScreenSize.tablet.value) {
            return tabletLayout(context, constraints) ?? const Placeholder();
          } else if (desktopLayout(context, constraints) != null &&
              constraints.maxWidth < ScreenSize.desktop.value) {
            return desktopLayout(context, constraints) ?? const Placeholder();
          }
          return tvLayout(context, constraints) ?? const Placeholder();
        },
      );

  @override
  Widget build(BuildContext context) => buildResponsiveLayout(context);
}

mixin ResponsiveLayoutMixin<T extends Widget> on Widget {
  Widget? mobileLayout(BuildContext context, BoxConstraints constraints) =>
      null;
  Widget? tabletLayout(BuildContext context, BoxConstraints constraints) =>
      null;
  Widget? desktopLayout(BuildContext context, BoxConstraints constraints) =>
      null;
  Widget? tvLayout(BuildContext context, BoxConstraints constraints) => null;

  Widget buildResponsiveLayout(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (mobileLayout(context, constraints) != null &&
              constraints.maxWidth < ScreenSize.mobile.value) {
            return mobileLayout(context, constraints) ?? const Placeholder();
          } else if (tabletLayout(context, constraints) != null &&
              constraints.maxWidth < ScreenSize.tablet.value) {
            return tabletLayout(context, constraints) ?? const Placeholder();
          } else if (desktopLayout(context, constraints) != null &&
              constraints.maxWidth < ScreenSize.desktop.value) {
            return desktopLayout(context, constraints) ?? const Placeholder();
          }
          return tvLayout(context, constraints) ?? const Placeholder();
        },
      );

  Widget build(BuildContext context) => buildResponsiveLayout(context);
}
