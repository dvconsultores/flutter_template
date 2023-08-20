import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';

/// Global loader used for asyncronous process.
/// if should be used on initState, need to call with
/// [SchedulerBinding.instance.addPostFrameCallback((_) {})] method.
class AppLoader<T> {
  AppLoader([this.context]);
  final BuildContext? context;

  static AppLoader<T> of<T>(BuildContext context) => AppLoader<T>(context);

  void close() => Navigator.pop(context ?? globalNavigatorKey.currentContext!);

  Future<T?> init([Future<T> Function()? callback]) async => await showDialog(
        context: context ?? globalNavigatorKey.currentContext!,
        builder: (context) => _AppLoader<T>(callback),
      );
}

class _AppLoader<T> extends StatelessWidget {
  const _AppLoader(this.callback);
  final Future<T?> Function()? callback;

  @override
  Widget build(BuildContext context) {
    Future<void> onCallback() async => callback!()
        .then((value) => Navigator.pop(context, value))
        .catchError((_) => Navigator.pop(context));
    if (callback != null) onCallback();

    return WillPopCustom(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    color: ThemeApp.colors(context).secondary,
                    backgroundColor: ThemeApp.colors(context).primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Processing...",
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
              ],
            ),
          )),
    );
  }
}
