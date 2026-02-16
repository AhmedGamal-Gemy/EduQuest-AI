import 'package:eduquest_ai/core/networking/api_error_handler.dart';
import 'package:eduquest_ai/core/networking/api_result.dart';
import 'package:eduquest_ai/features/course/data/models/course_request_body.dart';
import 'package:eduquest_ai/features/course/data/models/course_response.dart';
import 'package:eduquest_ai/features/course/data/repos/courses_api_service.dart';

class CourseRepo {
  const CourseRepo(this._coursesApiService);
  final CoursesApiService _coursesApiService;

  Future<ApiResult<List<CourseResponse>>> getCourses() async {
    try {
      final response = await _coursesApiService.getCourses();
      return ApiResult.success(response);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<ApiResult<CourseResponse>> createCourse(CourseRequestBody body) async {
    try {
      final response = await _coursesApiService.createCourse(body);
      return ApiResult.success(response);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<ApiResult<CourseResponse>> getCourse(String courseId) async {
    try {
      final response = await _coursesApiService.getCourse(courseId);
      return ApiResult.success(response);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<ApiResult<CourseResponse>> updateCourse(String courseId, CourseRequestBody body) async {
    try {
      final response = await _coursesApiService.updateCourse(courseId, body);
      return ApiResult.success(response);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<ApiResult<void>> deleteCourse(String courseId) async {
    try {
      await _coursesApiService.deleteCourse(courseId);
      return ApiResult.success(null);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }

  Future<ApiResult<void>> enrollInCourse(String courseId) async {
    try {
      await _coursesApiService.enrollInCourse(courseId);
      return ApiResult.success(null);
    } catch (exception) {
      return ApiResult.failure(ErrorHandler.handle(exception));
    }
  }
}
