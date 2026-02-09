// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      isActive: json['isActive'] as bool,
      isSuperuser: json['isSuperuser'] as bool,
      isVerified: json['isVerified'] as bool,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      role: json['role'] as String,
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'isActive': instance.isActive,
      'isSuperuser': instance.isSuperuser,
      'isVerified': instance.isVerified,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': instance.role,
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
    };
