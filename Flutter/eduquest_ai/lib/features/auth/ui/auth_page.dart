import 'dart:ui';

import 'package:eduquest_ai/core/common/widgets/app_body.dart';
import 'package:eduquest_ai/core/common/widgets/app_field.dart';
import 'package:eduquest_ai/core/common/widgets/app_glass_card.dart';
import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/auth/logic/auth_states.dart';
import 'package:eduquest_ai/features/auth/ui/choose_role_page.dart';
import 'package:eduquest_ai/features/auth/ui/widgets/auth_button.dart';
import 'package:eduquest_ai/features/auth/ui/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final authType = state.whenOrNull(authToggleAuthType: (type) => type) ?? AuthType.signin;
          final selectedRole = state.whenOrNull(authSelectedRole: (type) => type) ?? UserRole.instructor;

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
                        if (authCubit.authType == AuthType.signup) ...[
                          _RoleCard(
                            title: "Instructor",
                            description: "Manage courses, upload materials, and get real-time AI validation.",
                            icon: Icons.present_to_all_rounded,
                            color: const Color(0xFF8B5CF6),
                            selected: selectedRole == UserRole.instructor,
                            onTap: () => authCubit.authSelectedRole(),
                          ),
                          const SizedBox(height: 20),
                          _RoleCard(
                            title: "Student",
                            description: "Join live sessions, gain XP, and ask AI-filtered questions.",
                            icon: Icons.school_rounded,
                            color: const Color(0xFF22D3EE),
                            selected: selectedRole == UserRole.student,
                            onTap: () => authCubit.authSelectedRole(),
                          ),
                        ],
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

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          //Todo CardGlass
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selected ? color.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected ? color : Colors.white10,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
