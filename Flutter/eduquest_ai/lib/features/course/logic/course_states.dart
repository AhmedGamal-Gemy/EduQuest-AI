import 'package:eduquest_ai/features/course/data/models/course_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_states.freezed.dart';

@freezed
class CourseState with _$CourseState {
  const factory CourseState.courseInitial() = CourseInitial;
  const factory CourseState.courseLoading() = CourseLoading;
  const factory CourseState.courseListLoaded({
    required List<CourseResponse> courses,
  }) = CourseListLoaded;
  const factory CourseState.courseLoaded({
    required CourseResponse course,
  }) = CourseLoaded;
  const factory CourseState.courseActionSuccess({
    required String message,
  }) = CourseActionSuccess;
  const factory CourseState.courseFailure({
    required String error,
  }) = CourseFailure;
}
/*
CourseActionLoading
CourseCreatedSuccess
CourseUpdatedSuccess


class CourseDeleteLoading extends CourseState {
  final String courseId;
  const CourseDeleteLoading(this.courseId);
}

 */
