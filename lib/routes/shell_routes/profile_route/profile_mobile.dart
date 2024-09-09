import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile_route/profile_route.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';

class ProfileMobile extends StatelessWidget {
  const ProfileMobile(this.constraints, {super.key});
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final inherited =
        context.getInheritedWidgetOfExactType<ProfileInherited>()!;

    return AppScaffold(
      goHomeOnBack: true,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("user", style: Theme.of(context).textTheme.displayMedium),
        Button(
          width: 200,
          text: "close sesion",
          onPressed: inherited.authApi.signOut,
        ),
      ]),
    );
  }
}
