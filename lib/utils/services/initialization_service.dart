import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/utils/services/local_notifications.dart';
import 'package:flutter_detextre4/utils/services/reminder_service.dart';

enum InitialFetchStatus {
  fetching,
  error,
  maintenance,
  done;
}

class InitializationService {
  InitializationService();

  late final initialFetch = _InitialFetch();

  late final inAppService = _InitializationInAppService();
}

class _InitialFetch {
  _InitialFetch();

  final initialFetchStatus = ValueNotifier(InitialFetchStatus.fetching);

  Future<bool> init(BuildContext context) async {
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

        // initialize notifications
        if (context.mounted) {
          await LocalNotifications.initializeNotifications(context);
        }
      }

      initialFetchStatus.value = InitialFetchStatus.done;

      return isLogged;
    } catch (error) {
      if (error.catchErrorStatusCode() == "401") {
        SecureStorage.delete(SecureCollection.tokenAuth);
      }

      throw error.catchErrorMessage(
        fallback:
            "An error occurred while running the application 😞, please contact our support team for more information",
      );
    }
  }
}

class _InitializationInAppService {
  _InitializationInAppService();

  bool inAppStarted = false;
  bool initializedInAppServices = false;
  bool initializedPostInAppServices = false;

  Future<void> initBothInAppServices(BuildContext context) async {
    await Future.wait([
      initInAppServices(context),
      Future.microtask(() => SchedulerBinding.instance
          .addPostFrameCallback((_) => initPostInAppServices(context))),
    ]);

    _setInAppStarted();
  }

  Future<void> initInAppServices(BuildContext context) async {
    initializedInAppServices = true;
    _setInAppStarted();
  }

  Future<void> initPostInAppServices(BuildContext context) async {
    ReminderService.init();

    initializedPostInAppServices = true;
    _setInAppStarted();
  }

  void _setInAppStarted() {
    inAppStarted = initializedInAppServices && initializedPostInAppServices;
  }
}
