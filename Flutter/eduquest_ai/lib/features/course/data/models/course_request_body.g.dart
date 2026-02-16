// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRequestBody _$CourseRequestBodyFromJson(Map<String, dynamic> json) =>
    CourseRequestBody(
      title: json['title'] as String,
      description: json['description'] as String?,
      githubRepoUrl: json['github_repo_url'] as String?,
      level: json['level'] as String,
      isPublished: json['is_published'] as bool,
    );

Map<String, dynamic> _$CourseRequestBodyToJson(CourseRequestBody instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'github_repo_url': instance.githubRepoUrl,
      'level': instance.level,
      'is_published': instance.isPublished,
    };
