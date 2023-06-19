import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/routes/user/repository/auth_api.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class LogInScreen extends StatelessWidget with ResponsiveLayoutMixin {
  const LogInScreen({super.key});

  @override
  Widget? tabletLayout(BuildContext context, BoxConstraints constraints) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final Size size = MediaQuery.of(context).size;

    return AppScaffold.responsive(
      tablet: (context, constraints) =>
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40.0),
          child: Hero(
            tag: "logo demo",
            child: Column(children: [
              Image.asset('assets/images/avatar.png',
                  height: size.height * 0.15),
              const Material(
                color: Colors.transparent,
                child: Text('Flutter Demo',
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
        TextButton(
          child: const Text("Login Button", style: TextStyle(fontSize: 25)),
          onPressed: () => AuthApi.authEndpoint().then((value) {
            userBloc.addData = value;
          }),
        ),
      ]),
    );
  }
}
