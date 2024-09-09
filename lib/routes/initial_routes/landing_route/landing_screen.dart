import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final inherited =
    //     context.getInheritedWidgetOfExactType<LandingInherited>()!;

    return const AppScaffold(
      body: Column(children: [
        Text("data"),
      ]),
    );
  }
}
