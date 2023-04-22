import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SearchScreenTwo extends StatefulWidget {
  const SearchScreenTwo({super.key});

  @override
  State<SearchScreenTwo> createState() => _SearchScreenTwoState();
}

class _SearchScreenTwoState extends State<SearchScreenTwo> {
  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            log("${RouterNavigator.cachedNavigation} ⭕");
          },
          child: Text(
            "search 2",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        for (var i = 0; i < searchBloc.totalTickets.length; i++)
          Text(
            searchBloc.totalTickets[i].name,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
