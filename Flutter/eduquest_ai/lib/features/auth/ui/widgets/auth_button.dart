import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/helper/function_helper.dart';
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

    return BlocConsumer<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) {
        state.whenOrNull(
          authAuthenticated: (token, role) {
            authCubit.clearForm();
            // Navigator.pushReplacementNamed(context, Routes.chooseRole);
            checkUserAndNavigate(context);
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
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        errorMessage,
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
