import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';

/// ? Custom Application scaffol
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.sessionTimer = true,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool sessionTimer;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      );

  static Widget responsive({
    Widget? drawer,
    PreferredSizeWidget? appBar,
    Widget? Function(BuildContext context, BoxConstraints constraints)? mobile,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tablet,
    Widget? Function(BuildContext context, BoxConstraints constraints)? desktop,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tv,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    bool sessionTimer = true,
  }) =>
      _AppScaffoldResponsive(
        drawer: drawer,
        appBar: appBar,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        tv: tv,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        sessionTimer: sessionTimer,
      );
}

/// ? Responsive variant from `AppScaffold`
class _AppScaffoldResponsive extends StatelessWidget {
  const _AppScaffoldResponsive({
    this.drawer,
    this.appBar,
    this.mobile,
    this.tablet,
    this.desktop,
    this.tv,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.sessionTimer = true,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      mobile;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      desktop;
  final Widget? Function(BuildContext context, BoxConstraints constraints)? tv;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool sessionTimer;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: ResponsiveLayout(
            mobile: mobile,
            tablet: tablet,
            desktop: desktop,
            tv: tv,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      );
}
