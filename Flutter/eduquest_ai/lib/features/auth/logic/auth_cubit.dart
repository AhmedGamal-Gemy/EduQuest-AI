import 'package:eduquest_ai/features/auth/data/models/signup_request_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/core/networking/dio_factory.dart';
import 'package:eduquest_ai/features/auth/data/models/login_request_body.dart';
import 'package:eduquest_ai/features/auth/data/repos/auth_repo.dart';
import 'package:eduquest_ai/features/auth/logic/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _loginRepo;
  AuthCubit(this._loginRepo) : super(const AuthState.initial());

  void emitLoginStates(LoginRequestBody body) async {
    emit(const AuthState.loading());
    final response = await _loginRepo.login(body);
    response.when(success: (loginResponse) async {
      //! await saveUserToken(loginResponse.userData?.token ?? '');
      emit(AuthState.success(loginResponse));
    }, failure: (error) {
      emit(AuthState.error(error: error.error.message ?? ''));
    });
  }

  void emitSignupStates(SignupRequestBody body) async {
    emit(const AuthState.initial());
    emit(const AuthState.loading());
    final response = await _loginRepo.signup(body);
    response.when(success: (signupResponse) async {
      //! await saveUserToken(loginResponse.userData?.token ?? '');
      emit(AuthState.success(signupResponse));
    }, failure: (error) {
      emit(AuthState.error(error: error.error.message ?? ''));
    });
  }

  // Future<void> saveUserToken(String token) async {
  //   await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
  //   DioFactory.setTokenIntoHeaderAfterAuth(token);
  // }
}
