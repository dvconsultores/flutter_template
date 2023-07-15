import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

    if (tokenAuth == null) throw "tokenAuth is missing!";

    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $tokenAuth',
    };
  }

  /// ⭐ Custom ⭐
  /// Sends an HTTP GET request with the given headers to the given URL.
  ///
  /// This automatically initializes a new [Client] and closes that client once
  /// the request is complete. If you're planning on making multiple requests to
  /// the same server, you should use a single [Client] for all of those requests.
  ///
  /// For more fine-grained control over the request, use [Request] instead.
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    List<int> acceptedStatus = const [200, 201, 204],
    String fallback = "Error",
    String connectionFallback = "Connection Failed",
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    try {
      final response = await http.get(url, headers: headers);

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(fallback: fallback);
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on SocketException catch (error) {
      dev.log("$error ⭕");
      throw connectionFallback;
    }
  }

  /// ⭐ Custom ⭐
  /// Sends an HTTP POST request with the given headers and body to the given URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>] or
  /// a [Map<String, String>]. If it's a String, it's encoded using [encoding] and
  /// used as the body of the request. The content-type of the request will
  /// default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// For more fine-grained control over the request, use [Request] or
  /// [StreamedRequest] instead.
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    List<int> acceptedStatus = const [200, 201, 204],
    String fallback = "Error",
    String connectionFallback = "Connection Failed",
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    if (showRequest) dev.log("$body ⭐");

    try {
      final response = await http.post(url,
          headers: headers, body: body, encoding: encoding);

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(fallback: fallback);
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on SocketException catch (error) {
      dev.log("$error ⭕");
      throw connectionFallback;
    }
  }
}
