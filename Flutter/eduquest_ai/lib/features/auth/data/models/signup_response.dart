import 'package:json_annotation/json_annotation.dart';

part 'signup_response.g.dart';

@JsonSerializable()
class SignupResponse {
  final String id;
  final String email;
  final bool isActive;
  final bool isSuperuser;
  final bool isVerified;
  final String? firstName;
  final String? lastName;
  final String role;
  final String accessToken;
  final String tokenType;

  SignupResponse({
    required this.id,
    required this.email,
    required this.isActive,
    required this.isSuperuser,
    required this.isVerified,
    this.firstName,
    this.lastName,
    required this.role,
    required this.accessToken,
    required this.tokenType,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) => _$SignupResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SignupResponseToJson(this);
}
