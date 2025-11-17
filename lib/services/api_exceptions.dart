// lib/services/api_exceptions.dart

import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final String? endpoint;

  ApiException(
    this.message, {
    this.statusCode,
    this.type = ErrorType.unknown,
    this.originalError,
    this.stackTrace,
    this.endpoint,
  });

  factory ApiException.fromDioError(DioException error, {String? endpoint}) {
    String message;
    int? statusCode = error.response?.statusCode;
    ErrorType type;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        type = ErrorType.network;
        break;

      case DioExceptionType.sendTimeout:
        message = 'Request timeout. Please try again.';
        type = ErrorType.network;
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Server response timeout. Please try again.';
        type = ErrorType.network;
        break;

      case DioExceptionType.badResponse:
        return _handleStatusCode(
          error.response!.statusCode!,
          error.response?.data,
          error,
          endpoint,
        );

      case DioExceptionType.cancel:
        message = 'Request cancelled.';
        type = ErrorType.cancelled;
        break;

      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        type = ErrorType.network;
        statusCode = null;
        break;

      case DioExceptionType.badCertificate:
        message = 'Security certificate validation failed.';
        type = ErrorType.security;
        break;

      case DioExceptionType.unknown:
      default:
        message = 'An unexpected error occurred: ${error.message}';
        type = ErrorType.unknown;
        break;
    }

    return ApiException(
      message,
      statusCode: statusCode,
      type: type,
      originalError: error,
      stackTrace: error.stackTrace,
      endpoint: endpoint,
    );
  }

  static ApiException _handleStatusCode(
    int statusCode,
    dynamic responseData,
    DioException error,
    String? endpoint,
  ) {
    String message;
    ErrorType type;

    String? serverMessage;
    if (responseData is Map<String, dynamic>) {
      serverMessage =
          responseData['message'] as String? ??
          responseData['error'] as String? ??
          responseData['detail'] as String?;
    }

    switch (statusCode) {
      case 400:
        message = serverMessage ?? 'Invalid request. Please check your input.';
        type = ErrorType.validation;
        break;

      case 401:
        message = serverMessage ?? 'Unauthorized. Please login again.';
        type = ErrorType.authentication;
        break;

      case 403:
        message =
            serverMessage ?? 'Access forbidden. You don\'t have permission.';
        type = ErrorType.authorization;
        break;

      case 404:
        message = serverMessage ?? 'Resource not found.';
        type = ErrorType.notFound;
        break;

      case 405:
        message = 'Method not allowed.';
        type = ErrorType.validation;
        break;

      case 408:
        message = 'Request timeout. Please try again.';
        type = ErrorType.network;
        break;

      case 409:
        message = serverMessage ?? 'Conflict. Resource already exists.';
        type = ErrorType.conflict;
        break;

      case 422:
        message =
            serverMessage ?? 'Validation failed. Please check your input.';
        type = ErrorType.validation;
        break;

      case 429:
        message = 'Too many requests. Please wait and try again.';
        type = ErrorType.rateLimit;
        break;

      case 500:
        message = 'Server error. Please try again later.';
        type = ErrorType.server;
        break;

      case 501:
        message = 'Feature not implemented on server.';
        type = ErrorType.server;
        break;

      case 502:
        message = 'Bad gateway. Server is temporarily unavailable.';
        type = ErrorType.server;
        break;

      case 503:
        message = 'Service unavailable. Please try again later.';
        type = ErrorType.server;
        break;

      case 504:
        message = 'Gateway timeout. Server took too long to respond.';
        type = ErrorType.server;
        break;

      default:
        if (statusCode >= 500) {
          message =
              serverMessage ??
              'Server error ($statusCode). Please try again later.';
          type = ErrorType.server;
        } else if (statusCode >= 400) {
          message =
              serverMessage ??
              'Request failed ($statusCode). Please check your input.';
          type = ErrorType.validation;
        } else {
          message = 'Unexpected response ($statusCode).';
          type = ErrorType.unknown;
        }
    }

    return ApiException(
      message,
      statusCode: statusCode,
      type: type,
      originalError: error,
      stackTrace: error.stackTrace,
      endpoint: endpoint,
    );
  }

  bool get isRetryable {
    return type == ErrorType.network ||
        type == ErrorType.server ||
        statusCode == 408 ||
        statusCode == 429 ||
        statusCode == 502 ||
        statusCode == 503 ||
        statusCode == 504;
  }

  bool get requiresAuth {
    return type == ErrorType.authentication || statusCode == 401;
  }

  String get userMessage {
    switch (type) {
      case ErrorType.network:
        return 'Network error. Please check your connection and try again.';
      case ErrorType.authentication:
        return 'Please login again to continue.';
      case ErrorType.authorization:
        return 'You don\'t have permission to perform this action.';
      case ErrorType.validation:
        return message;
      case ErrorType.notFound:
        return 'The requested item could not be found.';
      case ErrorType.server:
        return 'Server error. We\'re working to fix this.';
      case ErrorType.rateLimit:
        return 'Too many requests. Please wait a moment.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer('ApiException: $message');
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    if (endpoint != null) {
      buffer.write(' [Endpoint: $endpoint]');
    }
    return buffer.toString();
  }
}

enum ErrorType {
  network, // Connection issues, timeouts
  authentication, // 401 - needs login
  authorization, // 403 - no permission
  validation, // 400, 422 - bad input
  notFound, // 404 - resource not found
  conflict, // 409 - resource conflict
  server, // 5xx - server errors
  rateLimit, // 429 - too many requests
  cancelled, // Request cancelled by user
  security, // Certificate/security issues
  unknown, // Unknown errors
}

extension ApiExceptionExtension on DioException {
  ApiException toApiException({String? endpoint}) {
    return ApiException.fromDioError(this, endpoint: endpoint);
  }
}
