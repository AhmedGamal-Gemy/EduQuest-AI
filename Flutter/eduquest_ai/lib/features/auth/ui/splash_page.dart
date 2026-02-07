import 'package:eduquest_ai/core/common/widgets/app_logo.dart';
import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
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
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    final userRole = await SharedPrefHelper.getString(SharedPrefKeys.userRole);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    if (userRole == null) {
      Navigator.pushReplacementNamed(context, Routes.authScreen);
    } else if (userRole == Role.instructor.name) {
      Navigator.pushReplacementNamed(context, Routes.instructorNavbar);
    } else {
      Navigator.pushReplacementNamed(context, Routes.studentNavbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppLogo()),
    );
  }
}
