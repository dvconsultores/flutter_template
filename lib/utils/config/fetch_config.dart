import 'package:flutter_detextre4/utils/local_data/secure_storage.dart';

class FetchConfig {
  // * base url
  static const String baseUrl = 'domain/api/v1';

  // * headers without auth
  static Map<String, String> headersWithoutAuth = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  // * headers with auth
  static Future<Map<String, String>> headersWithAuth(
      {String? customToken}) async {
    final String? tokenAuth = customToken ??
        await SecureStorage.read(SecureStorageCollection.tokenAuth);

    if (tokenAuth == null) {
      throw Error.safeToString("tokenAuth is missing!");
    }

    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $tokenAuth',
    };
  }
}
