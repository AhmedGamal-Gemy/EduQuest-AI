// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequestBody _$SignupRequestBodyFromJson(Map<String, dynamic> json) =>
    SignupRequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
      isActive: json['isActive'] as bool?,
      isSuperuser: json['isSuperuser'] as bool?,
      isVerified: json['isVerified'] as bool?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$SignupRequestBodyToJson(SignupRequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'isActive': instance.isActive,
      'isSuperuser': instance.isSuperuser,
      'isVerified': instance.isVerified,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': instance.role,
    };
