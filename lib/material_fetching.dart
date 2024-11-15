import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/utils/services/uni_links_service.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';
import 'package:flutter_detextre4/widgets/loaders/loader.dart';
import 'package:flutter_detextre4/widgets/loaders/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    context.read<MainProvider>().setReturnDioAuthError = true;

    if (restart) {
      loader.open();
      if (mounted) setState(() {});
    } else {
      animationController.forward().then((value) {
        if (!mounted) return;

        notifier.value = (true, notifier.value.$2);

        if (fetchingData) loader.open();
        setState(() {});
      });
    }

    try {
      final [tokenAuth as String?, _] = await Future.wait([
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

    setState(loader.dispose);
    if (kIsWeb) return;
    context.goNamed("login");
  }

  Future<void> goToHome() async {
    context.goNamed("home");
  }

  String handlerError(Object error) {
    final errorMessage =
        error is DioException ? error.catchErrorMessage() : error.toString();
    debugPrint("$errorMessage ⭕");
    fetchingData = false;
    loader.close();
    if (mounted) setState(() {});

    return errorMessage;
  }

  @override
  void initState() {
    notifier.addListener(() {
      final (a, b) = notifier.value;

      if (a && b && mounted) {
        goTo().then((value) => notifier.dispose());
      }
    });

    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loader.disposed) return widget.child;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeApp.lightTheme,
      darkTheme: ThemeApp.darkTheme,
      themeMode: widget.provider.appTheme, // * Theme switch
      navigatorKey: ContextUtility.navigatorKey,
      home: SplashPage(animationController: animationController),
    );
  }
}
