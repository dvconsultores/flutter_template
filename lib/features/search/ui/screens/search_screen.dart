import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
            "search",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        TextButton(
          child: const Text(
            "Press button to search",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            setState(() {
              searchBloc.addTicket();
            });
          },
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
