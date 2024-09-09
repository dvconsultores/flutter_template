import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/shell_routes/search_route/search_route.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';
import 'package:flutter_detextre4/widgets/loaders/refresh_indicator.dart';

class SearchMobile extends StatelessWidget {
  const SearchMobile(this.constraints, {super.key});
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final inherited = context.getInheritedWidgetOfExactType<SearchInherited>()!;

    return AppScaffold(
      goHomeOnBack: true,
      body: AppRefreshIndicator.liquid(
        onRefresh: inherited.onRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) =>
              Text(inherited.items.filtered[index].toCapitalize()),
          itemCount: inherited.items.filtered.length,
          separatorBuilder: (context, index) => const Divider(height: 20),
        ),
      ),
    );
  }
}
