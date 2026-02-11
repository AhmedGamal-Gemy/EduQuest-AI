import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/edu_quest_ai_app.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupGetIt();
  runApp(const EduQuestAIApp());
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: initialize SharedPreferences before runApp
  await SharedPrefHelper.init(); // If your helper has an init method

  runApp(const EduQuestAIApp());
}
//! instructor:  {username: ayhb756_ins7@gmail.com, password: ayhb756_ins7}
// {username: ayhb756_st1@gmail.com, password: ayhb756_st1}

// ayaabdelmon_ins@gmail.com | ayaabdelmon_ins
// ayaabdelmon_st@gmail.com | ayaabdelmon_st@gmail.com
/*
 {
║         "detail": "You are not the instructor of this course"
║    }
 */
