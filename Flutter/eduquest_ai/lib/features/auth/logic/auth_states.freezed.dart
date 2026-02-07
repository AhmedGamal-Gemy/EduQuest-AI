// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(AuthType authType) authToggleAuthType,
    required TResult Function(String token, String role) authAuthenticated,
    required TResult Function(String? error) authUnauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(AuthType authType)? authToggleAuthType,
    TResult? Function(String token, String role)? authAuthenticated,
    TResult? Function(String? error)? authUnauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(AuthType authType)? authToggleAuthType,
    TResult Function(String token, String role)? authAuthenticated,
    TResult Function(String? error)? authUnauthenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(AuthToggleAuthType value) authToggleAuthType,
    required TResult Function(AuthAuthenticated value) authAuthenticated,
    required TResult Function(AuthUnauthenticated value) authUnauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult? Function(AuthAuthenticated value)? authAuthenticated,
    TResult? Function(AuthUnauthenticated value)? authUnauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult Function(AuthAuthenticated value)? authAuthenticated,
    TResult Function(AuthUnauthenticated value)? authUnauthenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthInitialImplCopyWith<$Res> {
  factory _$$AuthInitialImplCopyWith(
          _$AuthInitialImpl value, $Res Function(_$AuthInitialImpl) then) =
      __$$AuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthInitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthInitialImpl>
    implements _$$AuthInitialImplCopyWith<$Res> {
  __$$AuthInitialImplCopyWithImpl(
      _$AuthInitialImpl _value, $Res Function(_$AuthInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthInitialImpl implements AuthInitial {
  const _$AuthInitialImpl();

  @override
  String toString() {
    return 'AuthState.authInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(AuthType authType) authToggleAuthType,
    required TResult Function(String token, String role) authAuthenticated,
    required TResult Function(String? error) authUnauthenticated,
  }) {
    return authInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(AuthType authType)? authToggleAuthType,
    TResult? Function(String token, String role)? authAuthenticated,
    TResult? Function(String? error)? authUnauthenticated,
  }) {
    return authInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(AuthType authType)? authToggleAuthType,
    TResult Function(String token, String role)? authAuthenticated,
    TResult Function(String? error)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authInitial != null) {
      return authInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(AuthToggleAuthType value) authToggleAuthType,
    required TResult Function(AuthAuthenticated value) authAuthenticated,
    required TResult Function(AuthUnauthenticated value) authUnauthenticated,
  }) {
    return authInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult? Function(AuthAuthenticated value)? authAuthenticated,
    TResult? Function(AuthUnauthenticated value)? authUnauthenticated,
  }) {
    return authInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult Function(AuthAuthenticated value)? authAuthenticated,
    TResult Function(AuthUnauthenticated value)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authInitial != null) {
      return authInitial(this);
    }
    return orElse();
  }
}

abstract class AuthInitial implements AuthState {
  const factory AuthInitial() = _$AuthInitialImpl;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
          _$AuthLoadingImpl value, $Res Function(_$AuthLoadingImpl) then) =
      __$$AuthLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
      _$AuthLoadingImpl _value, $Res Function(_$AuthLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl();

  @override
  String toString() {
    return 'AuthState.authLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(AuthType authType) authToggleAuthType,
    required TResult Function(String token, String role) authAuthenticated,
    required TResult Function(String? error) authUnauthenticated,
  }) {
    return authLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(AuthType authType)? authToggleAuthType,
    TResult? Function(String token, String role)? authAuthenticated,
    TResult? Function(String? error)? authUnauthenticated,
  }) {
    return authLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(AuthType authType)? authToggleAuthType,
    TResult Function(String token, String role)? authAuthenticated,
    TResult Function(String? error)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authLoading != null) {
      return authLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(AuthToggleAuthType value) authToggleAuthType,
    required TResult Function(AuthAuthenticated value) authAuthenticated,
    required TResult Function(AuthUnauthenticated value) authUnauthenticated,
  }) {
    return authLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult? Function(AuthAuthenticated value)? authAuthenticated,
    TResult? Function(AuthUnauthenticated value)? authUnauthenticated,
  }) {
    return authLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult Function(AuthAuthenticated value)? authAuthenticated,
    TResult Function(AuthUnauthenticated value)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authLoading != null) {
      return authLoading(this);
    }
    return orElse();
  }
}

