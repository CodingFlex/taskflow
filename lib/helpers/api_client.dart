/// HTTP client wrapper around Dio that provides a centralized interface for API calls.
/// Handles request/response logging, authentication headers, error transformation,
/// and timeout configuration. All HTTP methods (GET, POST, PUT, DELETE, PATCH) are
/// wrapped with error handling that converts Dio exceptions to ApiException.
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:taskflow/helpers/flavor_config.dart';
import 'package:taskflow/helpers/logger_helper.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;

  static const _connectTimeoutMs = 15000;
  static const _receiveTimeoutMs = 20000;
  static const _sendTimeoutMs = 20000;

  ApiClient({this.maxRetries = 2}) : _dio = Dio(), _logger = createLogger() {
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
    _dio.options.sendTimeout = const Duration(milliseconds: _sendTimeoutMs);

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
          _logger.e(
            'API Error: ${error.requestOptions.method} ${error.requestOptions.uri}',
            error: error,
            stackTrace: error.stackTrace,
          );
        }
        handler.next(error);
      },
    );
  }

  Future<Response<T>> _executeRequest<T>(
    Future<Response<T>> Function() request,
    String endpoint,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e, endpoint: endpoint);
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error during API call',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Unexpected error: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
        endpoint: endpoint,
      );
    }
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _executeRequest(
      () => _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      ),
      endpoint,
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _executeRequest(
      () => _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      ),
      endpoint,
    );
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _executeRequest(
      () => _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      ),
      endpoint,
    );
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _executeRequest(
      () => _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      ),
      endpoint,
    );
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _executeRequest(
      () => _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      ),
      endpoint,
    );
  }

  Options _mergeOptions(Options? options, bool requiresAuth) {
    return (options ?? Options()).copyWith(
      extra: {...options?.extra ?? {}, 'requiresAuth': requiresAuth},
    );
  }

  void dispose() {
    _dio.close(force: true);
  }
}
