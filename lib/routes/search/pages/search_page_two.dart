import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/scaffold.dart';
import 'package:flutter_detextre4/routes/search/bloc/search_bloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SearchPageTwo extends StatefulWidget {
  const SearchPageTwo({super.key});

  @override
  State<SearchPageTwo> createState() => _SearchPageTwoState();
}

class _SearchPageTwoState extends State<SearchPageTwo> {
  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return ScaffoldBody.responsive(
      tablet: (context, constraints) => ListView(children: [
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
      ]),
    );
  }
}
