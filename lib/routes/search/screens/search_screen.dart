import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with ResponsiveLayoutMixinStatefull {
  void testFunction(SearchBloc bloc) {
    bloc.addTicket();
  }

  @override
  Widget? tabletLayout(BuildContext context, BoxConstraints constraints) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return ListView(children: [
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
    ]);
  }
}
