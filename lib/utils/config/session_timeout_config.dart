import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_router.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

mixin SessionTimeoutConfig {
  static final instance = SessionConfig(
      // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
      // invalidateSessionForUserInactivity: const Duration(seconds: 30),
      );

  static void listen(BuildContext context) =>
      instance.stream.listen((timeoutEvent) {
        //? Exception routes
        if (routerConfig.location == "/login" ||
            routerConfig.location == "/splash") {
          return;
        }

        switch (timeoutEvent) {
          case SessionTimeoutState.userInactivityTimeout:
            // * handle user  inactive timeout
            UserBloc.of(context).closeSession;
            break;

          case SessionTimeoutState.appFocusTimeout:
            // * handle user  app lost focus timeout
            UserBloc.of(context).closeSession;
            break;
        }
      });

  static void dispose() => instance.dispose();
}
