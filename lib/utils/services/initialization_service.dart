// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/utils/services/reminder_service.dart';

enum InitialFetchStatus {
  fetching,
  error,
  done;
}

class InitializationService {
  InitializationService(this.context, this.notifyListeners);
  final BuildContext context;
  final VoidCallback notifyListeners;

  late final initialFetch = _InitialFetch(context, notifyListeners);

  late final inAppService = _InitializationInAppService(context);
}

class _InitialFetch {
  _InitialFetch(this.context, this.notifyListeners);
  final BuildContext context;
  final VoidCallback notifyListeners;

  final initialFetchStatus = ValueNotifier(InitialFetchStatus.fetching);

  Future<bool> init() async {
    initialFetchStatus.value = InitialFetchStatus.fetching;

    try {
      // initialize DioService
      DioService.init(context);

      final [
        tokenAuth,
        // _,
      ] = await Future.wait([
        SecureStorage.read<String?>(SecureCollection.tokenAuth),

        // initialize deep links
        // UniLinksService.init(context),
      ]);
      final isLogged = tokenAuth != null;

      if (isLogged) {
        // get user data
        await Future.delayed(Durations.short1);
      }

      initialFetchStatus.value = InitialFetchStatus.done;

      return isLogged;
    } catch (error) {
      initialFetchStatus.value = InitialFetchStatus.error;

      if (error.catchErrorStatusCode() == "401") {
        SecureStorage.delete(SecureCollection.tokenAuth);
      }

      debugPrint("MaterialhandlerError: $error ⭕");

      throw error.catchErrorMessage(
        fallback:
            "Ha ocurrido un error al correr la aplicación 😞, porfavor contacta con nuestro equipo de soporte para más información",
      );
    }
  }
}

class _InitializationInAppService {
  _InitializationInAppService(this.context);
  final BuildContext context;

  bool inAppStarted = false;

  void initBothInAppServices() {
    initInAppServices();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => initPostInAppServices());
  }

  bool initializedInAppServices = false;
  Future<void> initInAppServices() async {
    initializedInAppServices = true;
    _setInAppStarted();
  }

  bool initializedPostInAppServices = false;
  Future<void> initPostInAppServices() async {
    ReminderService.init();

    initializedPostInAppServices = true;
    _setInAppStarted();
  }

  void _setInAppStarted() {
    if (!initializedInAppServices || !initializedPostInAppServices) return;

    inAppStarted = true;
  }
}
