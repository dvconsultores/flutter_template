import 'package:flutter/material.dart';
import 'package:flutter_detextre4/repositories/auth_api.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class SessionTimeoutConfig {
  SessionTimeoutConfig(this.context);
  final BuildContext context;

  late final authApi = AuthApi(context);

  final instance = SessionConfig(
      // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
      // invalidateSessionForUserInactivity: const Duration(seconds: 30),
      );

  void listen() => instance.stream.listen((timeoutEvent) {
        if (!routerConfig.router.requireAuth) return;

        switch (timeoutEvent) {
          case SessionTimeoutState.userInactivityTimeout:
            // * handle user  inactive timeout
            authApi.signOut();
            break;

          case SessionTimeoutState.appFocusTimeout:
            // * handle user  app lost focus timeout
            authApi.signOut();
            break;
        }
      });

  void dispose() => instance.dispose();
}
