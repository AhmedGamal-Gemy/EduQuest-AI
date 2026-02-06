import 'package:eduquest_ai/core/networking/api_error_handler.dart';
import 'package:eduquest_ai/core/networking/api_result.dart';
import 'package:eduquest_ai/core/networking/api_service.dart';
import 'package:eduquest_ai/features/auth/data/models/login_request_body.dart';
import 'package:eduquest_ai/features/auth/data/models/login_response.dart';
import 'package:eduquest_ai/features/auth/data/models/signup_request_body.dart';
import 'package:eduquest_ai/features/auth/data/models/signup_response.dart';
import 'package:flutter/material.dart';

class AuthRepo {
  const AuthRepo(this._apiService);
  final ApiService _apiService;

  // Future<ApiResult<LoginResponse>> login(LoginRequestBody body) async {
  //   try {
  //     final response = await _apiService.login(body);
  //     return ApiResult.success(response);
  //   } catch (exception) {
  //     return ApiResult.failure(ErrorHandler.handle(exception));
  //   }
  // }

  // Future<ApiResult<SignupResponse>> signup(SignupRequestBody body) async {
  //   try {
  //     final response = await _apiService.signup(body);
  //     return ApiResult.success(response);
  //   } catch (exception) {
  //     return ApiResult.failure(ErrorHandler.handle(exception));
  //   }
  // }

  Future<void> todos() async {
    await _apiService.todos();
  }
}
