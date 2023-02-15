import 'package:flutter/material.dart';
import 'package:flutter_platzi_trips/features/search/bloc/search_bloc.dart';
import 'package:flutter_platzi_trips/main_provider.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return ListView(
      children: [
        Text(
          "search \n ${searchBloc.count}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        TextButton(
          child: const Text("press button"),
          onPressed: () {
            setState(() {
              mainProvider.addTicket();
            });
          },
        ),
        for (var i = 0; i < mainProvider.totalTickets.length; i++)
          Text(
            mainProvider.totalTickets[i].name,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
