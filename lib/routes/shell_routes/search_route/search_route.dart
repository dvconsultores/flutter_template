import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/shell_routes/search_route/search_screen.dart';
import 'package:flutter_detextre4/utils/general/list_filterable.dart';

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
      child: const SearchDesktop(),
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
  final ListFilterable<String> items;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onPullDown;

  @override
  bool updateShouldNotify(SearchInherited oldWidget) => true;
}
