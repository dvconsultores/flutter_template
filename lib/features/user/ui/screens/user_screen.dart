import 'package:flutter/material.dart';
import 'package:flutter_platzi_trips/features/search/bloc/search_bloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return Center(
      child: Text(
        "user \n ${searchBloc.count}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
