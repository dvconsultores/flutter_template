import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';

/// Global loader used for asyncronous process.
/// if should be used on initState, need to call with
/// [SchedulerBinding.instance.addPostFrameCallback((_) {})] method.
class AppLoader {
  AppLoader({this.child});
  final Widget? child;

  bool loading = false;
  bool disposed = false;

  final _controller = StreamController<bool>();
  Stream<bool> get stream => _controller.stream;

  var cancelToken = CancelToken();

  void dispose() {
    disposed = true;
    if (!loading) return;

    clearSnackbars();
    Navigator.pop(ContextUtility.context!);
    loading = false;
  }

  void stop<T>({bool cancelCurrentToken = false}) {
    if (disposed || !loading) return;

    if (cancelCurrentToken) cancelToken.cancel();

    loading = false;
    _controller.sink.add(false);
  }

  void close<T>({T? value, bool cancelCurrentToken = false}) {
    if (disposed || !loading) return;

    if (cancelCurrentToken) cancelToken.cancel();

    clearSnackbars();
    Navigator.pop(ContextUtility.context!, value);
    loading = false;
    _controller.sink.add(false);
  }

  Future<T?> start<T>({Future<T> Function()? future}) async {
    if (disposed || loading) return null;
    loading = true;
    _controller.sink.add(true);
    cancelToken = CancelToken();

    if (future != null) {
      return await future().whenComplete(() {
        loading = false;
        _controller.sink.add(false);
      });
    }

    return null;
  }

  Future<T?> open<T>({
    String message = "Processing...",
    Future<T> Function()? future,
    void Function(CancelToken cancelToken)? onUserWillPop,
    CancelToken? customCancelToken,
  }) async {
    if (disposed || loading) return null;
    loading = true;
    _controller.sink.add(true);
    cancelToken = CancelToken();

    showDialog(
        context: ContextUtility.context!,
        builder: (context) => WillPopCustom(
              onWillPop: () async {
                if (onUserWillPop != null) {
                  close();
                  customCancelToken?.cancel();
                  cancelToken.cancel();
                  onUserWillPop(customCancelToken ?? cancelToken);
                }
                return false;
              },
              child: child ?? _AppLoader<T>(message: message),
            ));

    if (future != null) {
      try {
        final value = await future();

        close(value: value);
        return value;
      } catch (error) {
        close();
        rethrow;
      }
    }

    return null;
  }
}

class _AppLoader<T> extends StatelessWidget {
  const _AppLoader({required this.message})
      : super(key: const Key('loader_widget'));
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                  color: theme.colorScheme.secondary,
                  backgroundColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.primaryTextTheme.titleLarge,
              ),
            ],
          ),
        ));
  }
}
