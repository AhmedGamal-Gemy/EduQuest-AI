import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
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

  LoginResponse({
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

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
