import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni_links/uni_links.dart';

enum UniLinksKey {
  testKey(null);

  const UniLinksKey(this.value);
  final String? value;
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
  static Future<void> init({checkActualVersion = false}) async {
    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();
      uniLinkHandler(uri, UniLinksTypeHandler.initialUrl);
    } catch (error) {
      if (kDebugMode) print("UniLinks getInitialUri error: $error ⭕");
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    _sub = uriLinkStream
        .listen((value) => uniLinkHandler(value, UniLinksTypeHandler.streamUrl),
            onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error ⭕');
    });
  }

  /// handler to manage uri redirect
  static bool uniLinkHandler(
    Uri? uri,
    UniLinksTypeHandler uniLinksTypeHandler,
  ) {
    if (uri == null || uri.queryParameters.isEmpty) return false;
    final params = uri.queryParameters;

    for (final key in UniLinksKey.values) {
      final paramValue = params[key.name];
      if (paramValue == null) continue;

      _uniLinksActions(key, paramValue, uniLinksTypeHandler);
      return true;
    }

    return false;
  }

  /// handler to manage uri redirect
  static void _uniLinksActions(
    UniLinksKey key,
    String value,
    UniLinksTypeHandler uniLinksTypeHandler,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      switch (key) {
        case UniLinksKey.testKey:
          if (kDebugMode) print("test key");
          break;
      }
    });
  }
}
