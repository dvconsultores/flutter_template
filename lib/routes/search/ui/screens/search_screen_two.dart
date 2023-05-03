import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/search/bloc/search_bloc.dart';
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
        Text(
          "search 2",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
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
