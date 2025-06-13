import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/services/initialization_service.dart';
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
  webUrl,
  installReferrer;
}

class UniLinksService {
  UniLinksService(
    this.context, {
    required this.initialFetchStatus,
  });
  final BuildContext context;
  final ValueNotifier<InitialFetchStatus> initialFetchStatus;

  StreamSubscription? _sub;

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  /// Initialization method to [UniLinksService]. Just run once.
  Future<UniLinksService?> init({checkActualVersion = false}) async {
    if (kIsWeb) {
      uniLinkHandler(
        routerConfig.router.state.uri,
        UniLinksTypeHandler.webUrl,
      );
      return this;
    }

    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();

      await uniLinkHandler(uri, UniLinksTypeHandler.initialUrl);
    } catch (error) {
      if (kDebugMode) print("UniLinks getInitialUri error: $error ⭕");
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    _sub = uriLinkStream.listen((value) async {
      await uniLinkHandler(value, UniLinksTypeHandler.streamUrl);
    }, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error ⭕');
    });

    return this;
  }

  /// handler to manage uri redirect
  Future<bool> uniLinkHandler(
    Uri? uri,
    UniLinksTypeHandler uniLinksTypeHandler,
  ) async {
    if (uri == null || uri.queryParameters.isEmpty) return false;
    final params = uri.queryParameters;

    for (final key in UniLinksKey.values) {
      final paramValue = params[key.name];
      if (paramValue.hasNotValue) continue;

      await _uniLinksActions(key, paramValue!, uniLinksTypeHandler);
      return true;
    }

    return false;
  }

  /// handler to manage uri redirect
  Future<void> _uniLinksActions(
    UniLinksKey key,
    String value,
    UniLinksTypeHandler uniLinksTypeHandler,
  ) async {
    final completer = Completer();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      switch (key) {
        case UniLinksKey.testKey:
          {
            if (kDebugMode) print("test key");
            initialFetchStatus.value = InitialFetchStatus.unilinkDone;
          }

          break;
      }

      completer.complete();
    });

    await completer.future;
  }

  static String getDeepLink(UniLinksKey key, [dynamic value]) =>
      '${env.deepLinkBaseUrl}/?${key.name}=${value ?? key.defaultParameter}';
}
