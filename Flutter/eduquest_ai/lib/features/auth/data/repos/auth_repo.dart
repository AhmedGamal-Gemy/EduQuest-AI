import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/core/networking/api_error_handler.dart';
import 'package:eduquest_ai/core/networking/api_result.dart';
import 'package:eduquest_ai/core/networking/api_service.dart';
import 'package:eduquest_ai/core/networking/dio_factory.dart';
import 'package:eduquest_ai/features/auth/data/models/login_request_body.dart';
import 'package:eduquest_ai/features/auth/data/models/login_response.dart';
import 'package:eduquest_ai/features/auth/data/models/signup_request_body.dart';
import 'package:eduquest_ai/features/auth/data/models/signup_response.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepo {
  const AuthRepo(this._apiService);
  final ApiService _apiService;

  Future<ApiResult<LoginResponse>> login(LoginRequestBody body) async {
    try {
      final response = await _apiService.login(body.username!, body.password!);
      await saveUserData(response.accessToken, response.role);
      return ApiResult.success(response);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<ApiResult<SignupResponse>> signup(SignupRequestBody body) async {
    try {
      final response = await _apiService.signup(body);
      await saveUserData(response.accessToken, response.role);
      return ApiResult.success(response);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<void> saveUserData(String accessToken, String role) async {
    // final decodedToken = JwtDecoder.decode(response.accessToken);
    // final decodedRole = JwtDecoder.decode(response.role);
    await SharedPrefHelper.setData(SharedPrefKeys.userToken, accessToken);
    await SharedPrefHelper.setData(SharedPrefKeys.userRole, role);
    DioFactory.setTokenIntoHeaderAfterLogin(accessToken);
  }
// setSecuredString
  //Todo Logout:
}

/*
  !JWT: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiM2UxOTkzMy1hYWM1LTQ3YmEtOGQ4NC1hOWFhZWNhMTU3OWUiLCJlbWFpbCI6ImF5aGI3NTZfaW5zQGdtYWlsLmNvbSIsInJvbGUiOiJzdHVkZW50IiwiZmlyc3RfbmFtZSI6IkF5YSIsImxhc3RfbmFtZSI6IkFiZCBlbG1vbWVpbSIsImF1ZCI6WyJmYXN0YXBpLXVzZXJzOmF1dGgiXSwiZXhwIjoxNzcxMTg4OTE0fQ.dvP9QU4JVxFL3k8kW90kGZdnFYw8KIgUgTXlIWHGXYo
    {
      "sub": "b3e19933-aac5-47ba-8d84-a9aaeca1579e",
      "email": "ayhb756_ins@gmail.com",
      "role": "student",
      "first_name": "Aya",
      "last_name": "Abd elmomeim",
      "aud": [
        "fastapi-users:auth"
      ],
      "exp": 1771188914
    }

 */
