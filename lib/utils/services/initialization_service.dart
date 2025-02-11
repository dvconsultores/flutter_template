import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/services/reminder_service.dart';

class InitializationService {
  final BuildContext context;
  InitializationService(this.context) {
    initServices();
    SchedulerBinding.instance.addPostFrameCallback((_) => initPostServices());
  }

  final mainProvider = MainProvider.read();

  bool userActivityExists = false;

  bool initializedServices = false;

  Future<void> initServices() async {
    initializedServices = true;
    _setAppStarted();
  }

  bool initializedPostServices = false;
  Future<void> initPostServices() async {
    ReminderService.init();

    initializedPostServices = true;
    _setAppStarted();
  }

  void _setAppStarted() {
    if (!initializedServices || !initializedPostServices) return;

    mainProvider.setAppStarted;
  }
}
