import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/painters/draggable_frame_painter.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

BoxConstraints _defaultConstraints(BuildContext context) => BoxConstraints(
      maxWidth:
          context.width.isTablet ? double.infinity : Vars.mobileSize.width,
    );

class BottomSheetCard extends StatefulWidget {
  const BottomSheetCard({
    super.key,
    this.padding,
    this.expand = false,
    this.initialChildSize = .45,
    this.minChildSize = .2,
    this.maxChildSize = .45,
    required this.child,
    this.scrollable = true,
    this.title,
    this.titleText,
    this.titleStyle,
    this.floatingActionButton,
    this.bottomWidget,
    this.scrollController,
    this.backgroundColor = Colors.transparent,
  });
  final EdgeInsets? padding;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool scrollable;
  final Widget child;
  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? floatingActionButton;
  final Widget? bottomWidget;
  final ScrollController? scrollController;
  final Color? backgroundColor;

  static Future<T?> showModal<T>(
    BuildContext context, {
    Key? key,
    bool hideBottomNavigationBar = false,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    Widget Function(BuildContext context)? builder,
    bool expand = false,
    double initialChildSize = .45,
    double maxChildSize = .45,
    double minChildSize = .2,
    EdgeInsets? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    Widget? child,
    Widget? title,
    String? titleText,
    TextStyle? titleStyle,
    Widget? floatingActionButton,
    Widget? bottomWidget,
    ScrollController? scrollController,
    BoxConstraints? constraints,
  }) async {
    final value = await showModalBottomSheet<T>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      constraints: constraints ?? _defaultConstraints(context),
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius50),
              topRight: Radius.circular(Vars.radius50),
            ),
          ),
      builder: builder ??
          (context) => BottomSheetCard(
                key: key,
                expand: expand,
                initialChildSize: initialChildSize,
                maxChildSize: maxChildSize,
                minChildSize: minChildSize,
                padding: padding,
                scrollable: scrollable,
                title: title,
                titleText: titleText,
                titleStyle: titleStyle,
                floatingActionButton: floatingActionButton,
                bottomWidget: bottomWidget,
                scrollController: scrollController,
                child: child ?? const SizedBox.shrink(),
              ),
    );

    return value;
  }

  @override
  State<BottomSheetCard> createState() => _BottomSheetCardState();
}

class _BottomSheetCardState extends State<BottomSheetCard> {
  late final mainProvider = MainProvider.read(context);

  @override
  void initState() {
    mainProvider.setCurrentNavContext = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.padding ??
        EdgeInsets.only(
          top: Vars.gapXLarge,
          left: Vars.gapXLarge,
          right: Vars.gapXLarge,
          bottom: Vars.paddingScaffold.bottom,
        );

    return DraggableScrollableSheet(
      expand: widget.expand,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        final renderWidget = Column(children: [
          CustomPaint(
            size: const Size(double.maxFinite, 38),
            painter: DraggableFramePainter(bgColor: widget.backgroundColor),
          ),

          // title
          if (widget.title != null) ...[
            Gap(p.top).column,
            widget.title!,
          ] else if (widget.titleText != null)
            Padding(
                padding: p.copyWith(bottom: Vars.gapLow),
                child: Text(
                  widget.titleText!,
                  style: widget.titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                )),

          // content
          if (widget.scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController ?? scrollController,
                physics: const BouncingScrollPhysics(),
                padding: p,
                child: widget.child,
              ),
            )
          else
            Expanded(child: Padding(padding: p, child: widget.child)),
        ]);

        return widget.floatingActionButton != null ||
                widget.bottomWidget != null
            ? Scaffold(
                floatingActionButton: widget.floatingActionButton,
                bottomNavigationBar: widget.bottomWidget,
                backgroundColor: widget.backgroundColor,
                body: renderWidget,
              )
            : renderWidget;
      },
    );
  }
}
