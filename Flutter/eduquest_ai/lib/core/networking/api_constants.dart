class ApiConstants {
  static const String localhost = "192.168.1.2";
  static const String apiBaseUrl = "http://$localhost:8000/";

  /// Auth_endpoints
  static const String login = "api/v1/auth/jwt/login";
  static const String signup = "api/v1/auth/register";
  static const String logout = "api/v1/auth/jwt/logout";

  /// Courses_endpoints
  static const String courses = '/api/v1/courses/';
  static const String courseById = '/api/v1/courses/{course_id}';
  static const String enrollCourse = '/api/v1/courses/{course_id}/enroll';
}

class SharedPrefKeys {
  static const String userToken = "Token";
  static const String userRole = "Role";
  static const String id = "Id";
}
