import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_detextre4/repositories/auth_api.dart';
import 'package:flutter_detextre4/widgets/scaffold.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage>
    with ResponsiveLayoutMixinStateful {
  late final authApi = AuthApi(context);

  @override
  void initState() {
    authApi.clearTokenAuth();
    super.initState();
  }

  @override
  Widget? tabletLayout(BuildContext context, Constraints constraints) {
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
          onPressed: authApi.signIn,
          child: const Text("Login Button", style: TextStyle(fontSize: 25)),
        ),
      ]),
    );
  }
}
