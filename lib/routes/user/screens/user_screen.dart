import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserScreen extends StatelessWidget with ResponsiveLayoutMixin {
  const UserScreen({super.key});

  @override
  Widget? tabletLayout(BuildContext context, BoxConstraints constraints) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("user", style: Theme.of(context).textTheme.displayMedium),
      TextButton(
          onPressed: () => userBloc.closeSession,
          child: Text(
            "close sesion",
            style: Theme.of(context).textTheme.headlineMedium,
          )),
    ]);
  }
}
