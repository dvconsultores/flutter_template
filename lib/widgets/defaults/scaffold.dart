import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/loaders/refresh_indicator.dart';
import 'package:go_router/go_router.dart';

// * Custom background styled
class _BackgroundStyled extends StatelessWidget {
  const _BackgroundStyled({
    required this.child,
    this.color,
    this.gradient,
    this.decorationImage,
    this.padding,
    this.scrollController,
    required this.scrollable,
    this.indicatorController,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.offsetToArmed,
    this.textOnPullDown = "Pull to fetch more",
    this.onRefresh,
    this.onPullDown,
    this.backgroundStack,
    this.foregroundStack,
    required this.constraints,
  });
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? decorationImage;
  final ScrollController? scrollController;
  final bool scrollable;
  final ValueNotifier<IndicatorController>? indicatorController;
  final bool Function(ScrollNotification) notificationPredicate;
  final double? offsetToArmed;
  final String textOnPullDown;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onPullDown;
  final List<Positioned>? backgroundStack;
  final List<Positioned>? foregroundStack;
  final Widget child;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).scaffoldBackgroundColor;

    final body = ConstrainedBox(
          constraints: constraints,
          child: Padding(
            padding: padding ?? Vars.paddingScaffold,
            child: child,
          ),
        ),
        bodyScrollable = SingleChildScrollView(
          controller: scrollController,
          physics:
              onRefresh != null ? const AlwaysScrollableScrollPhysics() : null,
          child: body,
        );

    Widget renderBody() {
      if (!scrollable) return body;

      if (onPullDown != null) {
        return AppRefreshIndicator.pullDown(
          controller: indicatorController,
          notificationPredicate: notificationPredicate,
          offsetToArmed: offsetToArmed,
          onRefresh: onRefresh,
          onPullDown: onPullDown,
          textOnPullDown: textOnPullDown,
          child: bodyScrollable,
        );
      }

      if (onRefresh != null) {
        return AppRefreshIndicator(
          controller: indicatorController,
          notificationPredicate: notificationPredicate,
          offsetToArmed: offsetToArmed,
          onRefresh: onRefresh!,
          child: bodyScrollable,
        );
      }

      return bodyScrollable;
    }

    return SafeArea(
      child: SizedBox(
        width: double.maxFinite,
        child: Stack(alignment: Alignment.center, children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c,
                gradient: gradient,
                image: decorationImage,
              ),
            ),
          ),
          if (backgroundStack != null) ...backgroundStack!,
          renderBody(),
          if (foregroundStack != null) ...foregroundStack!,
        ]),
      ),
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
    this.bottomWidget,
    this.floatingActionButton,
    this.padding,
    this.color,
    this.gradient,
    this.decorationImage,
    this.scrollController,
    this.scrollable = false,
    this.indicatorController,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.offsetToArmed,
    this.textOnPullDown = "Pull to fetch more",
    this.onRefresh,
    this.onPullDown,
    this.goHomeOnBack = false,
    this.onPop,
    this.backgroundStack,
    this.foregroundStack,
    this.maxWidth = Vars.desktopScaffoldMaxWidth,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomWidget;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? decorationImage;
  final ScrollController? scrollController;
  final bool scrollable;
  final ValueNotifier<IndicatorController>? indicatorController;
  final bool Function(ScrollNotification) notificationPredicate;
  final double? offsetToArmed;
  final String textOnPullDown;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onPullDown;
  final bool goHomeOnBack;
  final VoidCallback? onPop;
  final List<Positioned>? backgroundStack;
  final List<Positioned>? foregroundStack;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(maxWidth: maxWidth ?? double.maxFinite);

    return WillPopCustom(
      onWillPop: () async {
        if (onPop != null) {
          onPop!();
        } else if (goHomeOnBack) {
          context.goNamed("home");
        } else if (context.canPop()) {
          context.pop();
        }

        return false;
      },
      child: Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: _BackgroundStyled(
          padding: padding,
          color: color,
          gradient: gradient,
          decorationImage: decorationImage,
          scrollController: scrollController,
          scrollable: scrollable,
          indicatorController: indicatorController,
          notificationPredicate: notificationPredicate,
          offsetToArmed: offsetToArmed,
          textOnPullDown: textOnPullDown,
          onRefresh: onRefresh,
          onPullDown: onPullDown,
          backgroundStack: backgroundStack,
          foregroundStack: foregroundStack,
          constraints: constraints,
          child: body,
        ),
        bottomSheet: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: constraints,
            child: bottomWidget,
          ),
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
