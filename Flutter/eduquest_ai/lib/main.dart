import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/edu_quest_ai_app.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupGetIt();
  // final initialRoute = await _getInitialRoute();
  runApp(const EduQuestAIApp());
}
// {username: ayhb756_ins@gmail.com, password: ayhb756_ins}
// {username: ayhb756_st1@gmail.com, password: ayhb756_st1}

/// ayaabdelmon_ins@gmail.com | ayaabdelmon_ins
/// ayaabdelmon_st@gmail.com | ayaabdelmon_st@gmail.com




// Future<String> _getInitialRoute() async {
//   final userRole = await SharedPrefHelper.getString(SharedPrefKeys.userRole);
  
//   if (userRole == null) {
//     return Routes.authScreen;
//   } else if (userRole == Role.instructor.name) {
//     return Routes.instructorNavbar;
//   } else {
//     return Routes.studentNavbar;
//   }
// }

// class EduQuestAIApp extends StatelessWidget {
//   final String initialRoute;
  
//   const EduQuestAIApp({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: Constants.appName,
//       debugShowCheckedModeBanner: false,
//       theme: AppThemes.darkTheme,
//       onGenerateRoute: AppRouter.generateRoute,
//       initialRoute: initialRoute,
//     );
//   }
// }