import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_router.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

mixin SessionTimeoutConfig {
  static final instance = SessionConfig(
      // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
      // invalidateSessionForUserInactivity: const Duration(seconds: 30),
      );

  static void listen(BuildContext context) =>
      instance.stream.listen((timeoutEvent) {
        final userBloc = BlocProvider.of<UserBloc>(context);

        //? Exception routes
        if (locationExceptions.contains(routerConfig.location)) return;

        switch (timeoutEvent) {
          case SessionTimeoutState.userInactivityTimeout:
            // * handle user  inactive timeout
            userBloc.closeSession;
            break;

          case SessionTimeoutState.appFocusTimeout:
            // * handle user  app lost focus timeout
            userBloc.closeSession;
            break;
        }
      });

  static void dispose() => instance.dispose();
}
