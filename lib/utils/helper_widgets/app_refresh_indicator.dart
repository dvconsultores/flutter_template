import 'dart:math' as math;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterDetextre4/utils/helper_widgets/painters.dart';

/// A `RefreshIndicator` with Custom app loader on refresh list.
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.builder,
    this.trailingScrollIndicatorVisible = true,
    this.leadingScrollIndicatorVisible = true,
    this.trigger = IndicatorTrigger.leadingEdge,
  });
  final Widget child;
  final RefreshCallback onRefresh;
  final Widget Function(
    BuildContext context,
    Widget child,
    IndicatorController controller,
  )? builder;
  final bool trailingScrollIndicatorVisible;
  final bool leadingScrollIndicatorVisible;
  final IndicatorTrigger trigger;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      builder: (context, child, controller) {
        if (builder != null) return builder!(context, child, controller);

        return MaterialIndicatorDelegate(
            builder: (context, controller) => const Icon(
                  Icons.cached,
                  color: Colors.blue,
                  size: 30,
                ))(context, child, controller);
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
    required RefreshCallback onRefresh,
    bool trailingScrollIndicatorVisible = false,
    bool leadingScrollIndicatorVisible = true,
    String textOnPullDown = "Pull to fetch more",
    String textOnRefresh = "Fetching...",
  }) {
    const height = 150.0;

    return AppRefreshIndicator(
      builder: (context, child, controller) {
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy = controller.value.clamp(0.0, 1.25) *
                  -(height - (height * 0.25));
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, dy),
                    child: child,
                  ),
                  Positioned(
                    bottom: -height,
                    left: 0,
                    right: 0,
                    height: height,
                    child: Container(
                      transform: Matrix4.translationValues(0.0, dy, 0.0),
                      padding: const EdgeInsets.only(top: 30.0),
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                        children: [
                          if (controller.isLoading)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 2,
                              ),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.black,
                            ),
                          Text(
                            controller.isLoading
                                ? textOnRefresh
                                : textOnPullDown,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: trailingScrollIndicatorVisible,
      leadingScrollIndicatorVisible: leadingScrollIndicatorVisible,
      onRefresh: onRefresh,
      child: child,
    );
  }

  /// [Envelope] variant of `RefreshIndicator`.
  static Widget envelope({
    required Widget child,
    required RefreshCallback onRefresh,
    bool leadingScrollIndicatorVisible = true,
    bool trailingScrollIndicatorVisible = false,
    Color? color,
  }) {
    const circleSize = 70.0;
    const defaultShadow = [BoxShadow(blurRadius: 10, color: Colors.black26)];

    return AppRefreshIndicator(
      builder: (context, child, controller) =>
          LayoutBuilder(builder: (context, constraints) {
        final widgetWidth = constraints.maxWidth;
        final widgetHeight = constraints.maxHeight;
        final letterTopWidth = (widgetWidth / 2) + 50;

        final leftValue =
            (widgetWidth - (letterTopWidth * controller.value / 1))
                .clamp(letterTopWidth - 100, double.infinity);

        final rightValue = (widgetWidth - (widgetWidth * controller.value / 1))
            .clamp(0.0, double.infinity);

        final opacity = (controller.value - 1).clamp(0, 0.5) / 0.5;
        return Stack(
          children: <Widget>[
            Transform.scale(
              scale: 1 - 0.1 * controller.value.clamp(0.0, 1.0),
              child: child,
            ),
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
                padding: const EdgeInsets.only(right: 100),
                child: Transform.scale(
                  scale: controller.value,
                  child: Opacity(
                    opacity: controller.isLoading ? 1 : opacity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          boxShadow: defaultShadow,
                          color: color ?? Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
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
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
      }),
      leadingScrollIndicatorVisible: leadingScrollIndicatorVisible,
      trailingScrollIndicatorVisible: trailingScrollIndicatorVisible,
      onRefresh: onRefresh,
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
}

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;

Color _defaultStarColorGetter(int index) =>
    HSLColor.fromAHSL(1, math.Random().nextDouble() * 360, 1, 0.98).toColor();

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

  const WarpRefreshIndicator({
    super.key,
    this.indicatorKey,
    this.controller,
    required this.onRefresh,
    required this.child,
    this.starsCount = 30,
    this.skyColor = Colors.transparent,
    this.starColorGetter = _defaultStarColorGetter,
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

  late AnimationController shakeController;

  static final _scaleTween = Tween(begin: 1.0, end: 0.75);
  static final _radiusTween = Tween(begin: 0.0, end: 16.0);

  @override
  void initState() {
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

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
      controller: widget.controller,
      offsetToArmed: _indicatorSize,
      leadingScrollIndicatorVisible: false,
      trailingScrollIndicatorVisible: false,
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

        return Stack(
          children: <Widget>[
            AnimatedBuilder(
                animation: shakeController,
                builder: (_, __) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
          ],
        );
      },
    );
  }
}
