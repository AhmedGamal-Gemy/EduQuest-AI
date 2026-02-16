// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseResponse _$CourseResponseFromJson(Map<String, dynamic> json) =>
    CourseResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      githubRepoUrl: json['github_repo_url'] as String?,
      level: json['level'] as String,
      isPublished: json['is_published'] as bool,
      instructorId: json['instructor_id'] as String,
      studentIds: (json['student_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CourseResponseToJson(CourseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'github_repo_url': instance.githubRepoUrl,
      'level': instance.level,
      'is_published': instance.isPublished,
      'instructor_id': instance.instructorId,
      'student_ids': instance.studentIds,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
