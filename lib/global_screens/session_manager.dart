import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/routes/user/screens/log_in_screen.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// * Sesion manager - after splash screen
class SessionManagerScreen extends StatelessWidget {
  const SessionManagerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    // * listen user bloc
    userBloc.listen();
    userBloc.init();

    // * Session timeout manager
    final sessionConfig = SessionConfig(
        // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
        // invalidateSessionForUserInactivity: const Duration(seconds: 30),
        );

    sessionConfig.stream.listen((timeoutEvent) {
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

    return StreamBuilder<UserModel?>(
        stream: userBloc.dataUserStream,
        builder: (BuildContext context, snapshot) {
          return SessionTimeoutManager(
            sessionConfig: snapshot.hasData ? sessionConfig : SessionConfig(),
            child: !snapshot.hasData
                ? const LogInScreen()
                : const MainNavigation(),
          );
        });
  }
}
