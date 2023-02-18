import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/features/user/ui/widgets/sign_in_page.dart';
import 'package:flutter_detextre4/main_navigation.dart';
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

    return StreamBuilder<UserModel?>(
        stream: userBloc.getDataUserStream,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const SignInPage();
          } else {
            return const MainNavigation();
          }
        });
  }
}
