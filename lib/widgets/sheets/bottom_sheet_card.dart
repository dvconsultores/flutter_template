// FIXME under testing
import 'package:flutter/material.dart';

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
                padding: padding ??
                    EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                child: child,
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: padding ??
                    EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                child: child,
              ),
            ),
        ]);
      },
    );
  }
}
