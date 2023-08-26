import 'package:flutter/material.dart';
import 'package:flutter_detextre4/repositories/auth_api.dart';
import 'package:flutter_detextre4/widgets/scaffold.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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
