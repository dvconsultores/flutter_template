import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';

class UserScreen extends StatelessWidget with ResponsiveLayoutMixin {
  const UserScreen({super.key});

  @override
  Widget? tabletLayout(BuildContext context, BoxConstraints constraints) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("user", style: Theme.of(context).textTheme.displayMedium),
      TextButton(
          onPressed: () => UserBloc.of(context).closeSession,
          child: Text(
            "close sesion",
            style: Theme.of(context).textTheme.headlineMedium,
          )),
    ]);
  }
}
