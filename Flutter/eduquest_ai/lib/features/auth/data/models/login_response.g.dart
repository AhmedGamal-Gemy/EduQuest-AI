// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      isActive: json['is_active'] as bool,
      isSuperuser: json['is_superuser'] as bool,
      isVerified: json['is_verified'] as bool,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String,
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'is_active': instance.isActive,
      'is_superuser': instance.isSuperuser,
      'is_verified': instance.isVerified,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': instance.role,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
    };
