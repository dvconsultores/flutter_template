import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/list_filterable.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';
import 'package:flutter_detextre4/widgets/loaders/refresh_indicator.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListViewExampleState();
}

class _ListViewExampleState extends State<ListPage> {
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
    return AppScaffold(
      goHomeOnBack: true,
      body: AppRefreshIndicator.liquid(
        onRefresh: onRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) =>
              Text(items.filtered[index].toCapitalize()),
          itemCount: items.filtered.length,
          separatorBuilder: (context, index) => const Divider(height: 20),
        ),
      ),
    );
  }
}
