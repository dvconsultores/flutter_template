import 'package:flutter_detextre4/utils/services/local_data/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin FetchConfig {
  // * base url
  /// Base url from app domain.
  static final String baseUrl =
      dotenv.get("BASE_URL", fallback: "domain/api/v1");

  /// Base url from app domain where files are storaged.
  static final String fileBaseUrl =
      dotenv.get("FILE_BASE_URL", fallback: "domain/api/v1");

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
