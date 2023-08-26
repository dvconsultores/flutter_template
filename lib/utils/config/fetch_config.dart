import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io' as io;

import 'package:flutter_detextre4/models/files_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter_detextre4/utils/general/functions.dart' as fun;
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FetchConfig {
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
    bool showResponse = false,
    bool showSnackbar = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    try {
      final response = await http.get(url, headers: headers);

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(
          fallback: fallback,
          showSnackbar: showSnackbar,
        );
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on io.SocketException catch (error) {
      dev.log("$error ⭕");
      if (showSnackbar) {
        fun.showSnackbar(error.toString(), type: fun.ColorSnackbarState.error);
      }
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
    bool showSnackbar = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    if (showRequest) dev.log("$body ⭐");

    try {
      final response = await http.post(url,
          headers: headers, body: body, encoding: encoding);

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(
          fallback: fallback,
          showSnackbar: showSnackbar,
        );
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on io.SocketException catch (error) {
      dev.log("$error ⭕");
      if (showSnackbar) {
        fun.showSnackbar(error.toString(), type: fun.ColorSnackbarState.error);
      }
      throw connectionFallback;
    }
  }
  
  /// ⭐ Custom ⭐
  /// Sends an HTTP PUT request with the given headers and body to the given URL.
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
  static Future<http.Response> put(
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
    bool showSnackbar = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    if (showRequest) dev.log("$body ⭐");

    try {
      final response = await http.put(url,
          headers: headers, body: body, encoding: encoding);

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(
          fallback: fallback,
          showSnackbar: showSnackbar,
        );
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on io.SocketException catch (error) {
      dev.log("$error ⭕");
      if (showSnackbar) {
        fun.showSnackbar(error.toString(), type: fun.ColorSnackbarState.error);
      }
      throw connectionFallback;
    }
  }
  
  /// ⭐ Custom ⭐
  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
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
  static Future<http.Response> patch(
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
    bool showSnackbar = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    if (showRequest) dev.log("$body ⭐");

    try {
      final response = await http.patch(url,
          headers: headers, body: body, encoding: encoding);

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(
          fallback: fallback,
          showSnackbar: showSnackbar,
        );
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on io.SocketException catch (error) {
      dev.log("$error ⭕");
      if (showSnackbar) {
        fun.showSnackbar(error.toString(), type: fun.ColorSnackbarState.error);
      }
      throw connectionFallback;
    }
  }
}

// ? response extension
extension ResponseExtension on http.Response {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custome default message.
  String catchErrorMessage({
    String searchBy = "message",
    String fallback = "Error",
    bool showSnackbar = false,
  }) {
    dev.log("$statusCode ⭕");
    dev.log("$body ⭕");
    if (showSnackbar) {
      fun.showSnackbar(body.toString(), type: fun.ColorSnackbarState.error);
    }

    return body.contains('"$searchBy":')
        ? jsonDecode(body)[searchBy]
        : body != ""
            ? body
            : fallback;
  }
}

// ? Multipart request extension
extension MultipartRequestExtension on http.MultipartRequest {
  /// ⭐ Custom ⭐
  /// Sends this request.
  ///
  /// This automatically initializes a new [Client] and closes that client once
  /// the request is complete. If you're planning on making multiple requests to
  /// the same server, you should use a single [Client] for all of those
  /// requests.
  ///
  ///
  /// The body of the response as a string.
  ///
  /// This is converted from [bodyBytes] using the `charset` parameter of the
  /// `Content-Type` header field, if available. If it's unavailable or if the
  /// encoding name is unknown, [latin1] is used by default, as per
  /// [RFC 2616][].
  ///
  /// [RFC 2616]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html
  Future<http.Response> sendResponded({
    List<int> acceptedStatus = const [200, 201, 204],
    String fallback = "Error",
    String connectionFallback = "Connection Failed",
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
    bool showSnackbar = false,
  }) async {
    if (requestRef != null) dev.log("$requestRef⬅️");

    if (showRequest) {
      dev.log("fields: $fields, files: ${files.mapIndexed((i, e) => (
            i + 1,
            {
              "contentType": e.contentType,
              "field": e.field,
              "filename": e.filename,
              "length": e.length,
            }
          )).toList()} ⭐");
    }

    try {
      final response = await http.Response.fromStream(await send());

      if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(
          fallback: fallback,
          showSnackbar: showSnackbar,
        );
      }

      if (showResponse) dev.log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on io.SocketException catch (error) {
      dev.log("$error ⭕");
      if (showSnackbar) {
        fun.showSnackbar(error.toString(), type: fun.ColorSnackbarState.error);
      }
      throw connectionFallback;
    }
  }

  /// Adds all key/value pairs of `fieldsIncomming` to this map and will be
  /// transformer to string.
  ///
  /// If a key of `fieldsIncomming` is already in this map, its value is overwritten.
  void addFields(Map<String, dynamic> fieldsIncomming) {
    for (final element in fieldsIncomming.keys) {
      if (fieldsIncomming[element] == null) continue;

      fields[element] = fieldsIncomming[element].toString();
    }
  }

  /// Generate a MultipartFile from each `FileConstructor` into list and will be
  /// added to multipart request.
  Future<void> addFiles(List<FileConstructor?> filesIncomingList) async {
    for (final element in filesIncomingList) {
      if (element == null) continue;

      final typeFile = element.type ?? element.getType() ?? "unknow";
      final formatFile = element.format ?? element.getFormat() ?? "unknow";

      files.add(http.MultipartFile.fromBytes(
        element.name,
        await io.File.fromUri(element.uri).readAsBytes(),
        contentType: MediaType(typeFile, formatFile),
        filename: '${element.name}.$formatFile',
      ));
    }
  }
}

/// A constructor used to storage files data.
///
/// could be used to add files into `http.MultipartRequest` using `addFiles`
/// method.
class FileConstructor {
  const FileConstructor({
    required this.uri,
    required this.name,
    this.format,
    this.type,
  });
  final Uri uri;
  final String name;
  final String? format;
  final String? type;

  /// Get current format of Uri, if dont match will return null
  String? getFormat() => uri.path.split(".").last;

  /// Get current type of File, if dont match will return null
  String? getType() {
    return FilesType.values
        .firstWhereOrNull((element) => element.listValues.contains(getFormat()))
        ?.name;
  }
}
