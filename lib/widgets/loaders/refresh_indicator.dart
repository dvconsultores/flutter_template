import 'dart:math' as math;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/painters/sky_painter.dart';
import 'package:flutter_detextre4/painters/triangule_painter.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart' as liq;

/// A `RefreshIndicator` with Custom app loader on refresh list.
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.child,
    this.controller,
    required this.onRefresh,
    this.builder,
    this.trailingScrollIndicatorVisible = true,
    this.leadingScrollIndicatorVisible = false,
    this.trigger = IndicatorTrigger.leadingEdge,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.offsetToArmed,
  });
  final Widget child;
  final IndicatorController? controller;
  final RefreshCallback onRefresh;
  final Widget Function(
    BuildContext context,
    Widget child,
    IndicatorController controller,
  )? builder;
  final bool trailingScrollIndicatorVisible;
  final bool leadingScrollIndicatorVisible;
  final IndicatorTrigger trigger;
  final bool Function(ScrollNotification scrollNotification)
      notificationPredicate;
  final double? offsetToArmed;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      notificationPredicate: notificationPredicate,
      offsetToArmed: offsetToArmed,
      controller: controller,
      builder: (context, child, controller) {
        if (builder != null) return builder!(context, child, controller);

        return MaterialIndicatorDelegate(
          builder: (context, controller) => AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: controller.value.clamp(0, 1),
            child: const Icon(
              Icons.cached,
              color: Colors.blue,
              size: 30,
            ),
          ),
        )(context, child, controller);
      },
      trailingScrollIndicatorVisible: trailingScrollIndicatorVisible,
      leadingScrollIndicatorVisible: leadingScrollIndicatorVisible,
      trigger: trigger,
      onRefresh: onRefresh,
      child: child,
    );
  }

  /// A variant used to fetch data on pull down.
  static Widget pullDown({
    required Widget child,
    RefreshCallback? onRefresh,
    RefreshCallback? onPullDown,
    String textOnPullDown = "Pull to fetch more",
    String textOnChargePullDown = "Fetching...",
    bool Function(ScrollNotification scrollNotification) notificationPredicate =
        defaultScrollNotificationPredicate,
    double? offsetToArmed,
  }) {
    var indicatorController = IndicatorController();
    const height = 150.0;

    return AppRefreshIndicator(
      offsetToArmed: offsetToArmed,
      notificationPredicate: notificationPredicate,
      controller: indicatorController,
      builder: (context, child, controller) {
        indicatorController = controller;
        bool isLeading =
            onRefresh != null && controller.edge == IndicatorEdge.leading;
        bool isTrailing =
            onPullDown != null && controller.edge == IndicatorEdge.trailing;

        //* leading y animation
        final dyLeading =
            controller.value.clamp(0.0, 1.25) * (height - (height * 0.25)) -
                (height - (height * 0.70));

        //* trailing y animation
        final dyTrailing =
            controller.value.clamp(0.0, 1.25) * -(height - (height * 0.25));

        return Stack(children: [
          Transform.translate(
            offset: Offset(
              0.0,
              isTrailing ? dyTrailing : 0,
            ),
            child: child,
          ),

          //* leading indicator
          if (isLeading)
            Positioned(
              top: dyLeading,
              left: 0,
              right: 0,
              child: Center(
                  child: Container(
                height: 42,
                width: 42,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: controller.value.clamp(0, 1),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    value: !controller.isLoading
                        ? controller.value.clamp(0.0, 1.0)
                        : null,
                  ),
                ),
              )),
            ),

          //* trailing indicator
          if (isTrailing)
            Positioned(
              bottom: -height,
              left: 0,
              right: 0,
              height: height,
              child: Container(
                transform: Matrix4.translationValues(0.0, dyTrailing, 0.0),
                padding: const EdgeInsets.only(top: 30.0),
                constraints: const BoxConstraints.expand(),
                child: Column(children: [
                  if (controller.isLoading)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: ThemeApp.colors(context).primary,
                        strokeWidth: 3,
                      ),
                    )
                  else
                    const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black,
                    ),
                  Text(
                      controller.isLoading
                          ? textOnChargePullDown
                          : textOnPullDown,
                      style: const TextStyle(
                        color: Colors.black,
                      ))
                ]),
              ),
            ),
        ]);
      },
      trigger: IndicatorTrigger.bothEdges,
      trailingScrollIndicatorVisible: onPullDown == null,
      leadingScrollIndicatorVisible: onRefresh == null,
      onRefresh: () async {
        if (indicatorController.edge == IndicatorEdge.leading) {
          onRefresh != null ? await onRefresh() : null;
        } else {
          onPullDown != null ? await onPullDown() : null;
        }
      },
      child: child,
    );
  }

  /// [Envelope] variant of `RefreshIndicator`.
  static Widget envelope({
    required Widget child,
    RefreshCallback? onRefresh,
    RefreshCallback? onPullDown,
    Color? color,
    String textOnPullDown = "Pull to fetch more",
    String textOnChargePullDown = "Fetching...",
    bool Function(ScrollNotification scrollNotification) notificationPredicate =
        defaultScrollNotificationPredicate,
    double? offsetToArmed,
  }) {
    var indicatorController = IndicatorController();
    const circleSize = 70.0;
    const iconSize = 35.0;
    const defaultShadow = [BoxShadow(blurRadius: 10, color: Colors.black26)];

    return AppRefreshIndicator(
      offsetToArmed: offsetToArmed,
      notificationPredicate: notificationPredicate,
      builder: (context, child, controller) =>
          LayoutBuilder(builder: (context, constraints) {
        indicatorController = controller;
        bool isLeading =
            onRefresh != null && controller.edge == IndicatorEdge.leading;
        bool isTrailing =
            onPullDown != null && controller.edge == IndicatorEdge.trailing;

        //* Leading values
        final widgetWidth = constraints.maxWidth;
        final widgetHeight = constraints.maxHeight;
        final letterTopWidth = (widgetWidth / 2) + 50;

        final leftValue =
            (widgetWidth - (letterTopWidth * controller.value / 1))
                .clamp(letterTopWidth - 100, double.infinity);

        final rightValue = (widgetWidth - (widgetWidth * controller.value / 1))
            .clamp(0.0, double.infinity);

        final opacity = (controller.value - 1).clamp(0, 0.5) / 0.5;

        //* Trailing values
        final sideValue = (widgetWidth - (widgetWidth * controller.value / 12))
            .clamp(0.0, double.infinity);

        final bottomValue = -(widgetHeight - (widgetHeight * controller.value))
            .clamp(0.0, double.infinity);

        return Stack(children: <Widget>[
          Transform.scale(
            scale: isLeading || isTrailing
                ? 1 - 0.1 * controller.value.clamp(0.0, 1.0)
                : 1,
            child: child,
          ),

          //* Leading animation
          if (isLeading) ...[
            Positioned(
              right: rightValue,
              child: Container(
                height: widgetHeight,
                width: widgetWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadow,
                ),
              ),
            ),
            Positioned(
              left: leftValue,
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: Colors.white,
                  paintingStyle: PaintingStyle.fill,
                ),
                child: SizedBox(
                  height: widgetHeight,
                  width: letterTopWidth,
                ),
              ),
            ),
            if (controller.value >= 1)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 100),
                child: Transform.scale(
                  scale: controller.value,
                  child: Opacity(
                    opacity: controller.isLoading ? 1 : opacity,
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        boxShadow: defaultShadow,
                        color: color ?? ThemeApp.colors(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child:
                          Stack(alignment: Alignment.center, children: <Widget>[
                        SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: CircularProgressIndicator(
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.black),
                            value: controller.isLoading ? null : 0,
                          ),
                        ),
                        const Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ]),
                    ),
                  ),
                ),
              )
          ],

          //* Trailing animation
          if (isTrailing) ...[
            Positioned(
              right: sideValue,
              child: Container(
                height: widgetHeight,
                width: widgetWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadow,
                ),
              ),
            ),
            Positioned(
              left: sideValue,
              child: Container(
                height: widgetHeight,
                width: widgetWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadow,
                ),
              ),
            ),
            Positioned(
              bottom: bottomValue,
              child: CustomPaint(
                  painter: TrianglePainter(
                    strokeColor: Colors.white,
                    paintingStyle: PaintingStyle.fill,
                    getTrianglePath: (x, y) => Path()
                      ..moveTo(x / 2, 0)
                      ..lineTo(x, y)
                      ..lineTo(0, y)
                      ..lineTo(x / 2, 0),
                  ),
                  child: SizedBox(
                    height: widgetWidth / 2.5,
                    width: widgetWidth,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.value >= 1) ...[
                            Transform.scale(
                              scale: controller.value,
                              child: Opacity(
                                opacity: controller.isLoading ? 1 : opacity,
                                child: Container(
                                  width: circleSize / 2,
                                  height: circleSize / 2,
                                  decoration: BoxDecoration(
                                    boxShadow: defaultShadow,
                                    color: color ??
                                        ThemeApp.colors(context).primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                const AlwaysStoppedAnimation(
                                                    Colors.black),
                                            value:
                                                controller.isLoading ? null : 0,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.mail_outline,
                                          color: Colors.white,
                                          size: iconSize / 2,
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          Text(
                              controller.isLoading
                                  ? textOnChargePullDown
                                  : textOnPullDown,
                              style: const TextStyle(
                                color: Colors.black,
                              )),
                        ]),
                  )),
            ),
          ],
        ]);
      }),
      leadingScrollIndicatorVisible: onRefresh == null,
      trailingScrollIndicatorVisible: onPullDown == null,
      trigger: IndicatorTrigger.bothEdges,
      onRefresh: () async {
        if (indicatorController.edge == IndicatorEdge.leading) {
          onRefresh != null ? await onRefresh() : null;
        } else {
          onPullDown != null ? await onPullDown() : null;
        }
      },
      child: child,
    );
  }

  /// [Warp] variant of `RefreshIndicator`.
  static Widget warp({
    required Widget child,
    int starsCount = 30,
    required AsyncCallback onRefresh,
    IndicatorController? controller,
    Color skyColor = Colors.transparent,
    StarColorGetter starColorGetter = _defaultStarColorGetter,
    Key? indicatorKey,
  }) {
    return WarpRefreshIndicator(
      indicatorKey: indicatorKey,
      onRefresh: onRefresh,
      controller: controller,
      starsCount: starsCount,
      starColorGetter: starColorGetter,
      skyColor: skyColor,
      child: child,
    );
  }

  static Widget liquid({
    required Future<void> Function() onRefresh,
    required Widget child,
    double animSpeedFactor = 1.0,
    Color? backgroundColor,
    double borderWidth = 2.0,
    Color? color,
    double? height,
    bool showChildOpacityTransition = true,
    int springAnimationDurationInMilliseconds = 1000,
  }) =>
      liq.LiquidPullToRefresh(
        onRefresh: onRefresh,
        animSpeedFactor: animSpeedFactor,
        backgroundColor: backgroundColor,
        borderWidth: borderWidth,
        color: color,
        height: height,
        showChildOpacityTransition: showChildOpacityTransition,
        springAnimationDurationInMilliseconds:
            springAnimationDurationInMilliseconds,
        child: child,
      );
}

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;

