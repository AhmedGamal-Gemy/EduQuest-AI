import 'package:eduquest_ai/core/routing/app_router.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:eduquest_ai/features/instructor/instructor_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class EduQuestAIApp extends StatelessWidget {
  const EduQuestAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: FlexThemeData.light(scheme: FlexScheme.blackWhite),
      // darkTheme: FlexThemeData.dark(scheme: FlexScheme.blackWhite),
      // themeMode: ThemeMode.system,
      // onGenerateRoute: AppRouter.generateRoute,
      // initialRoute: Routes.authScreen,
      home: InstructorNavbar(),
    );
  }
}
