import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';

class LandingMobile extends StatelessWidget {
  const LandingMobile(this.constraints, {super.key});
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    // final inherited =
    //     context.getInheritedWidgetOfExactType<LandingInherited>()!;

    return const AppScaffold(
      body: Text("here"),
    );
  }
}
