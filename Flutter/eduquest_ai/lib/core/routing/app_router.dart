import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/auth/ui/auth_page.dart';
import 'package:eduquest_ai/features/auth/ui/choose_role_page.dart';
import 'package:eduquest_ai/features/auth/ui/splash_page.dart';
import 'package:eduquest_ai/features/instructor/ui/instructor_navbar.dart';
import 'package:eduquest_ai/features/student/student_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loadingScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ); //Todo: loading page.... from
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        ); //Todo: loading page.... from
      case Routes.authScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: const AuthPage(),
          ),
        );

      case Routes.chooseRole:
        return MaterialPageRoute(
          builder: (_) => const ChooseRolePage(),
        );

      case Routes.instructorNavbar:
        return MaterialPageRoute(
          builder: (_) => const InstructorNavbar(),
        );
      case Routes.studentNavbar:
        return MaterialPageRoute(
          builder: (_) => const StudentNavbar(),
        );
      default:
        return null; //Todo: 404_page.... from
    }
  }
}
