class ApiConstants {
  static const String localhost = "172.25.0.1";
  static const String apiBaseUrl = "http://$localhost:8000/";

  static const String login = "api/v1/auth/jwt/login";
  static const String signup = "api/v1/auth/jwt/register";
  static const String logout = "api/v1/auth/jwt/logout";
}

class SharedPrefKeys {
  static const String userToken = "userToken";
}
