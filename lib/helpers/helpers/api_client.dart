import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/helpers/helpers/app_error.dart';
import 'package:taskflow/helpers/helpers/flavor_config.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;

  static const _connectTimeoutMs = 15000; // 15s
  static const _receiveTimeoutMs = 20000; // 20s
  static const _sendTimeoutMs = 20000; // 20s
  // static const _retryDelayMs = 800; // 0.8s

  ApiClient({this.maxRetries = 2})
      : _dio = Dio(),
        _logger = Logger() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options.baseUrl = getBaseUrl();
    _dio.options.connectTimeout = const Duration(
      milliseconds: _connectTimeoutMs,
    );
    _dio.options.receiveTimeout = const Duration(
      milliseconds: _receiveTimeoutMs,
    );
    _dio.options.sendTimeout = const Duration(
      milliseconds: _sendTimeoutMs,
    );

    _dio.interceptors.addAll([
      _addHeadersInterceptor(),
      _logInterceptor(),
      // _authInterceptor(),
    ]);
  }

  String getBaseUrl() {
    return FlavorConfig.instance.values.baseUrl;
  }

  InterceptorsWrapper _addHeadersInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        const accessToken = 'accessToken';
        options.headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        });
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _logInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (FlavorConfig.instance.values.enableLogging) {
          final requestData = options.data;
          String dataDescription = '';
          if (requestData is FormData) {
            final formDataFields = requestData.fields
                .map((field) => '${field.key}: ${field.value}')
                .join(', ');
            final fileFields = requestData.files
                .map((file) => '${file.key}: File(${file.value.filename})')
                .join(', ');
            dataDescription =
                "FormData - Fields: {$formDataFields}, Files: {$fileFields}";
          } else {
            dataDescription = requestData.toString();
          }
          _logger.i("""
                Request:
                - Method: ${options.method}
                - URL: ${options.uri}
                - Headers: ${options.headers}
                - Body: $dataDescription
                """);
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (FlavorConfig.instance.values.enableLogging) {
          _logger.i("""
                  Response:
                  - Request Method: ${response.requestOptions.method}
                  - URL: ${response.requestOptions.uri}
                  - Status Code: ${response.statusCode}
                  - Data: ${response.data}
                  """);
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (FlavorConfig.instance.values.enableLogging) {
          AppError.create(
            message: 'Request failed',
            type: ErrorType.network,
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        handler.next(error);
      },
    );
  }

  // InterceptorsWrapper _authInterceptor() {
  //   return InterceptorsWrapper(
  //     onError: (DioException error, handler) async {
  //       if (error.response?.statusCode == 401) {
  //         final success = await _refreshToken();
  //         if (success) {
  //           _retryRequest(error.requestOptions, handler);
  //         } else {
  //           _logger.e("Failed to refresh token");
  //           handler.next(error);
  //         }
  //       } else {
  //         handler.next(error);
  //       }
  //     },
  //   );
  // }

  // Future<bool> _refreshToken() async {
  //   try {
  //     final refreshToken = _Us;
  //     if (refreshToken == null) return false;

  //     final response = await _dio.post(
  //       _urlProvider.refreshTokenUrl,
  //       data: {"refreshToken": refreshToken},
  //     );

  //     if (response.statusCode == 200) {
  //       final newAccessToken = response.data['access_token'];
  //       await SharedPrefs().setString("accessToken", newAccessToken);
  //       return true;
  //     }
  //   } on DioException catch (e) {
  //     AppError.create(
  //       message: 'Failed to refresh token',
  //       type: ErrorType.authentication,
  //       originalError: e,
  //       stackTrace: e.stackTrace,
  //     );
  //   } catch (e) {
  //     AppError.create(
  //       message: 'Unexpected error during token refresh',
  //       type: ErrorType.unknown,
  //       originalError: e,
  //     );
  //   }
  //   return false;
  // }

  // Optional: add retry helper if needed in future

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw AppError.create(
        message: 'GET request failed for $endpoint',
        type: ErrorType.network,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMessage = _handleErrorMessage(statusCode, e.response?.data);
      throw ApiClientException(errorMessage, statusCode);
    }
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMessage = _handleErrorMessage(statusCode, e.response?.data);
      throw ApiClientException(errorMessage, statusCode);
    }
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMessage = _handleErrorMessage(statusCode, e.response?.data);
      throw ApiClientException(errorMessage, statusCode);
    }
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMessage = _handleErrorMessage(statusCode, e.response?.data);
      throw ApiClientException(errorMessage, statusCode);
    }
  }

  Options _mergeOptions(Options? options, bool requiresAuth) {
    return (options ?? Options()).copyWith(
      extra: {...options?.extra ?? {}, 'requiresAuth': requiresAuth},
    );
  }
}

/// **Helper function to map status codes to meaningful messages**
String _handleErrorMessage(int? statusCode, dynamic data) {
  if (data is Map<String, dynamic> && data.containsKey('message')) {
    return data['message']; // Use API-provided message if available
  }

  switch (statusCode) {
    case 400:
      return 'Invalid request. Please check your input.';
    case 401:
      return 'Unauthorized';
    case 403:
      return 'Forbidden';
    case 404:
      return 'Resource not found.';
    case 500:
      return 'Server error. Please try again later.';
    default:
      return 'An unexpected error occurred.';
  }
}

class ApiClientException implements Exception {
  final String message;
  final int? statusCode;
  ApiClientException(this.message, this.statusCode);

  @override
  String toString() => 'ApiClientException($statusCode): $message';
}
