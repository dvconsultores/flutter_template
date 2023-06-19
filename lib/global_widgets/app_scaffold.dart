import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';

const paddingScaffold = EdgeInsets.all(12.0);

/// ? Custom Application scaffol
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.paddless = false,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool paddless;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: Container(
          padding: paddless ? null : paddingScaffold,
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
  }) =>
      AppScaffoldResponsive(
        drawer: drawer,
        appBar: appBar,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        tv: tv,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      );
}

/// ? Responsive variant from `AppScaffold`
class AppScaffoldResponsive extends StatelessWidget {
  const AppScaffoldResponsive({
    super.key,
    this.drawer,
    this.appBar,
    this.mobile,
    this.tablet,
    this.desktop,
    this.tv,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.paddless = false,
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
  final bool paddless;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: Container(
          padding: paddless ? null : paddingScaffold,
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

class ScaffoldBody extends StatelessWidget {
  const ScaffoldBody({
    super.key,
    required this.child,
    this.paddless = false,
    this.color,
  });
  final Widget child;
  final bool paddless;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        color: color ?? Theme.of(context).scaffoldBackgroundColor,
        padding: paddless ? null : paddingScaffold,
        child: child,
      );
}