abstract class AuthLoading implements AuthState {
  const factory AuthLoading() = _$AuthLoadingImpl;
}

/// @nodoc
abstract class _$$AuthToggleAuthTypeImplCopyWith<$Res> {
  factory _$$AuthToggleAuthTypeImplCopyWith(_$AuthToggleAuthTypeImpl value,
          $Res Function(_$AuthToggleAuthTypeImpl) then) =
      __$$AuthToggleAuthTypeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthType authType});
}

/// @nodoc
class __$$AuthToggleAuthTypeImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthToggleAuthTypeImpl>
    implements _$$AuthToggleAuthTypeImplCopyWith<$Res> {
  __$$AuthToggleAuthTypeImplCopyWithImpl(_$AuthToggleAuthTypeImpl _value,
      $Res Function(_$AuthToggleAuthTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authType = null,
  }) {
    return _then(_$AuthToggleAuthTypeImpl(
      authType: null == authType
          ? _value.authType
          : authType // ignore: cast_nullable_to_non_nullable
              as AuthType,
    ));
  }
}

/// @nodoc

class _$AuthToggleAuthTypeImpl implements AuthToggleAuthType {
  const _$AuthToggleAuthTypeImpl({required this.authType});

  @override
  final AuthType authType;

  @override
  String toString() {
    return 'AuthState.authToggleAuthType(authType: $authType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthToggleAuthTypeImpl &&
            (identical(other.authType, authType) ||
                other.authType == authType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authType);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthToggleAuthTypeImplCopyWith<_$AuthToggleAuthTypeImpl> get copyWith =>
      __$$AuthToggleAuthTypeImplCopyWithImpl<_$AuthToggleAuthTypeImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(AuthType authType) authToggleAuthType,
    required TResult Function(String token, String role) authAuthenticated,
    required TResult Function(String? error) authUnauthenticated,
  }) {
    return authToggleAuthType(authType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(AuthType authType)? authToggleAuthType,
    TResult? Function(String token, String role)? authAuthenticated,
    TResult? Function(String? error)? authUnauthenticated,
  }) {
    return authToggleAuthType?.call(authType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(AuthType authType)? authToggleAuthType,
    TResult Function(String token, String role)? authAuthenticated,
    TResult Function(String? error)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authToggleAuthType != null) {
      return authToggleAuthType(authType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(AuthToggleAuthType value) authToggleAuthType,
    required TResult Function(AuthAuthenticated value) authAuthenticated,
    required TResult Function(AuthUnauthenticated value) authUnauthenticated,
  }) {
    return authToggleAuthType(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult? Function(AuthAuthenticated value)? authAuthenticated,
    TResult? Function(AuthUnauthenticated value)? authUnauthenticated,
  }) {
    return authToggleAuthType?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult Function(AuthAuthenticated value)? authAuthenticated,
    TResult Function(AuthUnauthenticated value)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authToggleAuthType != null) {
      return authToggleAuthType(this);
    }
    return orElse();
  }
}

abstract class AuthToggleAuthType implements AuthState {
  const factory AuthToggleAuthType({required final AuthType authType}) =
      _$AuthToggleAuthTypeImpl;

  AuthType get authType;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthToggleAuthTypeImplCopyWith<_$AuthToggleAuthTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAuthenticatedImplCopyWith<$Res> {
  factory _$$AuthAuthenticatedImplCopyWith(_$AuthAuthenticatedImpl value,
          $Res Function(_$AuthAuthenticatedImpl) then) =
      __$$AuthAuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String token, String role});
}

