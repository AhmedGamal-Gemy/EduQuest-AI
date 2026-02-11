import 'package:json_annotation/json_annotation.dart';
part 'course_response.g.dart';

@JsonSerializable()
class CourseResponse {
  final String id;
  final String title;
  final String? description;
  @JsonKey(name: 'github_repo_url')
  final String? githubRepoUrl;
  final String level;
  @JsonKey(name: 'is_published')
  final bool isPublished;
  @JsonKey(name: 'instructor_id')
  final String instructorId;
  @JsonKey(name: 'student_ids')
  final List<String> studentIds;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  CourseResponse({
    required this.id,
    required this.title,
    this.description,
    this.githubRepoUrl,
    required this.level,
    required this.isPublished,
    required this.instructorId,
    required this.studentIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) => _$CourseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
}
