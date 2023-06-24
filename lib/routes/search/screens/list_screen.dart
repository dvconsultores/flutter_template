import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/general/list_filterable.dart';
import 'package:flutter_detextre4/utils/helper_widgets/app_refresh_indicator.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final items = ListFilterable([
    "static-1",
    "static-2",
    "static-3",
  ]);

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => items.add("random-${math.Random().nextInt(100)}"));
    dev.log("refreshed");
  }

  Future<void> onPullDown() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => items.add("random-${math.Random().nextInt(100)}"));
    dev.log("charged");
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBody.responsive(
      tablet: (context, constraints) => AppRefreshIndicator.liquid(
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
