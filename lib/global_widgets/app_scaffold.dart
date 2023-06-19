import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';

const paddingScaffold = EdgeInsets.all(12.0);

/// ? Custom Application scaffold
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

  /// Responsive variant from `AppScaffold`
  static Widget responsive({
    Widget? Function(BuildContext context, BoxConstraints constraints)? mobile,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tablet,
    Widget? Function(BuildContext context, BoxConstraints constraints)? desktop,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tv,
    Widget? drawer,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    bool paddless = false,
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
        paddless: paddless,
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
    this.paddless = false,
  });
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      mobile;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      desktop;
  final Widget? Function(BuildContext context, BoxConstraints constraints)? tv;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
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

/// ? Custom Application scaffold body to `ShellRoute`
class ScaffoldBody extends StatelessWidget {
  const ScaffoldBody({
    super.key,
    required this.body,
    this.paddless = false,
    this.color,
  });
  final Widget body;
  final bool paddless;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        color: color ?? Theme.of(context).scaffoldBackgroundColor,
        padding: paddless ? null : paddingScaffold,
        child: body,
      );

  /// Responsive variant from `ScaffoldBody`
  static Widget responsive({
    Widget? Function(BuildContext context, BoxConstraints constraints)? mobile,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tablet,
    Widget? Function(BuildContext context, BoxConstraints constraints)? desktop,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tv,
    bool paddless = false,
    Color? color,
  }) =>
      _ScaffoldBodyResponsive(
        color: color,
        paddless: paddless,
        mobile: mobile,
        desktop: desktop,
        tablet: tablet,
        tv: tv,
      );
}

/// ? Responsive variant from `ScaffoldBody`
class _ScaffoldBodyResponsive extends StatelessWidget {
  const _ScaffoldBodyResponsive({
    this.paddless = false,
    this.color,
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
  final bool paddless;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        color: color ?? Theme.of(context).scaffoldBackgroundColor,
        padding: paddless ? null : paddingScaffold,
        child: ResponsiveLayout(
          mobile: mobile,
          tablet: tablet,
          desktop: desktop,
          tv: tv,
        ),
      );
}
