import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/features/user/repository/auth_api.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "login page",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        TextButton(
            onPressed: () async {
              final UserModel result = await AuthApi.authEndpoint();
              userBloc.setDataUserSink = result;
            },
            child: const Text(
              "Login Button",
              style: TextStyle(fontSize: 25),
            )),
      ],
    ));
  }
}
