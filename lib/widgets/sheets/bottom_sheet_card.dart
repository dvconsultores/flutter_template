import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

class BottomSheetCard extends StatelessWidget {
  const BottomSheetCard({
    super.key,
    this.padding,
    this.expand = false,
    this.initialChildSize = .33,
    this.minChildSize = .1,
    this.maxChildSize = .45,
    required this.child,
    this.scrollable = true,
  });
  final EdgeInsetsGeometry? padding;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool scrollable;
  final Widget child;

  static Future<T?> showModal<T>(
    BuildContext context, {
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    Widget Function(BuildContext context)? builder,
    bool expand = false,
    double initialChildSize = .33,
    double maxChildSize = .45,
    double minChildSize = .1,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    Widget? child,
  }) async =>
      await showModalBottomSheet<T>(
        context: context,
        clipBehavior: clipBehavior,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor ?? ThemeApp.colors(context).background,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Variables.radius50),
                topRight: Radius.circular(Variables.radius50),
              ),
            ),
        builder: builder ??
            (context) => BottomSheetCard(
                  expand: expand,
                  initialChildSize: initialChildSize,
                  maxChildSize: maxChildSize,
                  minChildSize: minChildSize,
                  padding: padding,
                  scrollable: scrollable,
                  child: child ?? const SizedBox.shrink(),
                ),
      );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Column(children: [
          if (scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding:
                    padding ?? Variables.paddingScaffold.copyWith(bottom: 0),
                child: child,
              ),
            )
          else
            Expanded(
              child: Padding(
                padding:
                    padding ?? Variables.paddingScaffold.copyWith(bottom: 0),
                child: child,
              ),
            ),
        ]);
      },
    );
  }
}

// TODO hacer extension del bototmsheetcard para agregar listas