import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/features/auth/data/models/login_request_body.dart';
import 'package:eduquest_ai/features/auth/data/models/signup_request_body.dart';
import 'package:eduquest_ai/features/auth/ui/choose_role_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/dio_factory.dart';
import 'package:eduquest_ai/features/auth/data/repos/auth_repo.dart';
import 'package:eduquest_ai/features/auth/logic/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(const AuthState.authInitial());

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Current auth type
  AuthType authType = AuthType.signin;

  void toggleAuthType() {
    authType = authType == AuthType.signin ? AuthType.signup : AuthType.signin;
    formKey.currentState?.reset();
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();

    emit(AuthState.authToggleAuthType(authType: authType)); // Pass authType in the state
  }

  UserRole selectedRole = UserRole.instructor;

  void authSelectedRole() {
    selectedRole = selectedRole == UserRole.instructor ? UserRole.student : UserRole.instructor;
    emit(AuthState.authSelectedRole(selectedRole: selectedRole)); // Pass authType in the state
  }

  Future<void> emitLoginStates() async {
    if (!formKey.currentState!.validate()) return;
    final body = LoginRequestBody(
      username: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    emit(const AuthState.authLoading());
    final response = await _authRepo.login(body);

    response.when(
      success: (authResponse) async {
        emit(
          AuthState.authAuthenticated(
            token: authResponse.accessToken,
            role: authResponse.role,
          ),
        );
      },
      failure: (error) {
        emit(AuthState.authUnauthenticated(
          error: error.error.detail ?? 'Login failed',
        ));
      },
    );
  }

  Future<void> emitSignupStates() async {
    if (!formKey.currentState!.validate()) return;

    final body = SignupRequestBody(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      role: selectedRole.name.toLowerCase(),
    );

    emit(const AuthState.authLoading());
    final response = await _authRepo.signup(body);

    response.when(
      success: (signupResponse) async {
        emit(
          AuthState.authAuthenticated(
            token: signupResponse.accessToken,
            role: signupResponse.role,
          ),
        );
      },
      failure: (error) {
        emit(
          AuthState.authUnauthenticated(
            error: error.error.detail ?? 'Signup failed',
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    await SharedPrefHelper.clear();
    emit(const AuthState.authUnauthenticated());
  }

  // Clear all form fields
  void clearForm() {
    formKey.currentState?.reset();
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    return super.close();
  }
}
