import 'dart:async';

import 'package:app_loader/app_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/routes/splash_route/splash_screen.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/services/initialization_service.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';

class SplashRoute extends StatefulWidget {
  const SplashRoute({super.key, this.redirectPath});
  final String? redirectPath;

  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute>
    with SingleTickerProviderStateMixin {
  final initializationService = MainProvider.read().initializationService;

  late final animationController = AnimationController(
    lowerBound: 0.0,
    upperBound: 1.0,
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  late final loader = AppLoader(context);

  final animationCompleter = Completer<void>();

  /// initialize services using [InitializationService] context
  Future<void> handleFetchData() async {
    try {
      await initializationService.initialFetch.init(context);
      if (!mounted) return;

      await animationCompleter.future;

      switch (initializationService.initialFetch.initialFetchStatus.value) {
        case InitialFetchStatus.done:
          {
            if (mounted) Navigator.popUntil(context, (route) => route.isFirst);

            if (widget.redirectPath == "/auth") {
              return routerConfig.router.goNamed(
                "login",
                queryParameters: {if (!kIsWeb) "showBiometric": "true"},
              );
            }

            routerConfig.router.go(widget.redirectPath ?? "/home");
          }
          break;

        case InitialFetchStatus.maintenance:
          routerConfig.router.goNamed("maintenance");
          break;

        default:
          break;
      }
    } catch (error) {
      await animationCompleter.future;

      initializationService.initialFetch.initialFetchStatus.value =
          InitialFetchStatus.error;
      if (!mounted) return;

      Modal.showSystemAlert(
        context,
        contentText: error.toString(),
        textConfirmBtn: "Okay",
      );
    }
  }

  void onListenInitialFetchStatus() {
    switch (initializationService.initialFetch.initialFetchStatus.value) {
      case InitialFetchStatus.fetching:
        loader.open();
        break;

      case InitialFetchStatus():
        loader.close();
        break;
    }
  }

  @override
  void initState() {
    initializationService.initialFetch.initialFetchStatus
        .addListener(onListenInitialFetchStatus);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
          ThemeApp.of(context).systemUiOverlayStyle.copyWith(
                systemNavigationBarColor: const Color.fromARGB(255, 4, 47, 82),
              ));

      animationController.forward().then((_) {
        if (initializationService.initialFetch.initialFetchStatus.value ==
            InitialFetchStatus.fetching) {
          loader.open();
        }

        animationCompleter.complete();
      });

      handleFetchData();
    });
    super.initState();
  }

  @override
  void dispose() {
    initializationService.initialFetch.initialFetchStatus
        .removeListener(onListenInitialFetchStatus);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      animationController: animationController,
      handleFetchData: handleFetchData,
      initialFetchStatus: initializationService.initialFetch.initialFetchStatus,
    );
  }
}
