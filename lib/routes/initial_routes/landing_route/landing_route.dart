import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/initial_routes/landing_route/landing_desktop.dart';
import 'package:flutter_detextre4/routes/initial_routes/landing_route/landing_mobile.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

class LandingRoute extends StatelessWidget {
  const LandingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktop: (context, constraints) => LandingDesktop(constraints),
      tablet: (context, constraints) => LandingMobile(constraints),
    );
  }
}

class LandingInherited extends InheritedWidget {
  const LandingInherited({super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
