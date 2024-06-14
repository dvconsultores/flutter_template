import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class PositionalWidget extends StatelessWidget {
  const PositionalWidget({
    super.key,
    this.topWidget,
    this.topGap = 0,
    this.leadingWidget,
    this.leadingGap = 0,
    required this.child,
    this.traillingWidget,
    this.traillingGap = 0,
    this.bottomWidget,
    this.bottomGap = 0,
    this.columnCrossAxisAlignment = CrossAxisAlignment.start,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
  });

  final Widget? topWidget;
  final double topGap;
  final Widget? leadingWidget;
  final double leadingGap;
  final Widget child;
  final Widget? traillingWidget;
  final double traillingGap;
  final Widget? bottomWidget;
  final double bottomGap;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment rowMainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: columnCrossAxisAlignment,
        mainAxisAlignment: columnMainAxisAlignment,
        children: [
          // top widget
          if (topWidget != null) topWidget!,
          Gap(topGap).column,

          // middle widget
          Row(
              crossAxisAlignment: rowCrossAxisAlignment,
              mainAxisAlignment: rowMainAxisAlignment,
              children: [
                // leading widget
                if (leadingWidget != null) leadingWidget!,
                Gap(leadingGap).row,

                // content widget
                child,

                // trailling widget
                Gap(traillingGap).row,
                if (traillingWidget != null) traillingWidget!,
              ]),

          // bottom widget
          Gap(bottomGap).column,
          if (bottomWidget != null) bottomWidget!,
        ]);
  }
}
