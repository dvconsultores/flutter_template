import 'package:flutter/material.dart';
import 'package:flutter_detextre4/repositories/auth_api.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile_route/profile_desktop.dart';
import 'package:flutter_detextre4/routes/shell_routes/profile_route/profile_mobile.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

class ProfileRoute extends StatelessWidget {
  const ProfileRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final authApi = AuthApi(context);

    return ProfileInherited(
      authApi: authApi,
      child: ResponsiveLayout(
        desktop: (context, constraints) => ProfileDesktop(constraints),
        mobile: (context, constraints) => ProfileMobile(constraints),
      ),
    );
  }
}

class ProfileInherited extends InheritedWidget {
  const ProfileInherited({
    super.key,
    required super.child,
    required this.authApi,
  });
  final AuthApi authApi;

  @override
  bool updateShouldNotify(ProfileInherited oldWidget) =>
      authApi != oldWidget.authApi;
}
