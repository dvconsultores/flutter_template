import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/functions.dart' as fun;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:collection/collection.dart';
import 'package:flutter_detextre4/utils//services/local_data/secure_storage_service.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class DioService {
  // * base url
  /// Base url from app domain.
  static final String baseUrl =
      dotenv.get("API_URL", fallback: "domain/api/v1");

  /// Base url from app domain where files are storaged.
  static final String fileBaseUrl =
      dotenv.get("FILE_API_URL", fallback: "domain/api/v1");

  // * set configuration
  static void init() {
    dio.options.baseUrl = dotenv.get('API_URL');
    // ..connectTimeout = const Duration(seconds: 5)
    // ..receiveTimeout = const Duration(seconds: 3);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        //* set default header auth
        final optionToken = options.headers['Authorization'];
        final tokenAuth = await SecureStorage.read(SecureCollection.tokenAuth);

        if (tokenAuth != null && optionToken == null) {
          options.headers['Authorization'] = 'Token $tokenAuth';
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        //* catch unauthorized request
        if (error.response?.statusCode == 401) {
          fun.showSnackbar("Session has expired",
              type: fun.ColorSnackbarState.error);

          //* catch connection failed
        } else if (error.error is SocketException) {
          fun.showSnackbar("Connection failed",
              type: fun.ColorSnackbarState.error);
        }

        // return handler.next(error);
      },
    ));
  }
}

extension DioExtensions on Dio {
  Future<Response> getCustom(
    String path, {
    String? requestRef,
    bool showResponse = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (requestRef != null) debugPrint("$requestRef⬅️");

    final response = await get(
      path,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
      queryParameters: queryParameters,
    );

    if (showResponse) debugPrint("${requestRef ?? ""} $response ✅");

    return response;
  }

  Future<Response> postCustom(
    String path, {
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    void Function(int, int)? onSendProgress,
  }) async {
    if (requestRef != null) debugPrint("$requestRef⬅️");

    if (showRequest) debugPrint("$data ⭐");

    final response = await post(
      path,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
    );

    if (showResponse) debugPrint("${requestRef ?? ""} $response ✅");

    return response;
  }

  Future<Response> putCustom(
    String path, {
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    void Function(int, int)? onSendProgress,
  }) async {
    if (requestRef != null) debugPrint("$requestRef⬅️");

    if (showRequest) debugPrint("$data ⭐");

    final response = await put(
      path,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
    );

    if (showResponse) debugPrint("${requestRef ?? ""} $response ✅");

    return response;
  }

  Future<Response> patchCustom(
    String path, {
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    void Function(int, int)? onSendProgress,
  }) async {
    if (requestRef != null) debugPrint("$requestRef⬅️");

    if (showRequest) debugPrint("$data ⭐");

    final response = await patch(
      path,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
    );

    if (showResponse) debugPrint("${requestRef ?? ""} $response ✅");

    return response;
  }
}

// TODO pending to checkout and update
extension MultipartResponded on http.MultipartRequest {
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
  Future<http.Response> sendCustom({
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
  }) async {
    if (requestRef != null) debugPrint("$requestRef⬅️");

    if (showRequest) {
      debugPrint("fields: $fields, files: ${files.mapIndexed((i, e) => (
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

      if (response.statusCode == 401) {
        fun.showSnackbar("Session has expired");

        throw "Session has expired";
      }

      if (showResponse) debugPrint("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on SocketException catch (error) {
      debugPrint("$error ⭕");
      throw "Connection failed";
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
        await File.fromUri(element.uri).readAsBytes(),
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

  Future<http.MultipartFile> toMultipartFile() async {
    final typeFile = type ?? getType() ?? "unknow";
    final formatFile = format ?? getFormat() ?? "unknow";

    return http.MultipartFile.fromBytes(
      name,
      await File.fromUri(uri).readAsBytes(),
      contentType: MediaType(typeFile, formatFile),
      filename: '$name.$formatFile',
    );
  }
}

/// A Collection of formats to diverse file types
enum FilesType {
  image([
    "svg",
    "jpeg",
    "jpg",
    "png",
    "gif",
    "tiff",
    "psd",
    "pdf",
    "eps",
    "ai",
    "indd",
    "raw",
  ]),
  video([
    "mp4",
    "mov",
    "wmv",
    "avi",
    "mkv",
    "avchd",
    "flv",
    "f4v",
    "swf",
    "webm",
    "html5",
    "mpeg-2",
  ]),
  audio([
    "m4a",
    "flac",
    "mp3",
    "wav",
    "wma",
    "aac",
  ]);

  const FilesType(this.listValues);

  /// List of admitted formats
  final List<String> listValues;
}

// ? dio response extension
extension DioResponseExtension on Response? {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custome default message.
  String catchErrorMessage([String fallback = "Error"]) {
    if (this == null) return fallback;

    final body = this!;

    debugPrint("${body.statusCode} ⭕");
    debugPrint("${body.data} ⭕");

    return (body.data as String).isNotEmpty ? body.data : fallback;
  }
}

// ? response extension
extension ResponseExtension on http.Response {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custome default message.
  String catchErrorMessage([String fallback = "Error"]) {
    debugPrint("$statusCode ⭕");
    debugPrint("$body ⭕");

    return body.isNotEmpty ? body : fallback;
  }
}
