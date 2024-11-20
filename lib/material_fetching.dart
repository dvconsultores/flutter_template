import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/utils/services/uni_links_service.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';
import 'package:flutter_detextre4/widgets/loaders/loader.dart';
import 'package:flutter_detextre4/widgets/loaders/splash_page.dart';

class MaterialFetching extends StatefulWidget {
  const MaterialFetching({
    super.key,
    required this.child,
    required this.provider,
  });
  final MaterialApp child;
  final MainProvider provider;

  @override
  State<MaterialFetching> createState() => _MaterialFetchingState();
}

class _MaterialFetchingState extends State<MaterialFetching>
    with SingleTickerProviderStateMixin {
  final notifier = ValueNotifier<(bool, bool)>((false, false));

  late final AnimationController animationController = AnimationController(
    lowerBound: 0.0,
    upperBound: 1.0,
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  final loader = AppLoader();
  bool fetchingData = true;

  bool isLogged = false;

  Future<void> getData({bool restart = false}) async {
    widget.provider.setReturnDioAuthError = true;

    if (restart) {
      loader.open();
      updateState(() {});
    } else {
      animationController.forward().then((value) {
        if (!mounted) return;

        notifier.value = (true, notifier.value.$2);

        if (fetchingData) loader.open();
        updateState(() {});
      });
    }

    try {
      final [
        tokenAuth as String?,
        _,
      ] = await Future.wait([
        SecureStorage.read<String?>(SecureCollection.tokenAuth),

        // initialize deep links
        UniLinksService.init(),
      ]);
      isLogged = tokenAuth != null;

      fetchingData = false;
      loader.close();

      notifier.value = (notifier.value.$1, true);
    } catch (error) {
      final errorMessage = handlerError(error);

      if (error is DioException &&
          error.type == DioExceptionType.connectionError) {
        await Modal.showSystemAlert(
          ContextUtility.context!,
          titleText: errorMessage,
          textConfirmBtn: "Okay",
        );
        return;
      }

      showSnackbar(errorMessage, type: SnackbarType.error);
    }
  }

  Future<void> goTo() async {
    if (isLogged) return await goToHome();

    handlerNextMaterial();
    if (kIsWeb) return;
    routerConfig.router.goNamed("login");
  }

  Future<void> goToHome() async {
    try {
      routerConfig.router.goNamed("home");
    } catch (error) {
      final errorMessage = handlerError(error);

      showSnackbar(
        "An error has occurred while running the app 😞, please contact our support team for more information",
        type: SnackbarType.error,
      );

      throw errorMessage;
    }
  }

  void updateState(void Function() fn) {
    if (!loader.disposed) setState(fn);
  }

  void handlerNextMaterial() {
    updateState(loader.dispose);
  }

  String handlerError(Object error) {
    notifier.value = (notifier.value.$1, false);

    final errorMessage =
        error is DioException ? error.catchErrorMessage() : error.toString();
    debugPrint("MaterialhandlerError: $errorMessage ⭕");
    fetchingData = false;

    if (error is DioException && error.response?.statusCode == 401) {
      notifier.dispose();
      loader.dispose();
    } else {
      loader.close();
    }

    updateState(() {});

    return errorMessage;
  }

  @override
  void initState() {
    notifier.addListener(() {
      final (a, b) = notifier.value;

      if (a && b && mounted) {
        goTo().then((_) => notifier.dispose());
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loader.disposed) {
      return Material(
        color: ThemeApp.lightTheme.colorScheme.tertiary,
        child: widget.child,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppName.capitalize.value,
      theme: ThemeApp.lightTheme,
      darkTheme: ThemeApp.darkTheme,
      themeMode: widget.provider.appTheme, // * Theme switch
      navigatorKey: !loader.disposed ? ContextUtility.navigatorKey : null,
      home: SplashPage(animationController: animationController),
    );
  }
}
