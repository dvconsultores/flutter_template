import 'dart:math' as math;

import 'package:flutter_detextre4/routes/shell_routes/search_route/search_desktop.dart';
import 'package:flutter_detextre4/routes/shell_routes/search_route/search_mobile.dart';
import 'package:flutter_detextre4/utils/general/list_filterable.dart';
import 'package:flutter/material.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

class SearchRoute extends StatefulWidget {
  const SearchRoute({super.key});

  @override
  State<SearchRoute> createState() => _ListViewExampleState();
}

class _ListViewExampleState extends State<SearchRoute> {
  final items = ListFilterable([
    "static-1",
    "static-2",
    "static-3",
  ]);

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => items.add("random-${math.Random().nextInt(100)}"));
    }
  }

  Future<void> onPullDown() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => items.add("random-${math.Random().nextInt(100)}"));
  }

  @override
  Widget build(BuildContext context) {
    return SearchInherited(
      items: items,
      onPullDown: onPullDown,
      onRefresh: onRefresh,
      child: ResponsiveLayout(
        desktop: (context, constraints) => SearchDesktop(constraints),
        tablet: (context, constraints) => SearchMobile(constraints),
      ),
    );
  }
}

class SearchInherited extends InheritedWidget {
  const SearchInherited({
    super.key,
    required super.child,
    required this.items,
    required this.onRefresh,
    required this.onPullDown,
  });
  final ListFilterable items;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onPullDown;

  @override
  bool updateShouldNotify(SearchInherited oldWidget) => true;
}
