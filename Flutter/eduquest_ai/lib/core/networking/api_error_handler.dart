import 'dart:io';
import 'package:dio/dio.dart';
import 'api_error_model.dart';

/// ===============================
/// Enum for logical DataSource errors
/// ===============================
enum DataSourceEnum {
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
/// Error Messages
/// ===============================
class ResponseMessage {
  ResponseMessage._();

  static const String noContent = "No content available";
  static const String badRequest = "Bad request";
  static const String unauthorized = "Unauthorized request";
  static const String forbidden = "Forbidden request";
  static const String notFound = "Resource not found";
  static const String internalServerError = "Internal server error";

  static const String connectTimeout = "Connection timeout";
  static const String sendTimeout = "Send timeout";
  static const String receiveTimeout = "Receive timeout";
  static const String cancel = "Request cancelled";
  static const String cacheError = "Cache error";
  static const String noInternetConnection = "No internet connection";
  static const String defaultError = "Something went wrong";
}

/// ===============================
/// DataSource Extension to convert to ApiErrorModel
/// ===============================
extension DataSourceExtension on DataSourceEnum {
  ApiErrorModel get failure {
    switch (this) {
      case DataSourceEnum.noContent:
        return ApiErrorModel(code: ResponseCode.noContent, detail: ResponseMessage.noContent);
      case DataSourceEnum.badRequest:
        return ApiErrorModel(code: ResponseCode.badRequest, detail: ResponseMessage.badRequest);
      case DataSourceEnum.unauthorized:
        return ApiErrorModel(code: ResponseCode.unauthorized, detail: ResponseMessage.unauthorized);
      case DataSourceEnum.forbidden:
        return ApiErrorModel(code: ResponseCode.forbidden, detail: ResponseMessage.forbidden);
      case DataSourceEnum.notFound:
        return ApiErrorModel(code: ResponseCode.notFound, detail: ResponseMessage.notFound);
      case DataSourceEnum.internalServerError:
        return ApiErrorModel(code: ResponseCode.internalServerError, detail: ResponseMessage.internalServerError);
      case DataSourceEnum.connectTimeout:
        return ApiErrorModel(code: ResponseCode.connectTimeout, detail: ResponseMessage.connectTimeout);
      case DataSourceEnum.sendTimeout:
        return ApiErrorModel(code: ResponseCode.sendTimeout, detail: ResponseMessage.sendTimeout);
      case DataSourceEnum.receiveTimeout:
        return ApiErrorModel(code: ResponseCode.receiveTimeout, detail: ResponseMessage.receiveTimeout);
      case DataSourceEnum.cancel:
        return ApiErrorModel(code: ResponseCode.cancel, detail: ResponseMessage.cancel);
      case DataSourceEnum.cacheError:
        return ApiErrorModel(code: ResponseCode.cacheError, detail: ResponseMessage.cacheError);
      case DataSourceEnum.noInternetConnection:
        return ApiErrorModel(code: ResponseCode.noInternetConnection, detail: ResponseMessage.noInternetConnection);
      case DataSourceEnum.defaultError:
        return ApiErrorModel(code: ResponseCode.defaultError, detail: ResponseMessage.defaultError);
    }
  }
}

/// ===============================
/// Dio Error Handler
/// ===============================
class ErrorHandler implements Exception {
  final ApiErrorModel error;

  ErrorHandler.handle(dynamic exception) : error = _handleError(exception);
}

/// ===============================
/// Map DioException to ApiErrorModel
/// ===============================
ApiErrorModel _handleError(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSourceEnum.connectTimeout.failure;
      case DioExceptionType.sendTimeout:
        return DataSourceEnum.sendTimeout.failure;
      case DioExceptionType.receiveTimeout:
        return DataSourceEnum.receiveTimeout.failure;
      case DioExceptionType.cancel:
        return DataSourceEnum.cancel.failure;
      case DioExceptionType.unknown:
        if (error.error != null && error.error is SocketException) {
          return DataSourceEnum.noInternetConnection.failure;
        }
        return error.response?.data != null ? ApiErrorModel.fromJson(error.response!.data) : DataSourceEnum.defaultError.failure;
      case DioExceptionType.badResponse:
        return error.response?.data != null ? ApiErrorModel.fromJson(error.response!.data) : DataSourceEnum.defaultError.failure;
      case DioExceptionType.badCertificate:
        return ApiErrorModel(
          code: -8,
          detail: "Bad SSL Certificate. Could not verify server.",
        );

      case DioExceptionType.connectionError:
        return ApiErrorModel(
          code: -9,
          detail: "Failed to connect to the server. Check your network.",
        );
    }
  }

  // أي error آخر
  return DataSourceEnum.defaultError.failure;
}
