import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:flutter/material.dart';

Future<void> checkUserAndNavigate(context) async {
  await Future.delayed(const Duration(seconds: 2));
  final userRole = await SharedPrefHelper.getString(SharedPrefKeys.userRole);
  debugPrint("userRole: $userRole: ${userRole == null}");
// getSecuredString
  // if (!mounted) return;
  if (userRole == null) {
    Navigator.pushReplacementNamed(context, Routes.authScreen);
  } else if (userRole == Role.instructor.name) {
    Navigator.pushReplacementNamed(context, Routes.instructorNavbar);
  } else {
    Navigator.pushReplacementNamed(context, Routes.studentNavbar);
  }
}
