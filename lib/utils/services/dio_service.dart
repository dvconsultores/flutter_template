import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/file_type.dart.dart';
import 'package:flutter_detextre4/utils/services/local_data/env_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
  /// Default [http] header request to multipart request
  static final Map<String, String> multipart = {
    'Content-type': 'multipart/form-data',
    'Accept': 'multipart/form-data',
  };

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

  /// * set configuration
  static void init(BuildContext context) {
    dio.options.baseUrl = env.apiUrl;
    // ..connectTimeout = const Duration(seconds: 5)
    // ..receiveTimeout = const Duration(seconds: 3);

    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        //* set default header auth
        final optionToken = options.headers['Authorization'],
            tokenAuth = await SecureStorage.read(SecureCollection.tokenAuth);

        if (tokenAuth != null && optionToken == null) {
          options.headers['Authorization'] = 'Token $tokenAuth';
        }

        return handler.next(options);
      }, onError: (DioException error, handler) async {
        //* catch unauthorized request
        if (error.response?.statusCode == 401) {
          Navigator.popUntil(
            ContextUtility.context ?? context,
            (route) => route.isFirst,
          );
          routerConfig.router.goNamed("login");
        }

        return handler.next(error);
      }),
    );
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

  Future<Response> deleteDebug(
    String path, {
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (requestRef != null) log("$requestRef⬅️");

      if (showRequest) log("${jsonEncode(data)} ⭐");

      final response = await delete(
        path,
        data: data,
        cancelToken: cancelToken,
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

  Future<http.Response> multipartRequest(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    Map<String, dynamic>? fields,
    List<MultipartContructor>? files,
  }) async {
    final request = http.MultipartRequest(
      method,
      Uri.parse(url.startsWith("http") ? url : options.baseUrl + url),
    );

    request.headers.addAll(
      {
        ...options.headers,
        ...DioService.multipart,
        ...headers?.map((key, value) => MapEntry(key, value.toString())) ?? {}
      },
    );

    final optionToken = request.headers['Authorization'],
        tokenAuth = await SecureStorage.read(SecureCollection.tokenAuth);

    if (tokenAuth != null && optionToken == null) {
      request.headers['Authorization'] = 'Token $tokenAuth';
    }

    request.addFields(fields ?? {});

    await request.addFiles(files ?? []);

    return await http.Response.fromStream(await request.send());
  }

  Future<http.Response> multipartRequestDebug(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    Map<String, dynamic>? fields,
    List<MultipartContructor>? files,
    String? fallback,
    String connectionFallback = "Connection error, try it later",
    String? requestRef,
    bool showRequest = false,
    bool showResponse = false,
  }) async {
    if (requestRef != null) log("$requestRef⬅️");

    try {
      final request = http.MultipartRequest(
        method,
        Uri.parse(url.startsWith("http") ? url : options.baseUrl + url),
      );

      request.headers.addAll(
        {
          ...options.headers,
          ...DioService.multipart,
          ...headers?.map((key, value) => MapEntry(key, value.toString())) ?? {}
        },
      );

      final optionToken = request.headers['Authorization'],
          tokenAuth = await SecureStorage.read(SecureCollection.tokenAuth);

      if (tokenAuth != null && optionToken == null) {
        request.headers['Authorization'] = 'Token $tokenAuth';
      }

      request.addFields(fields ?? {});

      await request.addFiles(files ?? []);

      if (showRequest) {
        final f = request.files
            .mapIndexed((i, e) => {
                  "contentType": e.contentType.toString(),
                  "field": e.field,
                  "filename": e.filename,
                  "length": e.length,
                })
            .toList();
        log('${jsonEncode({"fields": fields, "files": f})} ⭐');
      }

      final response = await http.Response.fromStream(await request.send());
      if (showResponse) log("${requestRef ?? ""} ${response.body} ✅");

      return response;
    } catch (error) {
      throw error.catchErrorMessage(fallback: connectionFallback);
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
    required this.field,
    this.contentType,
    this.filename,
  });
  final file_picker.PlatformFile file;
  final String field;
  final MediaType? contentType;
  final String? filename;

  Future<http.MultipartFile> build() async {
    if (file.bytes != null) {
      return http.MultipartFile.fromBytes(
        field,
        file.bytes!,
        contentType: contentType ??
            MediaType(
              FileType.fromExtension(file.extension!)?.name ?? "unknow",
              FileType.extension(file.extension!),
            ),
        filename: filename ?? file.name,
      );
    }

    if (file.path != null) {
      return http.MultipartFile.fromPath(
        field,
        file.path!,
        contentType: contentType ??
            MediaType(
              FileType.fromExtension(file.extension!)?.name ?? "unknow",
              FileType.extension(file.extension!),
            ),
        filename: filename ?? file.name,
      );
    }

    throw PlatformException(
      code: "500",
      message: "Couldn't build PlatfromFile provided",
    );
  }
}

extension MultipartResponded on http.MultipartRequest {
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
