import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/loaders/empty_data_widget.dart';
import 'package:flutter_detextre4/widgets/loaders/refresh_indicator.dart';
import 'package:flutter_gap/flutter_gap.dart';

class CustomListView<T> extends StatefulWidget {
  const CustomListView({
    super.key,
    required this.items,
    this.scrollController,
    this.physics,
    this.shrinkWrap = false,
    this.emptyText,
    this.onRefresh,
    this.onPullDown,
    this.isLoading = false,
    this.itemBuilder,
    this.loadingItemBuilder,
    this.padding,
    this.gap = Vars.gapXLarge,
  });
  final List<T>? items;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final String? emptyText;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onPullDown;
  final bool isLoading;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final Widget Function(BuildContext context, int index)? loadingItemBuilder;
  final EdgeInsets? padding;
  final double gap;

  @override
  State<CustomListView> createState() => CustomListViewState();
}

class CustomListViewState extends State<CustomListView> {
  final randomInt = math.Random().nextInt(9) + 1;

  @override
  Widget build(BuildContext context) {
    final padding = widget.padding ?? Vars.paddingScaffold;

    return AppRefreshIndicator.pullDown(
      onRefresh: widget.onRefresh,
      onPullDown: widget.onPullDown,
      child: ListView(
          controller: widget.scrollController,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          padding: padding,
          children: [
            if (widget.items == null || widget.isLoading)
              if (widget.loadingItemBuilder == null)
                const SizedBox.shrink()
              else
                for (var i = 0; i < randomInt; i++) ...[
                  widget.loadingItemBuilder!(context, i),
                  if (i < randomInt - 1) Gap(widget.gap).column
                ]
            //
            else if (widget.items!.isEmpty)
              EmptyDataWidget(labelText: widget.emptyText)
            //
            else
              for (var i = 0; i < widget.items!.length; i++) ...[
                widget.itemBuilder!(context, i),
                if (i < widget.items!.length - 1) Gap(widget.gap).column
              ]
          ]),
    );
  }
}
