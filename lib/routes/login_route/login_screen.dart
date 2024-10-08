import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/login_route/login_route.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inherited = context.getInheritedWidgetOfExactType<LoginInherited>()!;

    return AppScaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40.0),
          child: Hero(
            tag: "logo demo",
            child: Column(children: [
              Image.asset(
                'assets/images/avatar.png',
                height: 150,
              ),
              const Material(
                color: Colors.transparent,
                child: Text('Flutter Demo Desktop',
                    style:
                        TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
        ),
        Center(
          child: Text(
            "login page",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Button(
          width: 200,
          text: "Login Button",
          onPressed: inherited.authApi.signIn,
        ),
      ]),
    );
  }
}
