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
    with SingleTickerProviderStateMixin {
  final selectedKey = GlobalKey();
  final selectedBox = ValueNotifier<RenderBox?>(null);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) => Future.delayed(
          const Duration(milliseconds: 100),
          () => setState(() => selectedBox.value =
              selectedKey.currentContext?.findRenderObject() as RenderBox?),
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final foregroundColor =
        Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    final colors = ThemeApp.colors(context);

    final selectedItem = widget.items.elementAt(widget.currentIndex);

    return SizedBox(
      width: size.width,
      height: widget.height,
      child: CustomPaint(
        size: Size(size.width, widget.height),
        painter: _BNBCustomPainter(
          selectedBox: selectedBox,
          color: foregroundColor!,
          activeColor: widget.selectedItemColor ?? colors.primary,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items
                .mapIndexed((i, item) => i == widget.currentIndex
                    ? Transform.translate(
                        offset: Offset(0, widget.height * -.3),
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
                        onPressed: () => widget.onTap(i),
                        tooltip: item.tooltip,
                        icon: item.icon,
                      ))
                .toList()),
      ),
    ).animate().moveY(begin: 100);
  }
}

class _BNBCustomPainter extends CustomPainter {
  const _BNBCustomPainter({
    required this.color,
    required this.activeColor,
    required this.selectedBox,
  }) : super(repaint: selectedBox);
  final Color color;
  final Color activeColor;
  final ValueNotifier<RenderBox?> selectedBox;

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedBox.value == null) return;
    final box = selectedBox.value!;

    final dxl = box.localToGlobal(Offset.zero).dx;
    final w = box.size.width;
    final dxr = dxl + w;

    final dLeft = (size.width / dxl) + dxl;
    final dRight = (size.width / dxr) * dxl + w;

    bool shouldIncreasePixels() => size.width - dRight <= 13 ? true : false;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

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
    const double bubbleSize = 15;
    final bubblePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(dxl + dxBubble, dyBubble), bubbleSize, bubblePaint);
    canvas.drawCircle(
        Offset(dxr - dxBubble, dyBubble), bubbleSize, bubblePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
