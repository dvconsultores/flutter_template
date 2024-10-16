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

  void dispose() {
    disposed = true;
    if (!loading) return;

    clearSnackbars();
    Navigator.pop(ContextUtility.context!);
    loading = false;
  }

  void stop<T>([T? value]) {
    if (disposed || !loading) return;
    loading = false;
    _controller.sink.add(false);
  }

  void close<T>([T? value]) {
    if (disposed || !loading) return;

    clearSnackbars();
    Navigator.pop(ContextUtility.context!, value);
    loading = false;
    _controller.sink.add(false);
  }

  Future<T?> start<T>({Future<T> Function()? future}) async {
    if (disposed || loading) return null;
    loading = true;
    _controller.sink.add(true);

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
    void Function(CancelToken? cancelToken)? onUserWillPop,
    CancelToken? cancelToken,
  }) async {
    if (disposed || loading) return null;
    loading = true;
    _controller.sink.add(true);

    return await showDialog<T>(
      context: ContextUtility.context!,
      builder: (context) => _AppLoader<T>(
        message: message,
        future: future,
        disposeLoader: dispose,
        closeLoader: close,
        onUserWillPop: onUserWillPop,
        cancelToken: cancelToken,
        child: child,
      ),
    );
  }
}

class _AppLoader<T> extends StatefulWidget {
  const _AppLoader({
    required this.message,
    this.future,
    required this.disposeLoader,
    required this.closeLoader,
    this.onUserWillPop,
    this.cancelToken,
    this.child,
  }) : super(key: const Key('loader_widget'));
  final String message;
  final Future<T?> Function()? future;
  final VoidCallback disposeLoader;
  final void Function([T? value]) closeLoader;
  final void Function(CancelToken? cancelToken)? onUserWillPop;
  final CancelToken? cancelToken;
  final Widget? child;

  @override
  State<_AppLoader<T>> createState() => _AppLoaderState<T>();
}

class _AppLoaderState<T> extends State<_AppLoader<T>> {
  @override
  void initState() {
    if (widget.future != null) {
      widget.future!()
          .then((value) => widget.closeLoader(value))
          .catchError((_) => widget.closeLoader());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopCustom(
      key: widget.key,
      onWillPop: () async {
        if (widget.onUserWillPop != null) {
          widget.closeLoader();
          widget.cancelToken?.cancel();
          widget.onUserWillPop!(widget.cancelToken);
        }
        return false;
      },
      child: widget.child ??
          Scaffold(
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
                      widget.message,
                      style: theme.primaryTextTheme.titleLarge,
                    ),
                  ],
                ),
              )),
    );
  }
}
