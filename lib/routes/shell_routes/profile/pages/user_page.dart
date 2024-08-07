import 'package:flutter/material.dart';
import 'package:flutter_detextre4/repositories/auth_api.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authAPI = AuthApi(context);

    return AppScaffold.responsive(
      tablet: (context, constraints) =>
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("user", style: Theme.of(context).textTheme.displayMedium),
        Button(
          width: 200,
          text: "close sesion",
          onPressed: authAPI.signOut,
        ),
      ]),
    );
  }
}
