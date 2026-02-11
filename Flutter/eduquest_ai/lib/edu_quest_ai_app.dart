import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/routing/app_router.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:eduquest_ai/core/theme/app_themes.dart';
// import 'package:eduquest_ai/features/instructor_navbar.dart';
// import 'package:eduquest_ai/features/student_navbar.dart';
import 'package:flutter/material.dart';

class EduQuestAIApp extends StatelessWidget {
  const EduQuestAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: Routes.splashScreen,
      // home: AuthPage(),// AppNavigationBar(role: Role.student),
    );
  }
}
