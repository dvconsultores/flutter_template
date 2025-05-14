import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/services/local_data/env_service.dart';
import 'package:uni_links/uni_links.dart';

enum UniLinksKey {
  testKey("true");

  const UniLinksKey(this.defaultParameter);
  final String defaultParameter;
}

enum UniLinksTypeHandler {
  initialUrl,
  streamUrl,
  installReferrer;
}

class UniLinksService {
  static StreamSubscription? _sub;

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  /// Initialization method to [UniLinksService]. Just run once.
  static Future<void> init(
    BuildContext? context, {
    checkActualVersion = false,
  }) async {
    if (kIsWeb || context == null) return;

    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();

      if (context.mounted) {
        await uniLinkHandler(context, uri, UniLinksTypeHandler.initialUrl);
      }
    } catch (error) {
      if (kDebugMode) print("UniLinks getInitialUri error: $error ⭕");
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    _sub = uriLinkStream.listen((value) async {
      if (!context.mounted) return;

      await uniLinkHandler(context, value, UniLinksTypeHandler.streamUrl);
    }, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error ⭕');
    });
  }

  /// handler to manage uri redirect
  static Future<bool> uniLinkHandler(
    BuildContext context,
    Uri? uri,
    UniLinksTypeHandler uniLinksTypeHandler,
  ) async {
    if (uri == null || uri.queryParameters.isEmpty) return false;
    final params = uri.queryParameters;

    for (final key in UniLinksKey.values) {
      final paramValue = params[key.name];
      if (paramValue.hasNotValue) continue;

      await _uniLinksActions(context, key, paramValue!, uniLinksTypeHandler);
      return true;
    }

    return false;
  }

  /// handler to manage uri redirect
  static Future<void> _uniLinksActions(
    BuildContext context,
    UniLinksKey key,
    String value,
    UniLinksTypeHandler uniLinksTypeHandler,
  ) async {
    final completer = Completer();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      switch (key) {
        case UniLinksKey.testKey:
          if (kDebugMode) print("test key");
          break;
      }

      completer.complete();
    });

    await completer.future;
  }

  static String getDeepLink(UniLinksKey key, [dynamic value]) =>
      '${env.deepLinkBaseUrl}/?${key.name}=${value ?? key.defaultParameter}';
}
