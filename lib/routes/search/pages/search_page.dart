import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/scaffold.dart';
import 'package:flutter_detextre4/routes/search/bloc/search_bloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchPage> {
  void testFunction(SearchBloc bloc) {
    bloc.addTicket();
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return ScaffoldBody.responsive(
      tablet: (context, constraints) => ListView(children: [
        Text(
          "search",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        TextButton(
          child: const Text(
            "Press button to search",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () => setState(() => testFunction(searchBloc)),
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
