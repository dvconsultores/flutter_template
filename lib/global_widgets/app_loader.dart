import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:http/http.dart' as http;

class AppLoader {
  static void close() => Navigator.pop(globalNavigatorKey.currentContext!);

  static Future<http.Response> init({
    Future<http.Response>? request,
    http.MultipartRequest? multipartRequest,
  }) async =>
      await showDialog(
        context: globalNavigatorKey.currentContext!,
        builder: (context) => _AppLoader(request, multipartRequest),
      ) ??
      http.Response.bytes([], 200);
}

class _AppLoader extends StatelessWidget {
  const _AppLoader(this.request, this.multipartRequest);
  final Future<http.Response>? request;
  final http.MultipartRequest? multipartRequest;

  @override
  Widget build(BuildContext context) {
    Future<void> init() async => Navigator.pop(
        context,
        request != null
            ? await request
            : await http.Response.fromStream(await multipartRequest!.send()));
    if (request != null || multipartRequest != null) init();

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