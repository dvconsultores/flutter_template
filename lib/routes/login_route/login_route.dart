import 'package:flutter/material.dart';
import 'package:flutter_detextre4/repositories/auth_api.dart';
import 'package:flutter_detextre4/routes/login_route/login_screen.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  late final AuthApi authApi;

  @override
  void initState() {
    authApi = AuthApi(context);
    authApi.clearTokenAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginInherited(
      authApi: authApi,
      child: const LoginScreen(),
    );
  }
}

class LoginInherited extends InheritedWidget {
  const LoginInherited({
    super.key,
    required super.child,
    required this.authApi,
  });
  final AuthApi authApi;

  @override
  bool updateShouldNotify(LoginInherited oldWidget) =>
      authApi != oldWidget.authApi;
}
