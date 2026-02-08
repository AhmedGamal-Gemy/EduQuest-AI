import 'package:eduquest_ai/core/common/widgets/app_body.dart';
import 'package:eduquest_ai/core/common/widgets/app_field.dart';
import 'package:eduquest_ai/core/common/widgets/app_glass_card.dart';
import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/auth/logic/auth_states.dart';
import 'package:eduquest_ai/features/auth/ui/widgets/auth_button.dart';
import 'package:eduquest_ai/features/auth/ui/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final authCubit = context.read<AuthCubit>();
    // final authCubit = context.read<AuthCubit>();

    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final authType = state.whenOrNull(authToggleAuthType: (type) => type) ?? AuthType.signin;

          final authCubit = context.read<AuthCubit>();
          return AppBody(
            child: Column(
              children: [
                AuthHeader(authType: authCubit.authType),
                AppGlassCard(
                  child: Form(
                    key: authCubit.formKey,
                    child: Column(
                      children: [
                        if (authCubit.authType == AuthType.signup) ...[
                          AppField(
                            controller: authCubit.firstNameController,
                            hint: "First Name",
                            icon: Icons.person_outline,
                            validator: (v) => v == null || v.isEmpty ? 'Please enter your first name' : null,
                          ),
                          const SizedBox(height: 20),
                          AppField(
                            controller: authCubit.lastNameController,
                            hint: "Last Name",
                            icon: Icons.person_outline,
                            validator: (v) => v == null || v.isEmpty ? 'Please enter your last name' : null,
                          ),
                          const SizedBox(height: 20),
                        ],
                        AppField(
                          controller: authCubit.emailController,
                          hint: "sarah.p@university.edu",
                          icon: Icons.email_outlined,
                          validator: (v) => v == null || v.isEmpty ? 'Please enter a valid email' : null,
                        ),
                        const SizedBox(height: 20),
                        AppField(
                          controller: authCubit.passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          isObscure: true,
                          validator: (v) => v == null || v.isEmpty ? 'Please enter a valid password' : null,
                        ),
                        const SizedBox(height: 24),
                        AuthButtonBlocConsumer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => authCubit.toggleAuthType(),
                  child: Text(
                    authType == AuthType.signin ? "Create your account" : "Already have an account?", // Use from state
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: AppColors.graySoft,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
