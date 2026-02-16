import 'package:eduquest_ai/features/course/data/models/course_request_body.dart';
import 'package:eduquest_ai/features/course/data/repos/course_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'course_states.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepo _courseRepo;

  CourseCubit(this._courseRepo) : super(const CourseInitial());

  // GET: List all courses
  Future<void> fetchCourses() async {
    emit(const CourseLoading());
    final response = await _courseRepo.getCourses();
    response.when(
      success: (courses) => emit(CourseListLoaded(courses: courses)),
      failure: (error) => emit(CourseFailure(error: error.error.detail ?? 'Failed to fetch courses')),
    );
  }

  // GET: Single course
  Future<void> fetchCourse(String courseId) async {
    emit(const CourseLoading());
    final response = await _courseRepo.getCourse(courseId);
    response.when(
      success: (course) => emit(CourseLoaded(course: course)),
      failure: (error) => emit(CourseFailure(error: error.error.detail ?? 'Failed to fetch course')),
    );
  }

  // POST: Create course
  Future<void> createCourse(CourseRequestBody body) async {
    emit(const CourseLoading());
    final response = await _courseRepo.createCourse(body);
    response.when(
      success: (_) => emit(const CourseActionSuccess(message: 'Course created successfully')),
      failure: (error) => emit(CourseFailure(error: error.error.detail ?? 'Failed to create course')),
    );
  }

  // PATCH: Update course
  Future<void> updateCourse(String courseId, CourseRequestBody body) async {
    emit(const CourseLoading());
    final response = await _courseRepo.updateCourse(courseId, body);
    response.when(
      success: (_) => emit(const CourseActionSuccess(message: 'Course updated successfully')),
      failure: (error) => emit(CourseFailure(error: error.error.detail ?? 'Failed to update course')),
    );
  }

  // DELETE: Delete course
  Future<void> deleteCourse(String courseId) async {
    emit(const CourseLoading());
    final response = await _courseRepo.deleteCourse(courseId);
    response.when(
      success: (_) => emit(const CourseActionSuccess(message: 'Course deleted successfully')),
      failure: (error) => emit(CourseFailure(error: error.error.detail ?? 'Failed to delete course')),
    );
  }

  // POST: Enroll in course
  Future<void> enrollInCourse(String courseId) async {
    emit(const CourseLoading());
    final response = await _courseRepo.enrollInCourse(courseId);
    response.when(
      success: (_) => emit(const CourseActionSuccess(message: 'Enrolled in course successfully')),
      failure: (error) => emit(CourseFailure(error: error.error.detail ?? 'Failed to enroll in course')),
    );
  }
}
