import 'package:dio/dio.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/features/course/data/models/course_request_body.dart';
import 'package:eduquest_ai/features/course/data/models/course_response.dart';
import 'package:retrofit/retrofit.dart';
part 'courses_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class CoursesApiService {
  factory CoursesApiService(Dio dio, {String baseUrl}) = _CoursesApiService;

  // GET: /api/v1/courses (List_courses)
  @GET(ApiConstants.courses)
  Future<List<CourseResponse>> getCourses();

  // POST: /api/v1/courses (Create_course)
  @POST(ApiConstants.courses)
  Future<CourseResponse> createCourse(
    @Body() CourseRequestBody body,
  );

  // GET: /api/v1/courses/{course_id} (Get_course)
  @GET(ApiConstants.courseById)
  Future<CourseResponse> getCourse(
    @Path('course_id') String courseId,
  );

  // PATCH: /api/v1/courses/{course_id} (Update_course)
  @PATCH(ApiConstants.courseById)
  Future<CourseResponse> updateCourse(
    @Path('course_id') String courseId,
    @Body() CourseRequestBody body,
  );

  // DELETE: /api/v1/courses/{course_id} (Delete_course)
  @DELETE(ApiConstants.courseById)
  Future<void> deleteCourse(
    @Path('course_id') String courseId,
  );

  // POST: /api/v1/courses/{course_id}/enroll (Enroll_in_course)
  @POST(ApiConstants.enrollCourse)
  Future<void> enrollInCourse(
    @Path('course_id') String courseId,
  );
}
