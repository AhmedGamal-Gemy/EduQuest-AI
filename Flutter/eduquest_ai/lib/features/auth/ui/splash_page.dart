import 'package:eduquest_ai/core/common/widgets/app_logo.dart';
import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/helper/function_helper.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserAndNavigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(),
            const SizedBox(height: 32),
            Text(
              Constants.appName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intelligent Learning Platform',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.graySoft,
                  ),
            ),
            const SizedBox(height: 40),
            CupertinoActivityIndicator(color: AppColors.whiteSoft)
          ],
        ),
      ),
    );
  }
}
