import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

enum UniLinksKey {
  testKey(null);

  const UniLinksKey(this.value);
  final String? value;
}

class UniLinksService {
  static StreamSubscription? _sub;

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  static Future<void> init({checkActualVersion = false}) async {
    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();
      _uniLinkHandler(uri);
    } on PlatformException {
      if (kDebugMode) {
        print("(PlatformException) Failed to receive initial uri.");
      }
    } on FormatException catch (error) {
      if (kDebugMode) {
        print(
            "(FormatException) Malformed Initial URI received. Error: $error");
      }
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    _sub = uriLinkStream.listen(_uniLinkHandler, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error');
    });
  }

  static Future<void> _uniLinkHandler(Uri? uri) async {
    if (uri == null || uri.queryParameters.isEmpty) return;
    final params = uri.queryParameters;

    for (final key in UniLinksKey.values) {
      final paramValue = params[key.name];
      if (paramValue == null) return;

      uniLinksActions(key, paramValue);
    }
  }

  static void uniLinksActions(UniLinksKey key, String value) {
    switch (key) {
      case UniLinksKey.testKey:
        if (kDebugMode) print("test key");
        break;
    }
  }
}
