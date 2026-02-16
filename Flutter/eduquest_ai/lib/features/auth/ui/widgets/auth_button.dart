import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/auth/logic/auth_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthButtonBlocConsumer extends StatelessWidget {
  const AuthButtonBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    Future<void> checkUserAndNavigate2(context, String role) async {
      await Future.delayed(const Duration(seconds: 2));
      // final String? userRole = await SharedPrefHelper.getString(SharedPrefKeys.userRole);
      // debugPrint("userRole: $userRole: ${userRole == null}.... role is null");
      // if (!mounted) return;

      if (role == Role.instructor.name) {
        Navigator.pushReplacementNamed(context, Routes.appNavigationBar, arguments: Role.instructor);
      } else {
        Navigator.pushReplacementNamed(context, Routes.appNavigationBar, arguments: Role.student);
      }
    }

    return BlocConsumer<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) {
        state.whenOrNull(
          authAuthenticated: (token, role) {
            debugPrint("authAuthenticated");
            // authCubit.clearForm();
            // Navigator.pushReplacementNamed(context, Routes.chooseRole);
            checkUserAndNavigate2(context, role);
          },
        );
      },
      builder: (context, state) {
        final text = authCubit.authType == AuthType.signin ? "Sign in" : "Sign up";
        final loading = state.maybeWhen(authLoading: () => true, orElse: () => false);
        final errorMessage = state.maybeWhen(authUnauthenticated: (error) => error, orElse: () => null);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () {
                        if (!authCubit.formKey.currentState!.validate()) return;
                        FocusScope.of(context).unfocus();
                        if (authCubit.authType == AuthType.signin) {
                          authCubit.emitLoginStates();
                        } else {
                          authCubit.emitSignupStates();
                        }
                      },
                child: loading ? const CupertinoActivityIndicator(color: AppColors.whiteSoft) : Text(text),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
