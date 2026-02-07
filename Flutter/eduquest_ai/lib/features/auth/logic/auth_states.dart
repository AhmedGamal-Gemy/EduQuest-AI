import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_states.freezed.dart';

// AuthAuthenticated | AuthInitial | AuthLoading | AuthUnauthenticated
@freezed
class AuthState with _$AuthState {
  const factory AuthState.authInitial() = AuthInitial;
  const factory AuthState.authLoading() = AuthLoading;
  const factory AuthState.authToggleAuthType({
    required AuthType authType,
  }) = AuthToggleAuthType;

  const factory AuthState.authAuthenticated({
    required String token,
    required String role,
  }) = AuthAuthenticated;

  const factory AuthState.authUnauthenticated({
    String? error,
  }) = AuthUnauthenticated;
}
