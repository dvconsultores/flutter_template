import 'package:flutter/material.dart';
import 'package:flutterDetextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutterDetextre4/utils/helper_widgets/responsive_layout.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.drawer,
    this.appBar,
    this.mobile,
    this.tablet,
    this.desktop,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.sessionTimer = true,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool sessionTimer;

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    // * Session timeout manager
    final sessionConfig = SessionConfig(
        // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
        // invalidateSessionForUserInactivity: const Duration(seconds: 30),
        );

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      switch (timeoutEvent) {
        case SessionTimeoutState.userInactivityTimeout:
          // * handle user  inactive timeout
          userBloc.closeSesion;
          break;
        case SessionTimeoutState.appFocusTimeout:
          // * handle user  app lost focus timeout
          userBloc.closeSesion;
          break;
      }
    });

    return SessionTimeoutManager(
      sessionConfig: sessionTimer ? sessionConfig : SessionConfig(),
      child: Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: ResponsiveLayout(
            mobile: mobile,
            tablet: tablet,
            desktop: desktop,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