/// @nodoc
class __$$AuthAuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAuthenticatedImpl>
    implements _$$AuthAuthenticatedImplCopyWith<$Res> {
  __$$AuthAuthenticatedImplCopyWithImpl(_$AuthAuthenticatedImpl _value,
      $Res Function(_$AuthAuthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? role = null,
  }) {
    return _then(_$AuthAuthenticatedImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthAuthenticatedImpl implements AuthAuthenticated {
  const _$AuthAuthenticatedImpl({required this.token, required this.role});

  @override
  final String token;
  @override
  final String role;

  @override
  String toString() {
    return 'AuthState.authAuthenticated(token: $token, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAuthenticatedImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, role);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      __$$AuthAuthenticatedImplCopyWithImpl<_$AuthAuthenticatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(AuthType authType) authToggleAuthType,
    required TResult Function(String token, String role) authAuthenticated,
    required TResult Function(String? error) authUnauthenticated,
  }) {
    return authAuthenticated(token, role);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(AuthType authType)? authToggleAuthType,
    TResult? Function(String token, String role)? authAuthenticated,
    TResult? Function(String? error)? authUnauthenticated,
  }) {
    return authAuthenticated?.call(token, role);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(AuthType authType)? authToggleAuthType,
    TResult Function(String token, String role)? authAuthenticated,
    TResult Function(String? error)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authAuthenticated != null) {
      return authAuthenticated(token, role);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(AuthToggleAuthType value) authToggleAuthType,
    required TResult Function(AuthAuthenticated value) authAuthenticated,
    required TResult Function(AuthUnauthenticated value) authUnauthenticated,
  }) {
    return authAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult? Function(AuthAuthenticated value)? authAuthenticated,
    TResult? Function(AuthUnauthenticated value)? authUnauthenticated,
  }) {
    return authAuthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult Function(AuthAuthenticated value)? authAuthenticated,
    TResult Function(AuthUnauthenticated value)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authAuthenticated != null) {
      return authAuthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthAuthenticated implements AuthState {
  const factory AuthAuthenticated(
      {required final String token,
      required final String role}) = _$AuthAuthenticatedImpl;

  String get token;
  String get role;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUnauthenticatedImplCopyWith<$Res> {
  factory _$$AuthUnauthenticatedImplCopyWith(_$AuthUnauthenticatedImpl value,
          $Res Function(_$AuthUnauthenticatedImpl) then) =
      __$$AuthUnauthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? error});
}

/// @nodoc
class __$$AuthUnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnauthenticatedImpl>
    implements _$$AuthUnauthenticatedImplCopyWith<$Res> {
  __$$AuthUnauthenticatedImplCopyWithImpl(_$AuthUnauthenticatedImpl _value,
      $Res Function(_$AuthUnauthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_$AuthUnauthenticatedImpl(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthUnauthenticatedImpl implements AuthUnauthenticated {
  const _$AuthUnauthenticatedImpl({this.error});

  @override
  final String? error;

  @override
  String toString() {
    return 'AuthState.authUnauthenticated(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnauthenticatedImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUnauthenticatedImplCopyWith<_$AuthUnauthenticatedImpl> get copyWith =>
      __$$AuthUnauthenticatedImplCopyWithImpl<_$AuthUnauthenticatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(AuthType authType) authToggleAuthType,
    required TResult Function(String token, String role) authAuthenticated,
    required TResult Function(String? error) authUnauthenticated,
  }) {
    return authUnauthenticated(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(AuthType authType)? authToggleAuthType,
    TResult? Function(String token, String role)? authAuthenticated,
    TResult? Function(String? error)? authUnauthenticated,
  }) {
    return authUnauthenticated?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(AuthType authType)? authToggleAuthType,
    TResult Function(String token, String role)? authAuthenticated,
    TResult Function(String? error)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authUnauthenticated != null) {
      return authUnauthenticated(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(AuthToggleAuthType value) authToggleAuthType,
    required TResult Function(AuthAuthenticated value) authAuthenticated,
    required TResult Function(AuthUnauthenticated value) authUnauthenticated,
  }) {
    return authUnauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult? Function(AuthAuthenticated value)? authAuthenticated,
    TResult? Function(AuthUnauthenticated value)? authUnauthenticated,
  }) {
    return authUnauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(AuthToggleAuthType value)? authToggleAuthType,
    TResult Function(AuthAuthenticated value)? authAuthenticated,
    TResult Function(AuthUnauthenticated value)? authUnauthenticated,
    required TResult orElse(),
  }) {
    if (authUnauthenticated != null) {
      return authUnauthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthUnauthenticated implements AuthState {
  const factory AuthUnauthenticated({final String? error}) =
      _$AuthUnauthenticatedImpl;

  String? get error;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUnauthenticatedImplCopyWith<_$AuthUnauthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
