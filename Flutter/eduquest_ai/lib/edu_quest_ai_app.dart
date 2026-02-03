// import 'package:eduquest_ai/features/auth/ui/auth_page.dart';
import 'package:eduquest_ai/features/auth/ui/choose_role_page.dart';
import 'package:flutter/material.dart';

class EduQuestAIApp extends StatelessWidget {
  const EduQuestAIApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChooseRolePage(),
    );
  }
}
