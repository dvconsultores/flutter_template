import 'package:flutter/material.dart';
import 'package:flutter_platzi_trips/features/user/bloc/user_bloc.dart';
import 'package:flutter_platzi_trips/main_navigation.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return signInUi();
          } else {
            return const MainNavigation();
          }
        });
  }

  Widget signInUi() {
    return Scaffold(body: Column());
  }
}
