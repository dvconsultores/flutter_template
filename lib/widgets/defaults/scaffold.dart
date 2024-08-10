import 'package:double_back_to_exit/double_back_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';

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
    final c = color ?? Theme.of(context).scaffoldBackgroundColor;

    final body = Padding(
      padding: padding ?? Vars.paddingScaffold,
      child: child,
    );

    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
            child: Container(
                decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                c.withOpacity(.6),
                c.withOpacity(.264),
              ]),
        ))),
        scrollable ? SingleChildScrollView(child: body) : body
      ]),
    );
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
    this.doubleBackToExit = false,
    this.goHomeOnBack = false,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool scrollable;
  final bool doubleBackToExit;
  final bool goHomeOnBack;

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      enabled: doubleBackToExit,
      snackBarMessage: "Press again to leave",
      child: WillPopCustom(
        enabled: !doubleBackToExit,
        onWillPop: () {
          if (context.canPop()) {
            context.pop();
          } else if (goHomeOnBack) {
            context.goNamed("home");
          } else {
            return true;
          }

          return false;
        },
        child: Scaffold(
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
        ),
      ),
    );
  }
}
