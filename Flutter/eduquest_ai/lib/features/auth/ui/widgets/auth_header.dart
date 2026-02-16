import 'package:eduquest_ai/core/common/widgets/app_logo.dart';
import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final AuthType authType;
  const AuthHeader({super.key, required this.authType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppLogo(),
        const SizedBox(height: 24),
        Text(
          "Welcome to EduQuestAI",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.whiteSoft,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          authType == AuthType.signin ? "Sign in to continue your learning journey." : "Create your account and start learning with us.",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.graySoft,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