Color _defaultStarColorGetter(int index) => ThemeApp.colors(null).primary;

enum WarpAnimationState {
  stopped,
  playing,
}

typedef StarColorGetter = Color Function(int index);

class WarpRefreshIndicator extends StatefulWidget {
  final Widget child;
  final int starsCount;
  final AsyncCallback onRefresh;
  final IndicatorController? controller;
  final Color skyColor;
  final StarColorGetter starColorGetter;
  final Key? indicatorKey;
  final bool Function(ScrollNotification scrollNotification)
      notificationPredicate;

  const WarpRefreshIndicator({
    super.key,
    this.indicatorKey,
    this.controller,
    required this.onRefresh,
    required this.child,
    this.starsCount = 30,
    this.skyColor = Colors.transparent,
    this.starColorGetter = _defaultStarColorGetter,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  @override
  State<WarpRefreshIndicator> createState() => _WarpIndicatorState();
}

class _WarpIndicatorState extends State<WarpRefreshIndicator>
    with SingleTickerProviderStateMixin {
  static const _indicatorSize = 150.0;
  final _random = math.Random();
  WarpAnimationState _state = WarpAnimationState.stopped;

  List<StarPainter> stars = [];
  final _offsetTween = Tween<Offset>(begin: Offset.zero, end: Offset.zero);
  final _angleTween = Tween<double>(begin: 0, end: 0);

  late final AnimationController shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );

  static final _scaleTween = Tween(begin: 1.0, end: 0.75);
  static final _radiusTween = Tween(begin: 0.0, end: 16.0);

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }

