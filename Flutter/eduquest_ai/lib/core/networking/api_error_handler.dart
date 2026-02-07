import 'package:dio/dio.dart';
import 'package:eduquest_ai/core/networking/api_error_model.dart';
import 'api_constants.dart';

/// ===============================
/// Data Source (Enum)
/// ===============================
enum DataSource {
  noContent,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError,
}

/// ===============================
/// Response Codes
/// ===============================
class ResponseCode {
  ResponseCode._();

  // API status codes
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;
  static const int apiLogicError = 422;

  // Local status codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

/// ===============================
/// Response Messages
/// ===============================
class ResponseMessage {
  ResponseMessage._();

  static const String noContent = ApiErrors.noContent;
  static const String badRequest = ApiErrors.badRequestError;
  static const String unauthorized = ApiErrors.unauthorizedError;
  static const String forbidden = ApiErrors.forbiddenError;
  static const String notFound = ApiErrors.notFoundError;
  static const String internalServerError = ApiErrors.internalServerError;

  static const String connectTimeout = ApiErrors.timeoutError;
  static const String cancel = ApiErrors.defaultError;
  static const String receiveTimeout = ApiErrors.timeoutError;
  static const String sendTimeout = ApiErrors.timeoutError;
  static const String cacheError = ApiErrors.cacheError;
  static const String noInternetConnection = ApiErrors.noInternetError;
  static const String defaultError = ApiErrors.defaultError;
}

/// ===============================
/// DataSource Extension
/// ===============================
extension DataSourceExtension on DataSource {
  ApiErrorModel get failure {
    switch (this) {
      case DataSource.noContent:
        return ApiErrorModel(
          code: ResponseCode.noContent,
          message: ResponseMessage.noContent,
        );
      case DataSource.badRequest:
        return ApiErrorModel(
          code: ResponseCode.badRequest,
          message: ResponseMessage.badRequest,
        );
      case DataSource.unauthorized:
        return ApiErrorModel(
          code: ResponseCode.unauthorized,
          message: ResponseMessage.unauthorized,
        );
      case DataSource.forbidden:
        return ApiErrorModel(
          code: ResponseCode.forbidden,
          message: ResponseMessage.forbidden,
        );
      case DataSource.notFound:
        return ApiErrorModel(
          code: ResponseCode.notFound,
          message: ResponseMessage.notFound,
        );
      case DataSource.internalServerError:
        return ApiErrorModel(
          code: ResponseCode.internalServerError,
          message: ResponseMessage.internalServerError,
        );
      case DataSource.connectTimeout:
        return ApiErrorModel(
          code: ResponseCode.connectTimeout,
          message: ResponseMessage.connectTimeout,
        );
      case DataSource.cancel:
        return ApiErrorModel(
          code: ResponseCode.cancel,
          message: ResponseMessage.cancel,
        );
      case DataSource.receiveTimeout:
        return ApiErrorModel(
          code: ResponseCode.receiveTimeout,
          message: ResponseMessage.receiveTimeout,
        );
      case DataSource.sendTimeout:
        return ApiErrorModel(
          code: ResponseCode.sendTimeout,
          message: ResponseMessage.sendTimeout,
        );
      case DataSource.cacheError:
        return ApiErrorModel(
          code: ResponseCode.cacheError,
          message: ResponseMessage.cacheError,
        );
      case DataSource.noInternetConnection:
        return ApiErrorModel(
          code: ResponseCode.noInternetConnection,
          message: ResponseMessage.noInternetConnection,
        );
      case DataSource.defaultError:
        return ApiErrorModel(
          code: ResponseCode.defaultError,
          message: ResponseMessage.defaultError,
        );
    }
  }
}

/// ===============================
/// Error Handler
/// ===============================
class ErrorHandler implements Exception {
  final ApiErrorModel error;

  ErrorHandler.handle(dynamic exception) : error = _handleError(exception);
}

/// ===============================
/// Dio Error Mapper
/// ===============================
ApiErrorModel _handleError(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeout.failure;
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.failure;
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.failure;
      case DioExceptionType.cancel:
        return DataSource.cancel.failure;
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return error.response?.data != null ? ApiErrorModel.fromJson(error.response!.data) : DataSource.defaultError.failure;
      default:
        return DataSource.defaultError.failure;
    }
  }
  return DataSource.defaultError.failure;
}

/// ===============================
/// API Internal Status
/// ===============================
class ApiInternalStatus {
  ApiInternalStatus._();

  static const int success = 0;
  static const int failure = 1;
}
