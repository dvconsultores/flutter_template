import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

// * Custom background styled
class _BackgroundStyled extends StatelessWidget {
  const _BackgroundStyled({
    required this.child,
    this.color,
    this.padding,
    required this.scrollable,
  });
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool scrollable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
      padding: padding ?? Vars.paddingScaffold,
      child: child,
    );

    return scrollable ? SingleChildScrollView(child: body) : body;
  }
}

/// ? Custom Application scaffold
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.drawer,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding,
    this.color,
    this.scrollable = false,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool scrollable;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: _BackgroundStyled(
          padding: padding,
          color: color,
          scrollable: scrollable,
          child: body,
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
    EdgeInsetsGeometry? padding,
    Color? color,
    bool scrollable = false,
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
        padding: padding,
        color: color,
        scrollable: scrollable,
      );
}

// ? Responsive variant from `AppScaffold`
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
    this.padding,
    this.color,
    this.scrollable = false,
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
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool scrollable;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: _BackgroundStyled(
          padding: padding,
          color: color,
          scrollable: scrollable,
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