  Offset _getRandomOffset() => Offset(
        _random.nextInt(10) - 5,
        _random.nextInt(10) - 5,
      );

  double _getRandomAngle() {
    final degrees = ((_random.nextDouble() * 2) - 1);
    final radians = degrees == 0 ? 0.0 : degrees / 360.0;
    return radians;
  }

  void _shiftAndGenerateRandomShakeTransform() {
    _offsetTween.begin = _offsetTween.end;
    _offsetTween.end = _getRandomOffset();

    _angleTween.begin = _angleTween.end;
    _angleTween.end = _getRandomAngle();
  }

  void _startShakeAnimation() {
    _shiftAndGenerateRandomShakeTransform();
    shakeController.animateTo(1.0);
    _state = WarpAnimationState.playing;
    stars = List.generate(
      widget.starsCount,
      (index) => StarPainter(initialColor: widget.starColorGetter(index)),
    );
  }

  void _resetShakeAnimation() {
    _shiftAndGenerateRandomShakeTransform();
    shakeController.value = 0.0;
    shakeController.animateTo(1.0);
  }

  void _stopShakeAnimation() {
    _offsetTween.end = Offset.zero;
    _angleTween.end = 0.0;
    _state = WarpAnimationState.stopped;
    _shiftAndGenerateRandomShakeTransform();
    shakeController.stop();
    shakeController.value = 0.0;
    stars = [];
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      key: widget.indicatorKey,
      notificationPredicate: widget.notificationPredicate,
      controller: widget.controller,
      offsetToArmed: _indicatorSize,
      leadingScrollIndicatorVisible: false,
      trailingScrollIndicatorVisible: true,
      onRefresh: widget.onRefresh,
      autoRebuild: false,
      onStateChanged: (change) {
        if (change.didChange(to: IndicatorState.loading)) {
          _startShakeAnimation();
        } else if (change.didChange(to: IndicatorState.idle)) {
          _stopShakeAnimation();
        }
      },
      child: widget.child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        final animation = Listenable.merge([controller, shakeController]);

        return Stack(children: <Widget>[
          AnimatedBuilder(
              animation: shakeController,
              builder: (_, __) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return CustomPaint(
                      painter: SkyPainter(
                        stars: stars,
                        color: widget.skyColor,
                      ),
                      child: const SizedBox.expand(),
                    );
                  },
                );
              }),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Transform.scale(
                scale: _scaleTween.transform(controller.value),
                child: Builder(builder: (context) {
                  if (shakeController.value == 1.0 &&
                      _state == WarpAnimationState.playing) {
                    _ambiguate(SchedulerBinding.instance)!
                        .addPostFrameCallback((_) => _resetShakeAnimation());
                  }
                  return Transform.rotate(
                    angle: _angleTween.transform(shakeController.value),
                    child: Transform.translate(
                      offset: _offsetTween.transform(shakeController.value),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          _radiusTween.transform(controller.value),
                        ),
                        child: child,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ]);
      },
    );
  }
}
