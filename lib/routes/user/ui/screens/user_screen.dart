import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "user",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          TextButton(
              onPressed: () {
                userBloc.closeSesion();
              },
              child: Text(
                "close sesion",
                style: Theme.of(context).textTheme.headlineMedium,
              )),
        ],
      ),
    );
  }
}
