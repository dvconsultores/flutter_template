import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/shell_routes/search_route/search_route.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';
import 'package:flutter_detextre4/widgets/loaders/refresh_indicator.dart';

class SearchDesktop extends StatelessWidget {
  const SearchDesktop({super.key});

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
