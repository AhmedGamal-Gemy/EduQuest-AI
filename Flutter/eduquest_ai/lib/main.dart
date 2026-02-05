import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/edu_quest_ai_app.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupGetIt();
  runApp(const EduQuestAIApp());
}
