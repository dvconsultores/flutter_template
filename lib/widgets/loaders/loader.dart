import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';

/// Global loader used for asyncronous process.
/// if should be used on initState, need to call with
/// [SchedulerBinding.instance.addPostFrameCallback((_) {})] method.
class AppLoader<T> {
  AppLoader([this.context]);
  final BuildContext? context;

  bool loading = false;
  bool disposed = false;

  static AppLoader<T> of<T>(BuildContext context) => AppLoader<T>(context);

  void dispose() {
    disposed = true;
    if (!loading) return;

    clearSnackbars();
    Navigator.pop(context ?? ContextUtility.context!);
    loading = false;
  }

  void close() {
    if (!loading) return;

    clearSnackbars();
    Navigator.pop(context ?? ContextUtility.context!);
    loading = false;
  }

  Future<T?> init({
    String message = "Processing...",
    Future<T> Function()? callback,
  }) async {
    if (disposed) return Future.value();
    loading = true;

    return await showDialog(
      context: context ?? ContextUtility.context!,
      builder: (context) => _AppLoader<T>(message, callback),
    );
  }
}

class _AppLoader<T> extends StatelessWidget {
  const _AppLoader(this.message, this.callback)
      : super(key: const Key('loader_widget'));
  final String message;
  final Future<T?> Function()? callback;

  @override
  Widget build(BuildContext context) {
    Future<void> onCallback() async => callback!()
        .whenComplete(() => clearSnackbars())
        .then((value) => Navigator.pop(context, value))
        .catchError((_) => Navigator.pop(context));
    if (callback != null) onCallback();

    return WillPopCustom(
      key: key,
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
                  message,
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
              ],
            ),
          )),
    );
  }
}
