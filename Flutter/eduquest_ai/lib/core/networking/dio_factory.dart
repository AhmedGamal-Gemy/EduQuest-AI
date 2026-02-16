import 'package:dio/dio.dart';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();
  static Dio? dio;

  static Future<Dio> getDio() async {
    if (dio == null) {
      dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          followRedirects: false, // handle 307 manually
          validateStatus: (status) => status != null && status < 500,
          headers: await _getHeaders(),
        ),
      );

      addDioInterceptor();
    }
    return dio!;
  }

  /// Load token from SharedPrefs
  static Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPrefHelper.getString(SharedPrefKeys.userToken);
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static void setTokenAfterLogin(String token) {
    dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Update token after login
  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Interceptors
  static void addDioInterceptor() {
    // Logging
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );

    // Handle 307 Temporary Redirect
    dio?.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.statusCode == 307) {
            final location = response.headers.value('location');
            if (location != null) {
              final originalOptions = response.requestOptions;

              // Resend request to new location with headers including Authorization
              final newResponse = await dio!.request(
                location,
                data: originalOptions.data,
                options: Options(
                  method: originalOptions.method,
                  headers: dio!.options.headers, // ✅ include token
                  followRedirects: true,
                ),
              );
              return handler.resolve(newResponse);
            }
          }
          return handler.next(response);
        },
      ),
    );
  }
}
