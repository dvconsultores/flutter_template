import 'package:flutter_detextre4/utils/local_data/secure_storage.dart';

class FetchConfig {
  // * base url
  /// Base url from app domain.
  static const String baseUrl = 'domain/api/v1';

  /// Base url from app domain where files are storaged.
  static const String fileBaseUrl = 'domain/api/v1';

  // * headers without auth
  /// A map that contains header used to application/json http request.
  static Map<String, String> headersWithoutAuth = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  // * headers with auth
  /// A map that contains header used to application/json http request and
  /// authorization token.
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
