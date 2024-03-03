import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/Variables.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

// * Custom background styled
class _BackgroundStyled extends StatelessWidget {
  const _BackgroundStyled({required this.child, this.padding});
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      padding: padding ?? Vars.paddingScaffold,
      decoration: const BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.center,
          transform: GradientRotation(-10.5),
          colors: [
            Color.fromRGBO(255, 255, 255, 0.53),
            Color.fromRGBO(220, 220, 220, 0.48),
            Color.fromRGBO(36, 200, 255, 0.35),
            Color(0xFFF6F6F7),
          ],
          stops: [0, 0.333, 0.666, 1],
        ),
      ),
      child: child,
    );
  }
}

// * Custom body background styled
class _BodyBackgroundStyled extends StatelessWidget {
  const _BodyBackgroundStyled({
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
    final body = Align(
        alignment: Alignment.centerLeft,
        child: Container(
          color: color ?? Theme.of(context).scaffoldBackgroundColor,
          padding: padding ?? Vars.paddingScaffold,
          child: child,
        ));

    return scrollable ? SingleChildScrollView(child: body) : body;
  }
}

/// ? Custom Application scaffold
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: _BackgroundStyled(
          padding: padding,
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
    EdgeInsetsGeometry? padding,
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

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: _BackgroundStyled(
          padding: padding,
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
    this.padding,
    this.color,
    this.scrollable = false,
  });
  final Widget body;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;
  final Color? color;

  @override
  Widget build(BuildContext context) => _BodyBackgroundStyled(
        color: color,
        padding: padding,
        scrollable: scrollable,
        child: body,
      );

  /// Responsive variant from `ScaffoldBody`
  static Widget responsive({
    Widget? Function(BuildContext context, BoxConstraints constraints)? mobile,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tablet,
    Widget? Function(BuildContext context, BoxConstraints constraints)? desktop,
    Widget? Function(BuildContext context, BoxConstraints constraints)? tv,
    EdgeInsetsGeometry? padding,
    Color? color,
    bool scrollable = false,
  }) =>
      _ScaffoldBodyResponsive(
        color: color,
        padding: padding,
        mobile: mobile,
        desktop: desktop,
        tablet: tablet,
        tv: tv,
        scrollable: scrollable,
      );
}

// ? Responsive variant from `ScaffoldBody`
class _ScaffoldBodyResponsive extends StatelessWidget {
  const _ScaffoldBodyResponsive({
    this.padding,
    this.color,
    this.mobile,
    this.tablet,
    this.desktop,
    this.tv,
    required this.scrollable,
  });
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      mobile;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget? Function(BuildContext context, BoxConstraints constraints)?
      desktop;
  final Widget? Function(BuildContext context, BoxConstraints constraints)? tv;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool scrollable;

  @override
  Widget build(BuildContext context) => _BodyBackgroundStyled(
        color: color,
        padding: padding,
        scrollable: scrollable,
        child: ResponsiveLayout(
          mobile: mobile,
          tablet: tablet,
          desktop: desktop,
          tv: tv,
        ),
      );
}
