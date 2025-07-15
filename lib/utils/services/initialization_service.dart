import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/utils/services/local_notifications.dart';
import 'package:flutter_detextre4/utils/services/reminder_service.dart';
import 'package:flutter_detextre4/utils/services/uni_links_service.dart';

enum InitialFetchStatus {
  stopped,
  fetching,
  error,
  maintenance,
  unilinkDone,
  done;
}

class InitializationService {
  InitializationService();

  late final initialFetch = _InitialFetch();

  late final inAppService = _InitializationInAppService();
}

class _InitialFetch {
  _InitialFetch();

  final initialFetchStatus = ValueNotifier(InitialFetchStatus.stopped);

  Future<void> init(BuildContext context) async {
    try {
      // initialize DioService
      DioService.init(context);

      // review app version
      final updatePressed = await checkVersion(context);
      if (updatePressed) {
        initialFetchStatus.value = InitialFetchStatus.error;
        return;
      }

      if (!context.mounted) return;

      initialFetchStatus.value = InitialFetchStatus.fetching;

      final [
        tokenAuth,
      ] = await Future.wait([
        SecureStorage.read<String?>(SecureCollection.tokenAuth),
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

      // initialize deep links
      if (context.mounted) {
        await UniLinksService(context, initialFetchStatus: initialFetchStatus)
            .init();
      }

      if (initialFetchStatus.value == InitialFetchStatus.unilinkDone) return;

      initialFetchStatus.value = InitialFetchStatus.done;
    } catch (error) {
      if (error.catchErrorStatusCode() == "401") {
        SecureStorage.delete(SecureCollection.tokenAuth);
      }

      throw error.catchErrorMessage(
        fallback:
            "Ha ocurrido un error al correr la aplicación 😞, porfavor contacta con nuestro equipo de soporte para más información",
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
    await ReminderService.init(context);

    initializedPostInAppServices = true;
    _setInAppStarted();
  }

  void _setInAppStarted() {
    inAppStarted = initializedInAppServices && initializedPostInAppServices;
  }
}
