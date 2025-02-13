import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/file_type.dart.dart';
import 'package:flutter_detextre4/utils/services/local_data/env_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

Future<bool> get haveConnection async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
  } on SocketException catch (_) {
    return false;
  }

  return false;
}

final dio = Dio();

class DioService {
  /// Default [http] header request without authorization
  static final Map<String, String> unauthorized = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  /// [http] header request with authorization
  static Future<Map<String, String>> authorized([String? customToken]) async {
    final String? tokenAuth =
        customToken ?? await SecureStorage.read(SecureCollection.tokenAuth);

    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $tokenAuth',
    };
  }

  // * set configuration
  static void init() {
    dio.options.baseUrl = env.apiUrl;
    // ..connectTimeout = const Duration(seconds: 5)
    // ..receiveTimeout = const Duration(seconds: 3);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        //* set default header auth
        final optionToken = options.headers['Authorization'],
            tokenAuth = await SecureStorage.read(SecureCollection.tokenAuth);

        if (tokenAuth != null && optionToken == null) {
          options.headers['Authorization'] = 'Token $tokenAuth';
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        //* catch unauthorized request
        if (error.response?.statusCode == 401) {
          final mainProvider = ContextUtility.context!.read<MainProvider>();
          routerConfig.router.goNamed("login");

          Modal.showSystemAlert(
            ContextUtility.context!,
            dismissible: false,
            titleText: 'Session has expired',
            contentText: 'Please log in again.',
            textConfirmBtn: "Got it",
          );

          if (!mainProvider.returnDioAuthError) return;
          return handler.next(error);
        }

        return handler.next(error);
      },
    ));
  }
}

extension DioExtensions on Dio {
  Future<Response> getDebug(
    String path, {
    String? requestRef,
    bool showResponse = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (requestRef != null) log("$requestRef⬅️");

      final response = await get(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
      );

      if (showResponse) {
        log("${requestRef ?? ""} ${jsonEncode(response.data)} ✅");
      }

      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> postDebug(
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
    try {
      if (requestRef != null) log("$requestRef⬅️");

      if (showRequest) {
        log("${data is FormData ? jsonEncode({
                "fields": data.fields.map((e) => e.toString()).toList(),
                "files": data.files
                    .map((e) => MapEntry(e.key, e.value.toJson()).toString())
                    .toList(),
              }) : jsonEncode(data)} ⭐");
      }

      final response = await post(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      );

      if (showResponse) {
        log("${requestRef ?? ""} ${jsonEncode(response.data)} ✅");
      }

      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> putDebug(
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
    try {
      if (requestRef != null) log("$requestRef⬅️");

      if (showRequest) log("${jsonEncode(data)} ⭐");

      final response = await put(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      );

      if (showResponse) {
        log("${requestRef ?? ""} ${jsonEncode(response.data)} ✅");
      }

      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> patchDebug(
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
    try {
      if (requestRef != null) log("$requestRef⬅️");

      if (showRequest) log("${jsonEncode(data)} ⭐");

      final response = await patch(
        path,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      );

      if (showResponse) {
        log("${requestRef ?? ""} ${jsonEncode(response.data)} ✅");
      }

      return response;
    } on DioException {
      rethrow;
    }
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
  Future<http.Response> sendDebug({
    List<int> acceptedStatus = const [200, 201, 204],
    String? fallback,
    String connectionFallback = "Connection error, try it later",
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
  }) async {
    if (requestRef != null) log("$requestRef⬅️");

    if (showRequest) {
      final f = files
          .mapIndexed((i, e) => {
                "contentType": e.contentType.toString(),
                "field": e.field,
                "filename": e.filename,
                "length": e.length,
              })
          .toList();
      log('${jsonEncode({"fields": fields, "files": f})} ⭐');
    }

    try {
      final response = await http.Response.fromStream(await send());

      if (response.statusCode == 401) {
        throw "Session has expired";
      } else if (!acceptedStatus.contains(response.statusCode)) {
        throw response.catchErrorMessage(fallback: fallback);
      }

      if (showResponse) log("${requestRef ?? ""} ${response.body} ✅");
      return response;
    } on SocketException {
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

  /// Generate a MultipartFile from each `MultipartContructor` into list and will be
  /// added to multipart request.
  Future<void> addFiles(List<MultipartContructor?> filesIncomingList) async {
    for (final element in filesIncomingList) {
      if (element == null) continue;

      files.add(await element.build());
    }
  }
}

/// A constructor used to storage files data.
///
/// could be used to add files into `http.MultipartRequest` using `addFiles`
/// method.
class MultipartContructor {
  const MultipartContructor({
    required this.file,
    required this.name,
    this.format,
    this.type,
  });
  final file_picker.PlatformFile file;
  final String name;
  final String? format;
  final String? type;

  Future<http.MultipartFile> build() async {
    final typeFile =
            type ?? FileType.fromExtension(file.extension!)?.name ?? "unknow",
        formatFile = format ?? FileType.extension(file.extension!);

    return http.MultipartFile.fromBytes(
      name,
      file.bytes!,
      contentType: MediaType(typeFile, formatFile),
      filename: file.name,
    );
  }
}

// ? dio exception extension
extension DioExceptionExtension on DioException {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custom default message.
  String catchErrorMessage({String? fallback}) {
    //* catch connection failed
    if (type == DioExceptionType.connectionError) {
      return "Oops, it looks like a connection error occurred! Please try again later.";
    }

    //* catch unauthorized request
    if (response?.statusCode == 401) {
      return "Your session has expired. Please log in again";
    }

    fallback ??=
        "${response?.statusCode ?? 'Error'}: An unexpected error has occurred";
    final responseData = response?.data.toString() ?? message ?? '';

    debugPrint("⭕ exceptionType: $type ⭕");
    debugPrint(
        "⭕ statusCode: ${response?.statusCode} ⭕\n⭕ data: ${response?.data} ⭕");

    if (responseData.isHtml()) return fallback;
    return responseData.isNotEmpty ? responseData : fallback;
  }
}

// ? response extension
extension ResponseExtension on http.Response {
  /// Will return the `error message` from the api request.
  ///
  /// in case not be founded will return a custom default message.
  String catchErrorMessage({String? fallback}) {
    //* catch connection failed
    if (statusCode == -6) {
      return "Oops, it looks like a connection error occurred! Please try again later.";
    }

    //* catch unauthorized request
    if (statusCode == 401) {
      return "Your session has expired. Please log in again";
    }

    fallback ??= "$statusCode: An unexpected error has occurred";
    final response = body.toString();

    debugPrint("statusCode: $statusCode ⭕");
    debugPrint("body: $body ⭕");

    if (response.isHtml()) return fallback;
    return response.isNotEmpty ? response : fallback;
  }
}
