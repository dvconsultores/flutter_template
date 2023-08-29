import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_detextre4/utils/config/config.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    this.height = 80,
    required this.currentIndex,
    required this.onTap,
    this.selectedItemColor,
    this.selectedIconColor,
    required this.items,
  });
  final double height;
  final int currentIndex;
  final void Function(int index) onTap;
  final Color? selectedItemColor;
  final Color? selectedIconColor;
  final List<BottomNavigationBarItem> items;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  final selectedKey = GlobalKey();
  final renderBox = ValueNotifier<RenderBox?>(null);

  static const duration = 200;
  late final animation = AnimationController(
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
    duration: const Duration(milliseconds: duration),
  )..drive(CurveTween(curve: Curves.decelerate));

  late final opacityAnim = AnimationController(
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
    duration: const Duration(milliseconds: duration - 100),
  )..drive(Tween<double>(begin: 0, end: 1));

  double? cachedDx;
  double get getDx => renderBox.value?.localToGlobal(Offset.zero).dx ?? 0;

  void startAnimation() {
    opacityAnim.forward(from: 0);
    opacityAnim.stop();

    animation.forward(from: 0).then((_) {
      cachedDx = getDx;
      opacityAnim.forward(from: 0).then((value) => setState(() {}));
    });
  }

  void init() {
    setState(() => renderBox.value =
        selectedKey.currentContext?.findRenderObject() as RenderBox?);

    startAnimation();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(const Duration(milliseconds: 100), init),
    );
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    opacityAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final foregroundColor =
        Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    final colors = ThemeApp.colors(context);

    final selectedItem = widget.items.elementAt(widget.currentIndex);

    double? getWidth() => renderBox.value?.size.width;

    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          // animated dx
          final dxAnim = Tween<double>(
            begin: cachedDx ?? 0,
            end: getDx,
          ).animate(animation);

          // animated translate
          final translateAnim =
              Tween<double>(begin: 0, end: -20).animate(animation);

          return SizedBox(
            width: size.width,
            height: widget.height,
            child: CustomPaint(
              size: Size(size.width, widget.height),
              painter: _BNBCustomPainter(
                selectedDx: dxAnim.value,
                selectedWidth: getWidth(),
                color: foregroundColor!,
                activeColor: widget.selectedItemColor ?? colors.primary,
                opacity: opacityAnim.value,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.items
                      .mapIndexed((i, item) => i == widget.currentIndex
                          ? Transform.translate(
                              offset: Offset(0, translateAnim.value),
                              child: FloatingActionButton(
                                key: selectedKey,
                                heroTag: UniqueKey(),
                                onPressed: () {},
                                backgroundColor:
                                    widget.selectedItemColor ?? colors.primary,
                                foregroundColor:
                                    widget.selectedIconColor ?? foregroundColor,
                                elevation: .1,
                                tooltip: selectedItem.tooltip,
                                child: selectedItem.icon,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                widget.onTap(i);
                                startAnimation();
                              },
                              tooltip: item.tooltip,
                              icon: item.icon,
                            ))
                      .toList()),
            ),
          ).animate().moveY(begin: 100);
        });
  }
}

// TODO animate this painter with a stream outer him, that emits dynamicly values from positions
class _BNBCustomPainter extends CustomPainter {
  const _BNBCustomPainter({
    required this.color,
    required this.activeColor,
    required this.selectedWidth,
    required this.selectedDx,
    required this.opacity,
  });
  final Color color;
  final Color activeColor;
  final double? selectedWidth;
  final double? selectedDx;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedWidth == null || selectedDx == null) {
      return;
    }

    final dxl = selectedDx!;
    final w = selectedWidth!;
    final dxr = dxl + w;

    final dLeft = (size.width / dxl) + dxl;
    final dRight = (size.width / dxr) * dxl + w;

    bool shouldIncreasePixels() => size.width - dRight <= 13 ? true : false;

    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(dLeft / 3, 0, dxl - 35, 0)
      ..quadraticBezierTo(dxl - 13, 0, dxl - 13, 20)
      ..arcToPoint(
        Offset(dxr + 13, 20),
        radius: const Radius.circular(10.0),
        clockwise: false,
      )
      ..quadraticBezierTo(dxr + 13, 0, dxr + 25, 0)
      ..quadraticBezierTo(
          shouldIncreasePixels() ? dRight + 10 : dRight, 0, size.width, 20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.width)
      ..close();

    canvas.drawShadow(path, Colors.black.withOpacity(.8), 5, true);
    canvas.drawPath(path, paint);

    const double dxBubble = 13;
    final double dyBubble = w / 3;
    final double bubbleSize = 15 * opacity;
    final bubblePaint = Paint()..color = activeColor.withOpacity(opacity);

    canvas.drawCircle(
        Offset(dxl + dxBubble, dyBubble), bubbleSize, bubblePaint);
    canvas.drawCircle(
        Offset(dxr - dxBubble, dyBubble), bubbleSize, bubblePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
