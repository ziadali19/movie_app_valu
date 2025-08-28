// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';

import 'failure_model.dart';

class ErrorHandler {
  static ErrorHandler errorHandler = ErrorHandler._();
  ErrorHandler._();

  static ErrorHandler get instance => errorHandler;

  ApiErrorModel handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: "Connection to server failed");
        case DioExceptionType.cancel:
          return ApiErrorModel(message: "Request to the server was cancelled");
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: "Connection timeout with the server");
        case DioExceptionType.unknown:
          return ApiErrorModel(
            message:
                "Connection to the server failed due to internet connection",
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            message: "Receive timeout in connection with the server",
          );
        case DioExceptionType.badResponse:
          return ApiErrorModel.fromJson(
            error.response?.data as Map<String, dynamic>,
          );
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            message: "Send timeout in connection with the server",
          );

        default:
          return ApiErrorModel(message: "Something went wrong");
      }
    } else if (error is FailException) {
      return ApiErrorModel(message: error.exception.toString());
    } else {
      return ApiErrorModel(message: "Unexpected error occurred");
    }
  }
}
