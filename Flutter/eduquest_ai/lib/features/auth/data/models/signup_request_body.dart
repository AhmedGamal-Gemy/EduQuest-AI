import 'package:json_annotation/json_annotation.dart';

part 'signup_request_body.g.dart';

@JsonSerializable()
class SignupRequestBody {
  final String email;
  final String password;
  final bool? isActive;
  final bool? isSuperuser;
  final bool? isVerified;
  final String? firstName;
  final String? lastName;
  final String role;

  SignupRequestBody({
    required this.email,
    required this.password,
    this.isActive,
    this.isSuperuser,
    this.isVerified,
    this.firstName,
    this.lastName,
    required this.role,
  });

  factory SignupRequestBody.fromJson(Map<String, dynamic> json) => _$SignupRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$SignupRequestBodyToJson(this);
}
