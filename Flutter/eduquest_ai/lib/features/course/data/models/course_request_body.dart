import 'package:json_annotation/json_annotation.dart';
part 'course_request_body.g.dart';

@JsonSerializable()
class CourseRequestBody {
  final String title;
  final String? description;
  @JsonKey(name: 'github_repo_url')
  final String? githubRepoUrl;
  final String level;
  @JsonKey(name: 'is_published')
  final bool isPublished;

  CourseRequestBody({
    required this.title,
    this.description,
    this.githubRepoUrl,
    required this.level,
    required this.isPublished,
  });

  factory CourseRequestBody.fromJson(Map<String, dynamic> json) => _$CourseRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CourseRequestBodyToJson(this);
}
