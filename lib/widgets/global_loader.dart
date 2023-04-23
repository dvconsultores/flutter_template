import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/widgets/will_pop_custom.dart';
import 'package:http/http.dart' as http;

class GlobalLoader {
  static void close() => Navigator.pop(globalNavigatorKey.currentContext!);

  static Future<http.Response> init({Future<http.Response>? request}) async =>
      await showDialog(
        context: globalNavigatorKey.currentContext!,
        builder: (context) => _GlobalLoader(request),
      ) ??
      http.Response.bytes([], 200);
}

class _GlobalLoader extends StatelessWidget {
  const _GlobalLoader(this.request);
  final Future<http.Response>? request;

  @override
  Widget build(BuildContext context) {
    Future<void> init() async =>
        request.isExist ? Navigator.pop(context, await request) : null;
    init();

    return WillPopCustom(
      onWillPop: () => Future.value(false),
      child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
