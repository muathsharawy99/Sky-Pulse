import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../extensions/cubit_enums.dart';

/// Single Dio instance for the whole app — wraps requests so callers get
/// back a [CustomResponse] (success flag + [ErrorType] + message) instead
/// of dealing with Dio/DioException directly.
class ServerGate {
  ServerGate._() {
    _dio.options = _dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  static final ServerGate i = ServerGate._();

  static const String baseUrl = 'https://api.weatherapi.com/v1/';

  // Hardcoded key — fine for this task, but in a real app this belongs
  // behind a backend/env config, not shipped in the client.
  static const String apiKey = '6f27a7b9512c4882a45162444252101';

  final Dio _dio = Dio();

  /// Hits `baseUrl + url`, auto-attaching the API key to every request.
  Future<CustomResponse> getFromServer({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: {'key': apiKey, ...?params},
      );
      return CustomResponse(
        success: true,
        statusCode: response.statusCode ?? 200,
        errType: ErrorType.none,
        data: response.data,
      );
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      // Catch-all for anything that isn't a DioException.
      return CustomResponse(
        success: false,
        statusCode: 500,
        errType: ErrorType.unknown,
        msg: kDebugMode ? '$e' : 'Something went wrong, please try again.',
      );
    }
  }

  // Maps a DioException to one of: invalid city, no internet, or other.
  CustomResponse _handleError(DioException err) {
    if (err.type == DioExceptionType.badResponse) {
      final data = err.response?.data;
      final error = (data is Map) ? data['error'] : null;
      final message = (error is Map) ? '${error['message'] ?? ''}' : '';
      final code = (error is Map) ? error['code'] : null;

      // WeatherAPI's own codes for "city not found".
      final isInvalidCity = code == 1006 || code == 1003;

      return CustomResponse(
        success: false,
        statusCode: err.response?.statusCode ?? 400,
        errType: isInvalidCity ? ErrorType.invalidCity : ErrorType.server,
        msg: message.isNotEmpty
            ? message
            : 'City not found. Please check the spelling and try again.',
      );
    }

    // No response at all — timeout, no connection, etc.
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.response == null) {
      return CustomResponse(
        success: false,
        statusCode: 0,
        errType: ErrorType.network,
        msg: 'Please check your internet connection and try again.',
      );
    }

    return CustomResponse(
      success: false,
      statusCode: err.response?.statusCode ?? 500,
      errType: ErrorType.unknown,
      msg: 'Something went wrong, please try again.',
    );
  }
}

/// What every API call resolves to — success flag, [ErrorType], message,
/// and the raw data payload on success.
class CustomResponse {
  bool success;
  ErrorType errType;
  String msg;
  int statusCode;
  dynamic data;

  CustomResponse({
    this.success = false,
    this.errType = ErrorType.none,
    this.msg = '',
    this.statusCode = 0,
    this.data,
  });
}
