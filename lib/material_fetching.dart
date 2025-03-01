import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
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
  final statusNotifier =
      ValueNotifier<(bool animationIsDone, bool? fetchIsDone)>((false, false));

  late final AnimationController animationController = AnimationController(
    lowerBound: 0.0,
    upperBound: 1.0,
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  final loader = AppLoader();

  bool isLogged = false;

  void onFinishAnimation(_) {
    if (!mounted) return;

    final (_, fetchIsDone) = statusNotifier.value;
    statusNotifier.value = (true, fetchIsDone);

    if (fetchIsDone == false) loader.open();
    updateState(() {});
  }

  Future<void> getData({bool restart = false}) async {
    widget.provider.setReturnDioAuthError = true;

    if (restart) {
      loader.open();
      updateState(() {});
    } else {
      animationController.forward().then(onFinishAnimation);
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

      loader.close();

      final (animationIsDone, fetchIsDone) = statusNotifier.value;
      statusNotifier.value = (animationIsDone, true);
    } catch (error) {
      final errorMessage = handlerError(error);

      if (error is DioException &&
          error.type == DioExceptionType.connectionError) {
        await Modal.showSystemAlert(
          ContextUtility.context!,
          contentText: errorMessage,
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
      MainProvider.read().setPreventModal = true;

      handlerNextMaterial();
      routerConfig.router.goNamed("home");
    } catch (error) {
      final errorMessage = handlerError(error);

      showSnackbar(errorMessage, type: SnackbarType.error);
    } finally {
      MainProvider.read().setPreventModal = false;
    }
  }

  void updateState(void Function() fn) {
    if (!loader.disposed) setState(fn);
  }

  void handlerNextMaterial() {
    updateState(loader.dispose);
  }

  String handlerError(Object error) {
    loader.stop();

    final (animationIsDone, _) = statusNotifier.value;
    statusNotifier.value = (animationIsDone, null);

    if (error.catchErrorStatusCode() == "401") {
      SecureStorage.delete(SecureCollection.tokenAuth);
    }

    final errorMessage = error.catchErrorMessage(
      fallback:
          "An error has occurred while running the app 😞, please contact our support team for more information",
    );
    debugPrint("MaterialhandlerError: $errorMessage ⭕");

    return errorMessage;
  }

  void onListenStatusNotifier() {
    updateState(() {});

    final (animationIsDone, fetchIsDone) = statusNotifier.value;
    if (animationIsDone && fetchIsDone == true && mounted) {
      goTo();
    }
  }

  @override
  void initState() {
    statusNotifier.addListener(onListenStatusNotifier);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  @override
  void dispose() {
    statusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // render original MaterialApp
    if (loader.disposed) {
      return Material(
        color: ThemeApp.lightTheme.colorScheme.tertiary,
        child: widget.child,
      );
    }

    // render splash page MaterialApp
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
