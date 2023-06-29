import 'package:flutter/material.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:flutter_detextre4/routes/user/repository/auth_api.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authAPI = AuthApi(context);

    return ScaffoldBody.responsive(
      tablet: (context, constraints) =>
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("user", style: Theme.of(context).textTheme.displayMedium),
        TextButton(
            onPressed: authAPI.signOut,
            child: Text(
              "close sesion",
              style: Theme.of(context).textTheme.headlineMedium,
            )),
      ]),
    );
  }
}
