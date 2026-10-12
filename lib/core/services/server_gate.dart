import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

import '../extensions/unified_extensions.dart';
import '../utils/logger.dart';

/// Single Dio instance for the whole app. Every call resolves to a
/// [CustomResponse] (success flag + [ErrorType] + user-safe message).
class ServerGate {
  static bool logEnabled = kDebugMode;

  final Dio _dio = Dio();

  ServerGate._() {
    _dio.interceptors.add(CustomApiInterceptor());
    _dio.options = _dio.options.copyWith(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    );
  }

  static final ServerGate i = ServerGate._();

  String _resolveUrl(String url) =>
      url.startsWith('http') ? url : '${ApiConstants.baseUrl}/$url';

  /// GET `baseUrl/url`, the API key is attached to every request.
  Future<CustomResponse<T>> getFromServer<T>({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      params?.removeWhere((k, v) => v == null || '$v'.trim().isEmpty);
      final res = await _dio.get(
        _resolveUrl(url),
        queryParameters: {'key': ApiConstants.apiKey, ...?params},
      );
      return CustomResponse<T>(
        success: true,
        statusCode: res.statusCode ?? 200,
        errType: ErrorType.none,
        data: res.data as T?,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return CustomResponse<T>(
        success: false,
        statusCode: 500,
        errType: ErrorType.unknown,
        msg: kDebugMode ? '$e' : LocaleKeys.errors_unknown.tr(),
      );
    }
  }

  /// Invalid city (WeatherAPI codes), no internet, or anything else.
  CustomResponse<T> _handleError<T>(DioException err) {
    if (err.type == DioExceptionType.badResponse) {
      final data = err.response?.data;
      final error = (data is Map) ? data['error'] : null;
      final message = (error is Map) ? '${error['message'] ?? ''}' : '';
      final code = (error is Map) ? error['code'] : null;
      final isInvalidCity = AppConstants.invalidCityCodes.contains(code);
      return CustomResponse<T>(
        success: false,
        statusCode: err.response?.statusCode ?? 400,
        errType: isInvalidCity ? ErrorType.invalidCity : ErrorType.server,
        msg: message.isNotEmpty
            ? message
            : LocaleKeys.errors_cityNotFound.tr(),
      );
    }

    // No response at all — timeout, no connection, etc.
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.response == null) {
      return CustomResponse<T>(
        success: false,
        statusCode: 0,
        errType: ErrorType.network,
        msg: LocaleKeys.errors_network.tr(),
      );
    }

    return CustomResponse<T>(
      success: false,
      statusCode: err.response?.statusCode ?? 500,
      errType: ErrorType.unknown,
      msg: LocaleKeys.errors_unknown.tr(),
    );
  }
}

class CustomApiInterceptor extends Interceptor {
  final _log = LoggerDebug(
    headColor: LogColors.red,
    constTitle: 'Server Gate Logger',
    enabled: ServerGate.logEnabled,
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.red(
      '------ Current Error Response (status code ${err.response?.statusCode}) -----',
    );
    _log.red(jsonEncode(err.response?.data));
    _log.white(_curl(err.requestOptions));
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.green(
      '------ Current Response (status code ${response.statusCode}) ------',
    );
    _log.green(jsonEncode(response.data));
    _log.white(_curl(response.requestOptions));
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.yellow('------ Current Request Path -----');
    _log.yellow(
      '${options.path} ${LogColors.red}API METHOD : (${options.method})${LogColors.reset}',
    );
    _log.blue('------ Current Request Parameters Data -----');
    _log.blue(jsonEncode(options.queryParameters));
    super.onRequest(options, handler);
  }

  String _curl(RequestOptions options) {
    final curl = StringBuffer("curl -X ${options.method} '${options.uri}'");
    options.headers.forEach((key, value) => curl.write(" -H '$key: $value'"));
    return curl.toString();
  }
}

class CustomResponse<T> {
  bool success;
  ErrorType errType;
  String msg;
  int statusCode;
  T? data;

  CustomResponse({
    this.success = false,
    this.errType = ErrorType.none,
    this.msg = "",
    this.statusCode = 0,
    this.data,
  });
}
