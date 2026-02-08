import 'package:json_annotation/json_annotation.dart';

part 'signup_request_body.g.dart';

@JsonSerializable()
class SignupRequestBody {
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;

  SignupRequestBody({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory SignupRequestBody.fromJson(Map<String, dynamic> json) => _$SignupRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$SignupRequestBodyToJson(this);
}
