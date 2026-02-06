import 'package:dio/dio.dart';
// import 'package:eduquest_ai/core/networking/api_constants.dart';
// import 'package:eduquest_ai/features/auth/data/models/login_request_body.dart';
// import 'package:eduquest_ai/features/auth/data/models/login_response.dart';
// import 'package:eduquest_ai/features/auth/data/models/signup_request_body.dart';
// import 'package:eduquest_ai/features/auth/data/models/signup_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

// @RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // @POST(ApiConstants.login)
  // Future<LoginResponse> login(
  //   @Body() LoginRequestBody loginRequestBody,
  // );

  // @POST(ApiConstants.signup)
  // Future<SignupResponse> signup(
  //   @Body() SignupRequestBody signupRequestBody,
  // );

  // @POST(ApiConstants.logout)
  // Future<SignupResponse> logout();

  @GET("https://jsonplaceholder.typicode.com/todos/")
  Future<void> todos();
}
