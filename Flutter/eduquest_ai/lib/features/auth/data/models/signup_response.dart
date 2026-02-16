import 'package:json_annotation/json_annotation.dart';

part 'signup_response.g.dart';

@JsonSerializable()
class SignupResponse {
  final String id;
  final String email;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_superuser')
  final bool isSuperuser;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String role;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
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
