import 'dart:async';

import 'package:app_loader/app_loader.dart';
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
      if (animationController.isCompleted) loader.open();
      final isLogged = await initializationService.initialFetch.init(context);
      if (!mounted) return;

      loader.close();

      await animationCompleter.future;

      routerConfig.router.go(
        isLogged ? (widget.redirectPath ?? "/home") : "/login",
      );
    } catch (error) {
      await animationCompleter.future;

      initializationService.initialFetch.initialFetchStatus.value =
          InitialFetchStatus.error;

      loader.close();
      if (!mounted) return;

      Modal.showSystemAlert(
        context,
        contentText: error.toString(),
        textConfirmBtn: "Okay",
      );
    }
  }

  @override
  void initState() {
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
